// Follow this setup guide to integrate the Deno language server with your editor:
// https://deno.land/manual/getting_started/setup_your_environment
// This enables autocomplete, go to definition, etc.
interface AdvanceMatchesRequest {
  tournament_phase_id: string
}

import {findMatches} from "~/src/queries.ts";
import "https://esm.sh/@supabase/functions-js/src/edge-runtime.d.ts"
import {errorResponse, newClientFromRequest, okResponse} from "../common.ts";
import type {Match, MatchInfo} from "~/types/supabase";



Deno.serve(async (req: Request) => {
  if (req.method === 'OPTIONS') {
    return okResponse()
  }

  const supabase = newClientFromRequest(req)
  const { tournament_phase_id } = await req.json() as AdvanceMatchesRequest

  const { data: matches , error: selectMatchesError} = await findMatches(supabase, { tournament_phase_id })
  if (selectMatchesError) {
    console.log("selectMatchesError")
    errorResponse(selectMatchesError.message)
  }

  const matchMap: {[key: string]: Match} = {}
  for (const match of matches) {
    matchMap[match.id] = match
  }

  const getMatchWinner = (matchId: string): string => {
    const match = matchMap[matchId] ?? null
    if (!match) {
      return null
    }
    if (!match.home_score && !match.away_score) {
      return null;
    }

    return (match.home_score > match.away_score)
        ? match.home_participant_id
        : match.away_participant_id
  }

  for (const match of matches) {
    const matchInfo = match.info as MatchInfo
    if (!match.home_participant_id && matchInfo.home_previous_win) {
      match.home_participant_id = getMatchWinner(matchInfo.home_previous_win)
    }

    if (!match.away_participant_id && matchInfo.away_previous_win) {
      match.away_participant_id = getMatchWinner(matchInfo.away_previous_win)
    }
  }

  const upsertValues = Object.values(matchMap).map(
      m => ({
        id: m.id,
        home_participant_id: m.home_participant_id,
        away_participant_id: m.away_participant_id,
      } as Match)
  )
  const { data: upsertData, error: upsertError } = await supabase.from('matches').upsert(upsertValues)
  if (upsertError) {
    return errorResponse(upsertError.message)
  }

  return okResponse(upsertData)
})

