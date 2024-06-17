import Vue from 'vue'
import Phone from './Phone.vue'

import vuetify from './plugins/vuetify';
import '@babel/polyfill'

import store from './store';

import VueTheMask from 'vue-the-mask';
Vue.use(VueTheMask);

Vue.config.productionTip = false;

import Clipboard from 'v-clipboard';
Vue.use(Clipboard)

import VueCustomTooltip from '@adamdehaven/vue-custom-tooltip'
Vue.use(VueCustomTooltip)
Vue.use(VueCustomTooltip, {
    name: 'VueCustomTooltip',
    color: '#fff',
    background: '#000',
    borderRadius: 12,
    fontWeight: 400,
})


new Vue({
    vuetify,
    store,
    render: h => h(Phone)
}).$mount('#app')

