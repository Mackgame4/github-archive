import Vue from 'vue'
import App from './App.vue'

import vuetify from './plugins/vuetify';
import '@babel/polyfill'

import VueClipboard from 'vue-clipboard2'
import velocity from 'velocity-animate';
import Notifications from 'vue-notification';
import numeral from 'numeral';

Vue.filter('uppercase', function (value) {
    return value.toUpperCase()
});

Vue.config.productionTip = false;

Vue.use(Notifications, { velocity });
Vue.use(VueClipboard);

import VueTheMask from 'vue-the-mask';
Vue.use(VueTheMask);

import VueCurrencyInput from 'vue-currency-input'

Vue.use(VueCurrencyInput, {
    globalOptions: { currency: 'USD' }
})

Vue.filter('money', (value) => {
    if (typeof(value) === 'number') {
        //return numeral(value).format('$0,0.00');
        return numeral(value).format('$0,0');
    }
    return '';
});

new Vue({
    vuetify,
    render: h => h(App)
}).$mount('#app')
