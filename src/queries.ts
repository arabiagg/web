import {SupabaseClient} from "@supabase/supabase-js";
import type {Database} from "~/types/database";

type Client = SupabaseClient<Database>

export function getTournamentWithPhases(supabase: Client, slug: string) {
    return supabase
        .from('tournaments')
        .select(`
        *,
        tournament_phases(*)
      `).eq("slug", slug).limit(1).single()
}

export function searchPlayers(supabase: Client, search: string) {
    return supabase.from('players')
        .select('*')
        .ilike('display_name', `%${search}%`)
}

export function getTournamentParticipants(supabase: Client, tournamentId: string) {
    return supabase.from('tournament_participants')
        .select('*, players(*)')
        .eq('tournament_id', tournamentId)
}
export interface FindMatchesOptions {
    tournament_id?: string
    tournament_phase_id?: string
}
export function findMatches(supabase: Client, options: FindMatchesOptions) {
    let query = supabase.from("matches")
        .select( `*,
        home:tournament_participants!matches_home_participant_id_fkey(*),
        away:tournament_participants!matches_away_participant_id_fkey(*),
        tournament_phases!inner(
            *,
            tournaments!inner(*)
        )
        `)

    if (options.tournament_id) {
        query = query.eq('tournament_phases.tournaments.id', options.tournament_id)
    }
    if (options.tournament_phase_id) {
        query = query.eq('tournament_phases.id', options.tournament_phase_id)
    }

    return query
}
