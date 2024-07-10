<script setup lang="ts">
import type {TournamentSection} from "~/types/tournament_content";
import { Delete, Edit, Plus } from '@element-plus/icons-vue'
import {findMatches, type FindMatchesOptions} from "~/src/queries";
import type {PropType} from "@vue/runtime-core";
import type {MatchWithParticipantsAndTournament} from "~/types/supabase";

const supabase = useSupabaseClient()

const props = defineProps({
  tournamentPhase: String,
  sections: Array as PropType<TournamentSection[]>,
})

const matches = ref({} as { [key: string]: MatchWithParticipantsAndTournament })

if (props.tournamentPhase) {
  const opts: FindMatchesOptions = {
    tournament_phase_id: props.tournamentPhase
  }
  const {data, error} = await findMatches(supabase, opts)
  for (const match of data) {
    matches.value[match.id] = match
  }
}
</script>

<template>
<div>
  <div class="tournament-section" v-for="section of sections">
    <template v-if="section.type === 'markdown'">
      <MDC :value="section.content" />
    </template>
    <template v-if="section.type === 'bracket'">
      <RawBracket :matches="matches" :rounds="section.content" />
    </template>

    <!-- TODO if admin show div -->
    <div v-if="false">
      <el-button type="primary" :icon="Edit" />
      <el-button type="primary" :icon="Delete" />
      <el-button type="primary" :icon="Plus" />
      <el-divider />
    </div>
  </div>
</div>
</template>

<style scoped>

</style>
