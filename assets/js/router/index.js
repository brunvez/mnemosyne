import Vue from 'vue';
import Router from 'vue-router';
import SignUp from 'Pages/SignUp.vue';
import SignIn from 'Pages/SignIn.vue';
import Home from 'Pages/Home.vue';
import store from 'Store';
import {
  HOME,
  SIGN_IN,
  SIGN_UP } from './routes';

Vue.use(Router);

function assureLoggedIn(_to, _from, next) {
  if (store.state.session.token === null) {
    next(SIGN_IN);
  } else {
    next();
  }
}

function assureNotLoggedIn(_to, _from, next) {
  if (store.state.session.token === null) {
    next();
  } else {
    next(HOME);
  }
}

export default new Router({
  mode: 'history',
  base: process.env.BASE_URL,
  routes: [
    {
      path: HOME,
      name: 'home',
      beforeEnter: assureLoggedIn,
      component: Home
    },
    {
      path: SIGN_UP,
      name: 'sign-up',
      beforeEnter: assureNotLoggedIn,
      component: SignUp
    },
    {
      path: SIGN_IN,
      name: 'sign-in',
      beforeEnter: assureNotLoggedIn,
      component: SignIn,
      props: true
    }
  ],
});
