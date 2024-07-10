<script setup lang="ts">
import {searchPlayers} from "~/src/queries";

const props = defineProps<{
  allowUnknown: boolean
  allowMultiple: boolean
}>()
const value = defineModel()

const supabase = useSupabaseClient()

const options = ref([])
const isLoading = ref(false)

const findPlayers = async (search: string) => {
  isLoading.value = true

  const {data, error} = await searchPlayers(supabase, search);
  options.value = data.map((player) => ({ value: player.id, label: player.display_name}) )

  isLoading.value = false
}


</script>

<template>
<ClientOnly>
  <ElSelectV2
    v-model="value"
    filterable
    :options="options"
    remote :remote-method="findPlayers"
    :loading="isLoading"
    :multiple="props.allowMultiple"
    :allow-create="props.allowUnknown"
  >
  </ElSelectV2>
</ClientOnly>
</template>

<style scoped lang="postcss">

</style>
