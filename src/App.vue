<template>
  <div id="app">
    <router-view></router-view>
     <router-link to="/">Home</router-link> |
      <router-link to="/Login">Login</router-link> |
      <router-link v-on:click.native="go_to_game_link_function" to="">Game</router-link> |
  </div>
</template>

<script>
export default {
  name: 'app',
  methods: {
    go_to_game_link_function: function (event){
      console.log("inside event of go_to_game_link_function click");
      window.location.href = "http://localhost:2000";
    }

  }
}
</script>

<style>
#app {
  font-family: 'Avenir', Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-align: center;
  color: #e45513; /*New Post text color*/
  border: #f31a2d;
  margin-top: 60px;
  background-color: aqua;
  background-image: url('https://images4.alphacoders.com/689/689597.jpg');
}

</style>
