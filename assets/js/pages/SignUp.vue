<template>
  <div>
    <LoadingContainer>
      <SignUpForm />
    </LoadingContainer>
  </div>
</template>

<script>
import SignUpForm from 'Components/SignUpForm.vue';
import LoadingContainer from 'Components/LoadingContainer.vue'

export default {
  components: {
    SignUpForm,
    LoadingContainer
  }
};
</script>
