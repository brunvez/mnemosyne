<template>
  <div>
      <h1> Sign Up </h1>
      
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
      
      <label>
        Password confirmation
        <div class="validation-error" v-if="passwordConfirmationError">{{ passwordConfirmationError }}</div>
        <input v-model="passwordConfirmation" @keyup.enter="submit()" class="inline" type="password"/>
      </label>

      <div class="actions">
        <button @click="submit()" class="button button-black">Submit</button>
        <span>Already have an account? <router-link v-bind:to="signInPath">Sign in</router-link></span>
      </div>
  </div>
</template>

<script>
  import { mapMutations } from 'vuex';
  import { createAccount } from 'Services/accounts';
  import { INVALID_ENTITY } from 'Services/errorReasons';
  import { SET_CURRENT_USER } from 'Store/mutations';
  import { SIGN_IN } from 'Router/routes';

  export default {
    data() {
      return {
        email: '',
        password: '',
        passwordConfirmation: '',
        emailError: null,
        passwordError: null,
        passwordConfirmationError: null,
        signInPath: SIGN_IN
      }
    },
    methods: {
      ...mapMutations({
        setCurrentUser: SET_CURRENT_USER
      }),

      async submit() {
        this.resetErrors();
        this.$parent.$emit('request:started');
        try {
          const { data: user } = await createAccount(this.email, 
                                                     this.password,
                                                     this.passwordConfirmation);
        this.$parent.$emit('request:successful');          
          this.setCurrentUser({ user });
          this.$alert.success('Account created');
          this.$router.push({ path: SIGN_IN });
        } catch (error) {
        this.$parent.$emit('request:failed');
          this.showErrors(error);
        }
      },

      resetErrors() {
        this.emailError = null;
        this.passwordError = null;
        this.passwordConfirmationError = null;
      },

      showErrors(error) {
        console.log(error);
        if (error.reason === INVALID_ENTITY) {
          Object.keys(error.payload).forEach((attribute) => {
            this[attribute + 'Error'] = error.payload[attribute][0];
          })
        } else {
          console.error('Unknown error', error);
          this.$alert.error('Something unexpected happend');
        }
      }
    }
  }
</script>
