import Vue from 'vue';
import Vuex from 'vuex';

// Store Modules
import cart from './modules/cart';
import products from './modules/products';
import auth from './modules/auth';

// Store Actions
import * as actions from './actions';

Vue.use(Vuex);

export default new Vuex.Store({
	actions,
	modules: {
		auth,
		cart,
		products
	}
});