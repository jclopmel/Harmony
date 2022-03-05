import Vue from 'vue'
import App from './App.vue'
import vuetify from './plugins/vuetify'
import VueRouter from 'vue-router'
import Routes from './routes'

Vue.use(VueRouter);

Vue.config.productionTip = false

const router = new VueRouter({
  routes: Routes
})

new Vue({
  vuetify,
  render: h => h(App),
  router: router
}).$mount('#app')
