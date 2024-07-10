<script setup lang="ts">
import {type BracketRound, type BracketNode} from "~/types/tournament_content";
import type {PropType} from "@vue/runtime-core";
import type {MatchWithParticipantsAndTournament, Participant} from "~/types/supabase";

const props = defineProps({
  matches: Object as PropType<{ [key: string]: MatchWithParticipantsAndTournament }>,
  rounds: Array as PropType<BracketRound[]>,
})

const selectedTeam = ref(null as Participant)
function teamSelect(team: Participant|null) {
  selectedTeam.value = team
}

function inflateMatch(bracketNode: BracketNode) {
  bracketNode.match = props.matches ? props.matches[bracketNode.id] : null
  return bracketNode
}


</script>

<template>
<div class="bracket-headers">
  <div class="bracket-header" v-for="(round, idx) in rounds">
    <div>{{ round.name }}</div>
  </div>
</div>
<div class="bracket">
  <div class="bracket-round" v-for="round in rounds">
    <BracketMatch v-for="match of round.matches" :node="inflateMatch(match)" :selected-team="selectedTeam" @onMouseoverTeam="teamSelect" />
  </div>
</div>
</template>

<style scoped>

</style>
