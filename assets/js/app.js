import alertify from 'alertifyjs';
import css from '../css/app.css';
import 'phoenix_html';
import Vue from 'vue';
import App from './App.vue';
import router from 'Router';
import store from 'Store'

alertify.set('notifier','position', 'top-right');
Vue.prototype.$alert = alertify;

new Vue({
  router,
  store,
  render: h => h(App),
}).$mount('#app');
