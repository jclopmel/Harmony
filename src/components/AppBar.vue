<template>
   <v-app-bar
      app
      color="grey darken-3"
      dark
    >
      <div class="d-flex align-center">
        <v-img
          alt="Vuetify Logo"
          class="shrink mr-2"
          contain
          src="@/assets/logo.png"
          transition="scale-transition"
          width="40"
        />
        <v-toolbar-title>{{webPageTitle}}</v-toolbar-title>
      </div>

      <v-spacer></v-spacer>
    </v-app-bar>
</template>

<script>
  export default {
    name: 'AppBar',
    components: {
    },
    data: () => ({
      webPageTitle: "The Art Place"
    }),
    methods:{

    }
  }
</script>
