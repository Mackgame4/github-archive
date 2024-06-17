import Vue from 'vue'
import App from './App.vue'

import vuetify from './plugins/vuetify';
import '@babel/polyfill'

Vue.config.productionTip = false;

import VueEllipseProgress from 'vue-ellipse-progress';
Vue.use(VueEllipseProgress);

import store from './store';

new Vue({
    vuetify,
    store,
    render: h => h(App)
}).$mount('#app')

