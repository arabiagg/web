export default defineNuxtConfig({
  modules: [
    '@nuxtjs/supabase',
    '@nuxtjs/mdc',
    '@nuxt/ui',
    '@element-plus/nuxt',
    '@nuxtjs/color-mode',
    "@nuxt/image"
  ],
  plugins: [
  ],
  css: ['~/assets/scss/index.scss', '~/assets/scss/bracket/brackets.scss'],
  runtimeConfig: {
    public: {
      baseUrl: process.env.BASE_URL || 'http://localhost:3000',
    },
  },
  elementPlus: {
    themes: ['dark'],
    importStyle: 'scss'
  },
  ui: {
    icons: ['mdi', 'heroicons', 'heroicons-outline'],
  },
  supabase: {
    redirect: false
    /*redirectOptions: {
      login: '/',
      callback: '/confirm',
    },*/
  },
  vite: {
    css: {
      preprocessorOptions: {
        scss: {
          additionalData: `@use "@/assets/scss/element/index.scss" as element;`,
        },
      },
    },
  },
  colorMode: {
    preference: 'system',
    fallback: 'light',
  },
  telemetry: false,
})