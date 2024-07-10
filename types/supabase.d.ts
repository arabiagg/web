import type {Database} from "~/types/database";

export type Match = Database["public"]["Tables"]["matches"]["Row"]
export type MatchInsert = Database["public"]["Tables"]["matches"]["Insert"]

export type Participant = Database["public"]["Tables"]["tournament_participants"]["Row"]
export type Tournament = Database["public"]["Tables"]["tournaments"]["Row"]
export type Phase = Database["public"]["Tables"]["tournament_phases"]["Row"]

export type TournamentTier = Database["public"]["Enums"]["tournament_tier"]
export type SignupMethod = Database["public"]["Enums"]["signup_method"]
export type PhaseType = Database["public"]["Enums"]["phase_type"]

export type PhaseWithTournament = Phase & {
    tournaments: Tournament
}

export type MatchWithParticipantsAndTournament = Match & {
    home: Participant
    away: Participant
    tournament_phases: PhaseWithTournament
}

export interface MatchInfo {
    home_previous_win?: string,
    away_previous_win?: string
}
