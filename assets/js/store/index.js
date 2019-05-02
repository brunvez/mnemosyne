import Vue from 'vue';
import Vuex from 'vuex';
import { SET_CURRENT_USER, SET_SESSION } from './mutations';

Vue.use(Vuex);

export default new Vuex.Store({
  state: {
    session: {
      token: null
    }
  },
  mutations: {
    [SET_SESSION]: function(state, { token }) {
      state.session.token = token;
    },

    [SET_CURRENT_USER]: function(state, { user }) {
      state.session.currentUser = user;
    }
  }
});
