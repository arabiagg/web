<script setup lang="ts">
import type {FormInstance, FormRules} from "element-plus";
import type {SignupMethod, TournamentTier} from "~/types/supabase";
import type {Database} from "~/types/database.d.ts";
import type {SupabaseClient} from "@supabase/supabase-js";

definePageMeta({
  middleware: 'auth'
})

const supabase: SupabaseClient<Database> = useSupabaseClient<Database>()

const formRef = ref<FormInstance>()

// TODO take values from database enums in /types/supabase.types.ts
const signupMethods = [{ label: "Invite only", value: "INVITE_ONLY" }, { label: "Open registration", value: "OPEN_REGISTRATION"}]
const tournamentTiers = [{ label: "Community", value: 'COMMUNITY'}]

interface TournamentForm {
  name: string
  description: string
  signup_method: SignupMethod
  tier: TournamentTier
  start_end_dates: Date[]
}

const formRules = reactive<FormRules<TournamentForm>>({
  name: [
    { required: true, message: 'Please input a tournament name' },
    { min: 4, max: 25, message: 'Name length should be between 4 and 25 characters' },
  ],
  signup_method: [
    { required: true, message: 'Please select a signup method' },
  ],
  tier: [
    { required: true, message: 'Please select a tournament tier' },
  ],
  start_end_dates: [
    { required: true, message: 'Please fill a date range.' },
  ]
})

const form = reactive<TournamentForm>({
  name: '',
  description: '',
  signup_method: 'INVITE_ONLY',
  tier: 'COMMUNITY',
  start_end_dates: [],
})

const createTournament = async () => {

    await formRef.value.validate(async (valid, fields) => {
      if (valid) {
        const slug = form.name.toLowerCase().replace(" ", "_")

        const { data, error } = await supabase.from('tournaments')
            .insert({
              name: form.name,
              slug: slug,
              description: form.description,
              start_date: form.start_end_dates[0].toISOString(),
              end_date: form.start_end_dates[1].toISOString(),
              tier: form.tier
            }).select().single()

        if (error !== null) {
          ElMessage({message: 'Failed to create the tournament', type: 'error'})
          return
        }
        navigateTo(`/tournament/${data.slug}`)
      }
    })
  }

</script>

<template>
  <div class="lg:text-xl mt-4">New tournament</div>
  <ElDivider />

  <ElForm ref="formRef" :model="form" label-width="auto" :rules="formRules">

    <ElFormItem label="Name" prop="name" >
      <ElInput v-model="form.name" />
    </ElFormItem>

    <ElFormItem label="Description" prop="description" >
      <ElInput v-model="form.description" />
    </ElFormItem>

    <ElFormItem label="Start/end dates" style="max-width: 600px" prop="start_end_dates">
      <ElDatePicker
          v-model="form.start_end_dates"
          type="daterange"
          range-separator="To"
          start-placeholder="Start date"
          end-placeholder="End date"
      />
    </ElFormItem>

    <ElFormItem label="Signup method" prop="signup_method">
      <ElSelect
          v-model="form.signup_method"
          placeholder="Select"
          style="width: 240px"
      >
        <ElOption v-for="item in signupMethods" :key="item.value" :label="item.label" :value="item.value" />
      </ElSelect>
    </ElFormItem>

    <ElFormItem label="Tier" prop="tier">
      <ElSelect
          v-model="form.tier"
          placeholder="Select"
          style="width: 240px"
      >
        <ElOption v-for="item in tournamentTiers" :key="item.value" :label="item.label" :value="item.value" />
      </ElSelect>
    </ElFormItem>

    <ElFormItem>
      <ElButton type="primary" @click="createTournament()">Create tournament</ElButton>
    </ElFormItem>
  </ElForm>
</template>

<style lang="postcss">
ul > li:last-child {
  @apply border-b-0;
}
</style>
