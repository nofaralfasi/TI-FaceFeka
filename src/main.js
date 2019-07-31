// The Vue build version to load with the `import` command
// (runtime-only or standalone) has been set in webpack.base.conf with an alias.
import Vue from 'vue'
import App from './App'
import router from './router'
import Buefy from 'buefy'
import axios from 'axios'
import VueAxios from 'vue-axios'
import 'buefy/lib/buefy.css'
import './assets/main.css'
import VueParticles from 'vue-particles'
import $ from "jquery"
import {
  store
} from './store'
import FullCalendar from 'vue-full-calendar'
Vue.use(FullCalendar);
import Icon from 'vue-awesome/icons'

// import Icon from 'vue-awesome/components/Icon'
// Vue.use(require('vue-moment'));
// globally (in your main .js file)
Vue.component('icon', Icon);
Vue.use(VueParticles);
Vue.use(Buefy);
Vue.use(VueAxios, axios);
Vue.config.productionTip = false;
window.jQuery = window.$ = require('jquery');
/* eslint-disable no-new */
new Vue({
  // this is the whole window screen content!!
  el: '#app',
  router,
  store,
  template: '<App/>',
  components: {
    App
  },
  data: {
    htmlcontent: "<div><h1>Vue Js Template</h1></div>"
  }
});
