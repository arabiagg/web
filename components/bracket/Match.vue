<script setup lang="ts">
import {type BracketNode} from "~/types/tournament_content";
import type {PropType} from "vue";
import type {Participant} from "~/types/supabase";

const emit = defineEmits(['onMouseoverTeam'])
const props = defineProps({
  selectedTeam: Object as PropType<Participant>,
  node: Object as PropType<BracketNode>
})

const isHomeSelected = computed(() => {
  return props.selectedTeam && props.selectedTeam.name === "A"
})
const isSelected = (team: Participant|null): boolean => {
  if (!team) {
    return false
  }
  return props.selectedTeam && props.selectedTeam.name === team.name
}

</script>

<template>
<div class="match" :class="{ghost: node.is_ghost}">
  <template v-if="!node.is_ghost">
    <template v-if="node.match">
      <div class="team" :class="{ 'team-selected': isSelected(node.match.home)}"
           @mouseenter="node.match.home && emit('onMouseoverTeam', node.match.home)"
           @mouseleave="emit('onMouseoverTeam', null)"
      >
        <span class="image"></span>
        <span class="seed">{{ node.match?.home?.seed ?? "" }}</span>
        <span class="name">{{ node.match?.home?.name ?? "" }}</span>
        <span class="score">{{ node.match.home_score }}</span>
      </div>
      <div class="team"
           :class="{ 'team-selected': isSelected(node.match.away)}"
           @mouseenter="node.match.away && emit('onMouseoverTeam', node.match.away)"
           @mouseleave="emit('onMouseoverTeam', null)"
      >
        <span class="image"></span>
        <span class="seed">{{ node.match?.away?.seed }}</span>
        <span class="name">{{ node.match?.away?.name }}</span>
        <span class="score">{{ node.match.away_score }}</span>
      </div>
    </template>
    <div v-else class="tbd">TBD</div>

    <div class="match-lines" v-if="!node.last_round">
      <div class="line one"></div>
      <div class="line two"></div>
    </div>
    <div class="match-lines alt" v-if="!node.first_round">
      <div class="line one"></div>
    </div>
  </template>
</div>
</template>

