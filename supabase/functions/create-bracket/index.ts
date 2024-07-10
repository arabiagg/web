import {setPhaseContent} from "../../../src/storage.ts";

/**
 * This function creates a bracket for the provided participants and tournament phase.
 *
 * It creates the Match resources for the full bracket, using `info.home_previous_win` and `info.away_previous_win` to
 * link the matches.
 *
 * It also creates a bracket section for the tournament phase content storage-object.
 */
interface CreateBracketRequest {
  tournament_phase_id: string
  participants: string[]
}

import "https://esm.sh/@supabase/functions-js/src/edge-runtime.d.ts"
import {errorResponse, newClientFromRequest, okResponse} from "../common.ts"
import type {Participant, MatchInsert, MatchInfo} from "~/types/supabase";
import type { BracketSection, BracketRound } from "~/types/tournament_content"

const SEEDING_TEMPLATE_64_PARTICIPANTS = [
  [1,64], [32,33], [17,48], [16,49], [9,56], [24,41], [25,40], [8,57], [4,61], [29,36], [20,45], [13,52], [12,53], [21,44], [28,37], [5,60], [2,63], [31,34], [18,47], [15,50], [10,55], [23,42], [26,39], [7,58], [3,62], [30,35], [19,46], [14,51], [11,54], [22,43], [27,38], [6,59]
]

interface MatchTemplate {
  id: string
  home_participant?: Participant
  away_participant?: Participant
  isBye?: boolean
  home_previous_win?: string,
  away_previous_win?: string,
}
function getSeedingTemplate(numberOfPlayers: number) {
  let templateParticipants = 64
  let seedingTemplate = SEEDING_TEMPLATE_64_PARTICIPANTS

  // We ceil to the closest power of 2, to include bye-rounds
  numberOfPlayers = 2 ** Math.ceil(Math.log2(numberOfPlayers))

  // Advance lowest seeds from each match-up to make bracket smaller
  while (templateParticipants > numberOfPlayers) {
    const newSeedingTemplate = []

    for (let i=0; i+1<seedingTemplate.length; i+=2) {
      // Lowest seeds from each match
      const p1 = seedingTemplate[i][0]
      const p2 = seedingTemplate[i+1][0]

      const match = p1 < p2 ? [p1, p2] : [p2, p1]
      newSeedingTemplate.push(match)
    }

    templateParticipants = templateParticipants / 2
    seedingTemplate = newSeedingTemplate
  }

  return seedingTemplate
}

function seedParticipants(participants: Participant[]) {
  const seedingTemplate = getSeedingTemplate(participants.length)
  const rounds = [] as MatchTemplate[][]
  let roundMatches = [] as MatchTemplate[]

  seedingTemplate.forEach((matchTemplate, matchIndex) => {
    const homeIdx = matchTemplate[0]-1
    const awayIdx = matchTemplate[1]-1

    roundMatches.push({
      id: crypto.randomUUID(),
      home_participant: participants[homeIdx],
      away_participant: participants[awayIdx],
      isBye: awayIdx >= participants.length,
    })
  })

  rounds.push(roundMatches)
  while (roundMatches.length > 1) {
    const newMatchRound = []

    for (let i=0; i+1<roundMatches.length; i+=2) {
      const homeMatch = roundMatches[i]
      const awayMatch = roundMatches[i+1]

      const match: MatchTemplate = {
        id: crypto.randomUUID(),
      }
      if (homeMatch.isBye) {
        match.home_participant = homeMatch.home_participant
      } else {
        match.home_previous_win = homeMatch.id
      }

      if (awayMatch.isBye) {
        match.away_participant = awayMatch.away_participant
      } else {
        match.away_previous_win = awayMatch.id
      }

      newMatchRound.push(match)
    }

    roundMatches = newMatchRound
    rounds.push(roundMatches)
  }

  return rounds
}

function createBracketSection(matchRounds: MatchTemplate[][]): BracketSection {
  const section: BracketSection = {
    type: 'bracket',
    content: []
  }

  let counter = 0
  for (const matchTemplates of matchRounds) {
    counter++
    const bracketRound: BracketRound = {
      name: 'Round ' + counter,
      matches: matchTemplates.map(m => ({
        id: m.id,
        first_round: !m.home_previous_win && !m.away_previous_win,
        last_round: counter === matchRounds.length,
        is_ghost: m.isBye
      }))
    }

    section.content.push(bracketRound)
  }

  return section
}


Deno.serve(async (req: Request) => {
  if (req.method === 'OPTIONS') {
    return okResponse()
  }

  const supabase = newClientFromRequest(req)

  const { tournament_phase_id, participants} = await req.json() as CreateBracketRequest
  const { data: participantsData, error:getParticipantsError } = await supabase.from('tournament_participants')
      .select('*, players(*)')
      .in('id', participants)
      .order('seed', { ascending: true })

  if (getParticipantsError) {
    return errorResponse(getParticipantsError.message)
  }

  if (participantsData.length !== participants.length) {
    return errorResponse('could not find all the provided participants')
  }

  const matchRounds = seedParticipants(participantsData)

  const matchInserts = [] as MatchInsert[]
  for (const matches of matchRounds) {
    for (const match of matches) {
      if (match.isBye) {
        continue
      }

      matchInserts.push({
        id: match.id,
        home_participant_id: match.home_participant ? match.home_participant.id : null,
        away_participant_id: match.away_participant ? match.away_participant.id : null,
        tournament_phase_id,
        info: {
          home_previous_win: match.home_previous_win,
          away_previous_win: match.away_previous_win
        } as MatchInfo
      })
    }
  }

  const { data, error: uploadError} = await setPhaseContent(supabase, tournament_phase_id, {
    sections: [createBracketSection(matchRounds)]
  })
  if (uploadError) {
    return errorResponse(uploadError.message)
  }

  const { error: matchInsertError } = await supabase.from('matches').insert(matchInserts)
  if (matchInsertError) {
    return errorResponse(matchInsertError.message)
  }

  return okResponse()
})
