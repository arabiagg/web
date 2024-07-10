<script setup lang="ts">
import {
  findMatches, type FindMatchesOptions,
  getTournamentParticipants,
  getTournamentWithPhases
} from "~/src/queries";
import type {MatchWithParticipantsAndTournament} from "~/types/supabase";
import type {SupabaseClient} from "@supabase/supabase-js";
import type {Database} from "~/types/database";
import {getPhaseContent} from "~/src/storage.ts";
import type {TournamentContent} from "~/types/tournament_content.ts";

const supabase: SupabaseClient<Database> = useSupabaseClient<Database>()

const route = useRoute()
const slug = Array.isArray(route.params.slug) ? route.params.slug[0] : route.params.slug

type SectionContent = {
  tournament_phase_id?: string,
  content_path?: string,
}

const matches = shallowRef([] as MatchWithParticipantsAndTournament[])
const matchesLoading = ref(false)
const content = ref(null as TournamentContent)
const selectedSection = ref("Event info")
const selectedPhaseId = ref(null as string)

const {data: tournament_data, error } = await getTournamentWithPhases(supabase, slug);
const sections = {} as { [key: string]: SectionContent }
sections["Event info"] = {}
for (const phase of tournament_data.tournament_phases) {
  sections[phase.name] = { content_path: phase.content_path, tournament_phase_id: phase.id }
}

const { data: participants, error: participantsError } = await getTournamentParticipants(supabase, tournament_data.id)

const tournamentDescription = ref(tournament_data.description)

const showEventInfo = computed(() => selectedSection.value === "Event info")

async function loadSection(section: string) {
  selectedSection.value = section
  content.value = null

  const tournament_phase_id = sections[section].tournament_phase_id

  if (tournament_phase_id) {
    content.value = await getPhaseContent(supabase, tournament_phase_id)
  }

  selectedPhaseId.value = sections[section].tournament_phase_id
}

async function loadMatches() {
  const opts: FindMatchesOptions = {
    tournament_id: tournament_data.id
  }

  matchesLoading.value = true

  const { data: resultMatches } = await findMatches(supabase, opts)
  matches.value = resultMatches

  matchesLoading.value = false
}

async function debugMatchCreate() {
  const { data, error } = await supabase.from('tournament_phases').insert({
    id: '8da140f7-de82-435d-9089-f92f050f2ad7',
    name: 'Test phase',
    tournament_id: tournament_data.id,
    type: 'MAIN_EVENT'
  }).select().single()

  if (error) {
    console.error("create err", error)
    return
  }

  const { data: invokeResult, error: invokeError } = await supabase.functions.invoke('create-bracket', {
    body: {
      participants: participants.map(p => p.id),
      tournament_phase_id: data.id
    }
  })

  if (invokeError) {
    console.error("invoke error", invokeError)
  }

  console.log("invoke result", invokeResult)
}
async function debugMatchAdvance() {
  const { data: invokeResult, error: invokeError } = await supabase.functions.invoke('advance-matches', {
    body: {
      tournament_phase_id: '8da140f7-de82-435d-9089-f92f050f2ad7'
    }
  })

  if (invokeError) {
    console.error("invoke error", invokeError)
  }

  console.log("invoke result", invokeResult)
}

</script>

<template>
<ElSegmented class="mb-6" v-model="selectedSection" :options="Object.keys(sections)" block @change="loadSection"/>
  <template v-if="showEventInfo">
    <div class="mb-4">
      <div class="lg:text-2xl">{{ tournament_data.name }}</div>
      {{ tournamentDescription }}
    </div>
    <ElRow>
      <ElCol :span="15">
        <div class="grid-content ep-bg-purple">


          <ElCard shadow="none">
            <template #header>
              <div class="card-header">
                <span class="header font-semibold">Matches</span>
              </div>
            </template>

            <ElButton :disabled="matchesLoading" v-if="matches.length === 0" @click="loadMatches">Show matches</ElButton>
            <template v-else>
              <div v-for="match of matches" :key="match.id">
                {{ match.home.name }} [{{ match.home_score }} - {{ match.away_score }}] {{ match.away.name }}
              </div>
            </template>
            <ElButton @click="debugMatchCreate">Create</ElButton>
            <ElButton @click="debugMatchAdvance">Advance</ElButton>

          </ElCard>
        </div>

      </ElCol>
      <ElCol :span="1" />
      <ElCol :span="8">
        <ElCard >
          <template #header>
            <div class="card-header">
              <span class="header font-semibold">Participants</span>
            </div>
          </template>
          <div style="max-height: 200px; overflow-y: auto;">
            <p v-for="participant in participants" :key="participant.id" class="text item">
              {{ participant.name }}
            </p>
          </div>
        </ElCard>
      </ElCol>
    </ElRow>
  </template>
  <template v-else-if="content !== null">
    <TournamentContent :tournament-phase="selectedPhaseId" :sections="content.sections" />
  </template>
  <template v-else>
    <ElSkeleton :rows="5" animated />
  </template>
</template>

