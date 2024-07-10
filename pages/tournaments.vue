<script setup lang="ts">
import TournamentList from "~/components/lists/TournamentList.vue";
import type {Database} from "~/types/database";

const client = useSupabaseClient<Database>()

const { data: tournaments } = await useAsyncData('tournaments', async () => {
  const { data: tournaments } = await client.from('tournaments').select('*').order('created_at').returns<Tournament[]>()
  return tournaments
})

</script>

<template>
  <div class="w-full my-[50px]">
    <TournamentList :tournaments="tournaments" />
  </div>
</template>

<style lang="postcss">
ul > li:last-child {
  @apply border-b-0;
}
</style>
