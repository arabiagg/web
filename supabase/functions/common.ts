import { json } from 'https://deno.land/x/sift@0.6.0/mod.ts'
import { createClient } from 'jsr:@supabase/supabase-js@2'

import type {SupabaseClient} from "@supabase/supabase-js";
import type {Database} from "~/types/database";

const corsHeaders = {
    'Access-Control-Allow-Origin': '*',
    'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
}
export function errorResponse(message: string, code: number = 500) {
    return json({ message, code }, {
        headers: {...corsHeaders},
        status: code
    })
}

export function okResponse(body: any = {}) {
    return new Response(JSON.stringify(body), {
        headers: { ...corsHeaders, 'Content-Type': 'application/json' },
    })
}

export function newClientFromRequest(req: Request): SupabaseClient<Database> {
    const authHeader = req.headers.get('Authorization')!
    return createClient<Database>(
        Deno.env.get('SUPABASE_URL') ?? '',
        Deno.env.get('SUPABASE_ANON_KEY') ?? '',
        { global: { headers: { Authorization: authHeader } } }
    )
}
