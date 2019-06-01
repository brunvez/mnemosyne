// import alertify from 'alertifyjs';
import css from '../css/app.css';
import 'phoenix_html';
// import Vue from 'vue';
// import App from './App.vue';
// import router from 'Router';
// import store from 'Store'
import $ from 'jquery'
import selectize from 'selectize'
import selectizeCss from 'selectize/dist/css/selectize.css'


// alertify.set('notifier','position', 'top-right');
// Vue.prototype.$alert = alertify;

// new Vue({
//   router,
//   store,
//   render: h => h(App),
// }).$mount('#app');

$(function () {
  $('#memory_tags').selectize({
    delimiter: ',',
    persist: false,
    create: function(input) {
      return {
          value: input,
          text: input
      }
    }
  })
})
