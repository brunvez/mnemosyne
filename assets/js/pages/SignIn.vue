<template>
  <div>
    <LoadingContainer>
      <SignInForm />
    </LoadingContainer>
  </div>
</template>

<script>
import SignInForm from 'Components/SignInForm.vue';
import LoadingContainer from 'Components/LoadingContainer.vue'

export default {
  components: {
    SignInForm,
    LoadingContainer
  }
};
</script>
