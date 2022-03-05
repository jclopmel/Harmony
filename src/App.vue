<template>
  <v-app>
    <AppBar/>
    <v-main>
      <router-view></router-view>  
      <!-- <Store/> -->
    </v-main>
  </v-app>
</template>

<script>
// import Dashboard from './components/Dashboard';
// import Store from './components/Store';
import AppBar from './components/AppBar';

export default {
  name: 'App',

  components: {
    // Dashboard,
    // Store,
    AppBar,
  },

  data: () => ({
    //
  }),
};
</script>
