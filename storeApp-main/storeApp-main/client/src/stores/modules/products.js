const state = {
	isLoading: true,
	productList: [],
	filteredProductList: []
}

const mutations = {
	'UPDATE_PRODUCT_LIST' (state, productList) {
		state.productList = productList;
		state.isLoading = false;
	},
	'UPDATE_FILTERED_PRODUCT_LIST' (state, filteredProductList) {
		state.filteredProductList = filteredProductList;
	}
}

const actions = {
	// Check actions.js
}

const getters = {
	products: (state) => {
		return state.productList;
	},
	isProductLoading: (state) => {
		return state.isLoading;
	},
	filteredProducts: (state) => {
		if (state.filteredProductList.length > 0) {
			return state.filteredProductList;
		} else {
			return state.productList;
		}
	}
}

export default {
	state,
	mutations,
	actions,
	getters
}