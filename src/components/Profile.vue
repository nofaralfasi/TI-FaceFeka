<template>
  <div id="app2">
    <router-link to="/">Home</router-link>|
    <router-link to="/profile">Profile</router-link>|
    <router-link v-on:click.native="go_to_game_link_function1" to>Flappybirds 1</router-link>|
    <router-link v-on:click.native="go_to_game_link_function2" to>Flappybirds 2</router-link>|
    <!-- <img src="./assets/logo.png" /> -->
    <!-- <router-view /> -->
    <!-- <router-link to="/">To Avia 2 Click</router-link> -->
    AVIA!!!!
  </div>
</template>

<script>
export default {
  name: "app2"
};
</script>

<style>
#app2 {
  font-family: "Avenir", Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-align: center;
  color: #e21a5d;
  margin-top: 60px;
}
</style>