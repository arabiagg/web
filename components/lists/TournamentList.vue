<script setup lang="ts">
import type {PropType} from "@vue/runtime-core";

const now = new Date()

const props = defineProps({
  tournaments: Array as PropType<Tournament[]>
})

function dateFormat(tournament: Tournament): string {
  if (!tournament.start_date || !tournament.end_date) {
    return ""
  }

  const start = new Date(Date.parse(tournament.start_date))
  const end = new Date(Date.parse(tournament.end_date))

  let options: Intl.DateTimeFormatOptions = { day: "numeric", month: "short" }
  if (end.getFullYear() !== now.getFullYear()) {
    options.year = "2-digit"
  }

  return start.toLocaleString('en-GB', options)
    + " - " + end.toLocaleString('en-GB', options)
}

</script>

<template>
  <ElCard
      v-for="tournament of tournaments" :key=tournament
      shadow="hover"
      class="mb-4"
  >
    <template #header>
      <a href="#" class="lg:text-xl" @click="navigateTo('/tournament/' + tournament.slug)">{{ tournament.name }}</a>
      <span class="float-end">{{ dateFormat(tournament) }}</span>

    </template>
    {{ tournament.description }}
  </ElCard>
</template>
