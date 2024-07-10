<script setup lang="ts">
import { ref, computed } from 'vue'
import { ArrowDown } from '@element-plus/icons-vue'
const supabase = useSupabaseClient()
const user = useSupabaseUser()

const debugUser = async () => {
  console.log("user", user.value)
  console.log("metauser", user.value.user_metadata)
}
const signOut = async () => {
  const { error } = await supabase.auth.signOut()


  if (error === null) {
    ElMessage({
      message: "Logged out!",
      type: "success",
    })

    navigateTo("/")
    return
  }

  ElMessage({
    message: "Failed to log out",
    type: "error",
  })
}

const loginDialogVisible = ref(false)

</script>

<template>
  <ElRow>
    <ElCol :span="16">
      <ElMenu
          :default-active="$route.fullPath"
          :router="true"
          class="el-menu-demo"
          mode="horizontal"
      >
        <ElMenuItem route="/" index="/">Home</ElMenuItem>
        <ElMenuItem route="/tournaments" index="/tournaments">Tournaments</ElMenuItem>
        <ElMenuItem route="/players" index="/players">Players</ElMenuItem>
        <ElTooltip
            class="box-item"
            effect="dark"
            content="Coming soon"
            placement="top-start"
        >
          <ElMenuItem index="3" disabled>Statistics</ElMenuItem>
        </ElTooltip>
      </ElMenu>
    </ElCol>

    <ElCol :span="8">
      <ElMenu
          :close-on-click-outside="false"
          class="el-menu-demo"
          mode="horizontal"
          style="flex-direction: row-reverse"
          :ellipsis-icon="ArrowDown"
      >
        <ElMenuItem v-if="!user" index="1" @click="loginDialogVisible = true;">Login</ElMenuItem>
        <ElSubMenu v-if="user" index="2">
          <template #title>{{ user.user_metadata["full_name"] ?? "Account" }}</template>
          <ElMenuItem index="2-1" @click="navigateTo('/tournament/new')">New tournament</ElMenuItem>
          <ElMenuItem index="2-3" @click="signOut()">Log out</ElMenuItem>
        </ElSubMenu>
      </ElMenu>
    </ElCol>
  </ElRow>


  <ElDialog v-model="loginDialogVisible" width="30%" style="min-width: 500px">
    <LoginForm @onLoginSuccess="loginDialogVisible = false" />
  </ElDialog>
</template>
