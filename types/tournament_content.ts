import type { MatchWithParticipantsAndTournament } from "~/types/supabase";

export type TournamentContent = {
    sections: TournamentSection[]
}
export type TournamentSection = MarkdownSection | BracketSection

export type MarkdownSection = {
    type: 'markdown'
    content: string
}

export type BracketSection = {
    type: 'bracket'
    content: BracketRound[]
}

export interface BracketRound {
    name: string
    matches: BracketNode[]
}

export interface BracketNode {
    id: string
    first_round?: boolean
    last_round?: boolean
    is_ghost?: boolean

    // to inflate with database data
    match?: MatchWithParticipantsAndTournament
}
