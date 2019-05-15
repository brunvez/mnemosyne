<template>
  <div>
      <h1> Sign In </h1>
      
      <label>
        Email
        <div class="validation-error" v-if="emailError">{{ emailError }}</div>
        <input v-model="email" @keyup.enter="submit()" class="inline" type="email"/>
      </label>

      <label>
        Your password
        <div class="validation-error" v-if="passwordError">{{ passwordError }}</div>
        <input v-model="password" @keyup.enter="submit()" class="inline" type="password"/>
      </label>
      
      <div class="actions">
        <button class="button button--black" @click="submit()">Submit</button>
        <span>Don't have an account? <router-link v-bind:to="signUpPath">Sign up</router-link></span>
      </div>
  </div>
</template>

<script>
  import { mapMutations } from 'vuex';
  import { createSession } from 'Services/session';
  import { INVALID_ENTITY, UNAUTHORIZED } from 'Services/errorReasons';
  import { SET_SESSION } from 'Store/mutations';
  import { HOME, SIGN_UP } from 'Router/routes';

  export default {
    data() {
      return {
        email: this.signUpEmail() || '',
        password: '',
        emailError: null,
        passwordError: null,
        signUpPath: SIGN_UP
      }
    },

    methods: {
      ...mapMutations({
        setSession: SET_SESSION
      }),

      signUpEmail() {
        const currentUser = this.$store.state.session.currentUser;
        return currentUser && currentUser.email;
      },

      async submit() {
        this.resetErrors();
        this.$parent.$emit('request:started');
        try {
          const { data } = await createSession(this.email, this.password);
          this.$parent.$emit('request:successful');
          this.setSession(data);
          this.$router.push({ path: HOME });
        } catch(error) {
          this.$parent.$emit('request:failed');
          this.showErrors(error);
        }
      },
      
      resetErrors() {
        this.emailError = null;
        this.passwordError = null;
      },

      showErrors(error) {
        switch(error.reason) {
          case INVALID_ENTITY:
          Object.keys(error.payload).forEach((attribute) => {
            this[attribute + 'Error'] = error.payload[attribute][0];
          });
          break;
          case UNAUTHORIZED:
            this.$alert.error(error.payload);
          break;
          default:
          console.error('Unknown error', error);
          this.$alert.error('Something unexpected happend');
        }
      }
    }
  }
</script>