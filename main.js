// The Vue build version to load with the `import` command
// (runtime-only or standalone) has been set in webpack.base.conf with an alias.
import Vue from 'vue'
import Buefy from 'buefy'
import App from './App'
import router from './router'
import { Vue2Dragula } from 'vue2-dragula'
import VueFire from 'vuefire'
import store from './store'
import Effect from './components/transitions/Effect'
import { connect } from 'net';

Vue.config.productionTip = false;
Vue.use(Buefy);
Vue.component('effect', Effect);
Vue.use(VueFire);
Vue.use(Vue2Dragula, {
  // mirrorContainer: document.querySelector('#app'),
  logging: {
    service: true
  }
});
/* eslint-disable no-new */
new Vue({
  el: '#app',
  router,
  store,
  template: '<App/>',
  components: { App },
  created () {
    Vue.$dragula.options.mirrorContainer = document.querySelector('#app')
  }
});

/*
in event of refresh (not existing), but we can handle event of page upload
get items from localstorage and request post of connect
*/

$(window).on("load", function(){
  this.console.log("When refersh!");
  // Handler when all assets (including images) are loaded
  var userID = localStorage.getItem("currentUserID");
  var userPassword = localStorage.getItem("currentPassword");
  var username = localStorage.getItem("currentUsername");

this.console.log("currentUserID:" +userID);
  var xhttp = new XMLHttpRequest();
  xhttp.onreadystatechange = function() {
    if (this.readyState == 4 && this.status == 200) {
      if(response[0]!="000")
      {
        console.log("connect() login file");
        this.wrongeLogin();
      }
      else{
        this.$store.state.userLogged=response[2];
        console.log(this.$store.state.userLogged.userID);
        this.$router.replace('/posts');
      }
    }
  };
  xhttp.open("GET", "ajax_info.txt", true);
  xhttp.send();



});
