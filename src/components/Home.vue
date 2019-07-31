<template lang="pug">
  .navbar()
    i(class="fa fa-user-o" aria-hidden="true")

</template>

<script>
export default {
  name: "Login",
  data() {
    return {
      user: "",
      password: ""
    };
  }
};
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped>
.nav {
  position: absolute;
  width: 100%;
  top: 0px;
  background-color: mistyrose;
}
</style>
 