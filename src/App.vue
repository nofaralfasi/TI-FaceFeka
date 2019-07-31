<template>
  <!-- this is displayed at the top of all screens -->
  <div id="app" style="color: white;">
    <router-link to="/">Home </router-link> |
    <router-link v-on:click.native="go_to_game_link_function1" to>Flappybirds 1 </router-link> |
    <router-link v-on:click.native="go_to_game_link_function2" to>Flappybirds 2 </router-link> |
    <a class="button is-primary" @click="isZero=true">Reset</a>
    <a class="button is-primary" @click="currNum+=2">addTwo</a>
    <router-view></router-view>
  </div>
</template>

<script>
export default {
  name: "app",
  methods: {
    go_to_game_link_function1: function(event) {
      console.log("inside event of go_to_game_link_function click");
      window.open('http://localhost:2000', '_blank');
    },
    go_to_game_link_function2: function(event) {
      console.log("inside event of go_to_game_link_function click");
      window.open('http://localhost:4242/flappybirds', '_blank');
    }
  }
};
</script>

<style>
/* this changes nothing!! */
#app {
  color:darkmagenta; /*New Post text color*/
  font: bold 110% Arial;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-align: center;
  margin-top: 60px;
}
</style>
