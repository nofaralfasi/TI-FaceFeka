import Vue from 'vue'
import Router from 'vue-router'
import Login from '@/components/Login'
import posts from '@/components/posts'
import Home from '@/components/Home'
import moment from "moment";
import VueMomentJS from "vue-momentjs";

Vue.use(VueMomentJS, moment);
Vue.use(Router);

export default new Router({
    routes: [{
            path: '/login',
            name: 'Login',
            component: Login
        },
        {
            path: '/posts',
            name: 'posts',
            component: posts
        },
        {
            path: '/',
            name: 'Login',
            component: Login
        }
    ]
}) 
