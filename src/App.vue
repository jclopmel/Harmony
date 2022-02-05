<template>
  <v-app>
    <AppBar/>
    <v-main>
      <Store/>
    </v-main>
  </v-app>
</template>

<script>
import Store from './components/Store';
import AppBar from './components/AppBar';

export default {
  name: 'App',

  components: {
    Store,
    AppBar,
  },

  data: () => ({
    //
  }),
};
</script>
