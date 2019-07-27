<template>
<!-- this is displayed at the top of all screens -->
  <div id="app">
     <router-link to="/">Home</router-link> |
      <router-link to="/profile">Profile</router-link> |
      <router-link v-on:click.native="go_to_game_link_function1" to="">Flappybirds 1</router-link> |
      <router-link v-on:click.native="go_to_game_link_function2" to="">Flappybirds 2</router-link> |
      <router-view></router-view>
  </div>
</template>

<script>
export default {
  name: 'app',
  methods: {
    go_to_game_link_function1: function (event){
      console.log("inside event of go_to_game_link_function click");
      window.location.href = "http://localhost:2000";
    },
      go_to_game_link_function2: function (event){
      console.log("inside event of go_to_game_link_function click");
      window.location.href = "http://localhost:4242/flappybirds";
    }
  }
}
</script>

<style>
/* this changes nothing!! */
#app {
  font-family: 'Avenir', Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-align: center;
  color: #ce1c48; /*New Post text color*/
  border: #f31a2d;
  margin-top: 60px;
  background-color: rgb(32, 65, 175);
  /* background-image: url('https://images4.alphacoders.com/689/689597.jpg'); */
}
</style>
