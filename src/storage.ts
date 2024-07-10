import {SupabaseClient} from "@supabase/supabase-js";
import type {Database} from "~/types/database";
import type {TournamentContent} from "~/types/tournament_content";

type Client = SupabaseClient<Database>

enum Bucket {
    TOURNAMENT_CONTENT = 'tournament_content'
}

const tournamentContentPath = (tournament_phase_id: string) => `${tournament_phase_id}/content.json`
export async function setPhaseContent(supabase: Client, tournament_phase_id: string, content: TournamentContent) {
    const file_path = tournamentContentPath(tournament_phase_id)
    const file_content= new Blob([JSON.stringify(content, null, 2)], {type: "application/json"})

    return await supabase.storage.from(Bucket.TOURNAMENT_CONTENT)
        .upload(file_path, file_content, {
            upsert: true
        })
}

export async function getPhaseContent(supabase: Client, tournament_phase_id: string) {
    const file_path = tournamentContentPath(tournament_phase_id)

    const { data } = supabase.storage.from(Bucket.TOURNAMENT_CONTENT).getPublicUrl(file_path)
    const response = await fetch(data.publicUrl)
    const contentJson = await response.json()

    if (!contentJson.hasOwnProperty("sections") || !Array.isArray(contentJson.sections)) {
        throw new Error("tournament content has unexpected structure")
    }

    return contentJson as TournamentContent
}
