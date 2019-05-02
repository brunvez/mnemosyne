<template>
<div v-bind:class="{ loading }">
  <div class="spinner-wrapper">
    <span class="spinner" />
  </div>
  <div>
    <slot />
  </div>
</div>
</template>

<script>
export default {
  data() {
    return {
      loading: false
    };
  },

  mounted() {
    this.$on('request:started', function() {
      this.$data.loading = true;
    });

    this.$on('request:successful', function() {
      this.$data.loading = false;
    });

    this.$on('request:failed', function() {
      this.$data.loading = false;
    });
  }
}
</script>


<style scoped>
.loading {
  -webkit-animation: fadein 2s;
     -moz-animation: fadein 2s;
       -o-animation: fadein 2s;
          animation: fadein 2s;
}

@-moz-keyframes fadein {
  from { opacity: 0 }
  to { opacity: 1 }
}
@-webkit-keyframes fadein {
  from { opacity: 0 }
  to { opacity: 1 }
}
@-o-keyframes fadein {
  from { opacity: 0 }
  to { opacity: 1 }
}
@keyframes fadein {
  from { opacity: 0 }
  to { opacity: 1 }
}

.loading .spinner-wrapper {
  min-width: 100%;
  min-height: 100%;
  height: 100%;
  top: 0;
  left: 0;
  background: rgba(255, 255, 255, 0.7);
  position: absolute;
  z-index: 300;
}

.loading .spinner {
  margin: 0;
  display: block;
  position: absolute;
  left: 40%;
  top: 35%;
  border: 25px solid rgba(100, 100, 100, 0.7);
  width: 1px;
  height: 1px;
  border-left-color: transparent;
  border-right-color: transparent;
  -webkit-border-radius: 50px;
     -moz-border-radius: 50px;
          border-radius: 50px;
  -webkit-animation: spin 1.5s infinite;
     -moz-animation: spin 1.5s infinite;
          animation: spin 1.5s infinite;
}

@-webkit-keyframes spin {
  0%,100% { -webkit-transform: rotate(0deg) scale(1) }
  50%     { -webkit-transform: rotate(720deg) scale(0.6) }
}

@-moz-keyframes spin {
  0%,100% { -moz-transform: rotate(0deg) scale(1) }
  50%     { -moz-transform: rotate(720deg) scale(0.6) }
}

@-o-keyframes spin {
  0%,100% { -o-transform: rotate(0deg) scale(1) }
  50%     { -o-transform: rotate(720deg) scale(0.6) }
}

@keyframes spin {
  0%,100% { transform: rotate(0deg) scale(1) }
  50%     { transform: rotate(720deg) scale(0.6) }
}
</style>
