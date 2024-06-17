import { firebaseAuth } from '../../config/firebaseConfig';

const state = {
	isLoggedIn: firebaseAuth().currentUser != null,
	user: firebaseAuth().currentUser,
	userData: {},
	appData: {}
}

const mutations = {
	'AUTH_STATUS_CHANGE' (state) {
		state.isLoggedIn = firebaseAuth().currentUser != null;
		state.user = firebaseAuth().currentUser;
	},
	'SET_USERDATA' (state, data) {
		state.userData = data;
	},
	'SET_APPDATA' (state, data) {
		state.appData = data;
	}
}

const actions = {
	// Check actions.js
}

const getters = {
	isLoggedIn: (state) => {
		return state.isLoggedIn;
	},
	currentUser: (state) => {
		if (state && state.user) {
			return {
				displayName: state.user.displayName,
				email: state.user.email,
				emailVerified: state.user.emailVerified,
				uid: state.user.uid
			}
		} else {
			return {};
		}
	},
	userData: (state) => {
		return state.userData;
	},
	appData: (state) => {
		return state.appData;
	}
}

export default {
	state,
	mutations,
	actions,
	getters
}
