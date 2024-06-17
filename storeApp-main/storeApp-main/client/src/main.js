import Vue from 'vue';
import VueRouter from 'vue-router';

import { routes } from './routes';
import store from './stores/store';
import { firebaseListener } from './config/firebaseConfig';

import App from './App.vue';

/* Plugins */
import "@storefront-ui/vue/styles.scss";
import vuescroll from 'vuescroll/dist/vuescroll-native';
import "vuescroll/dist/vuescroll.css";

import Toast from "vue-toastification";
import './assets/styles/app.scss';

Vue.use(Toast, {
	timeout: 3500,
	closeOnClick: true,
	showCloseButtonOnHover: true,
	hideProgressBar: true,
	pauseOnFocusLoss: false,
	pauseOnHover: false,
	transition: "Vue-Toastification__fade",
	maxToasts: 4,
	newestOnTop: true
});

Vue.use(vuescroll);

Vue.use(VueRouter);

firebaseListener(authStatusChange);

const router = new VueRouter({
	mode: 'history',
	routes
});

/*router.beforeEach((to, from, next) => {
    if (to.onlyGuest && store.getters.isLoggedIn) {
        next('/');
    } else {
        next();
    }
});*/

new Vue({
	el: '#app',
	router,
	store,
	render: h => h(App)
})

function authStatusChange(loggedIn, user) {
	if (store) {
		store.commit('AUTH_STATUS_CHANGE');
		if (user) {
			store.dispatch('getShoppingCart', {uid: user.uid, currentCart: store.getters.cartItemList});
			store.dispatch('getUserData');
		}
	}
	//if (process.env.NODE_ENV === 'development') { console.log('authStatusChange', loggedIn, user); }
}