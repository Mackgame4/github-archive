import Vue from "vue";
import { ref, firebaseAuth } from '../config/firebaseConfig';

export const updateCart = ({commit}, {item, quantity, isAdd}) => {
	commit('UPDATE_CART', {item, quantity, isAdd});
	if (isAdd) {
		Vue.$toast.success(`Added ${item.title} to cart.`);
	}
}

export const removeItemInCart = ({commit}, {item}) => {
	commit('REMOVE_CART_ITEM', {item});
}

export const registerByEmail = async (_, {email, password, displayName}) => {
	const result = await firebaseAuth().createUserWithEmailAndPassword(email, password);
	return await result.user.updateProfile({
		displayName: displayName
	});
}

export const logout = ({commit}) => {
	commit('SET_CART', []);
	return firebaseAuth().signOut();
}

export function loginWithEmail (_, {email, password}) {
	return firebaseAuth().signInWithEmailAndPassword(email, password);
}

export function recoverPassword (_, {email}) {
	return firebaseAuth().sendPasswordResetEmail(email);
}

export function updatePassword (_, {newPassword}) {
	const user = firebaseAuth().currentUser;
	return user.updatePassword(newPassword).then(() => {
		console.log('Password updated');
	}).catch((error) => {
		console.log(error);
	});
}

export function listenToProductList({commit}) {
	return ref.child("products").on('value', (products) => {
		commit('UPDATE_PRODUCT_LIST', products.val());
	});
}

export function updateUserData(_, {uid, data}) {
	return ref.child("userData/" + uid).set(data);
}

export function updateAppData(_, {name, data}) {
	if (name) {
		return ref.child("appData/" + name).set(data);
	} else {
		return ref.child("appData").set(data);
	}
}

export async function getUserData({commit}) {
	var uid = firebaseAuth().currentUser.uid;
	if (uid) {
		const res = await ref.child("userData/" + uid).once('value');
		//console.log("data", res.val());
		commit('SET_USERDATA', res.val());
	} else {
		//console.log("User has not logged in");
		return null;
	}
}

export async function getAppData({commit}) {
	const res = await ref.child("appData").once('value');
	//console.log("data", res.val());
	commit('SET_APPDATA', res.val());
}

export async function getShoppingCart({commit}, {uid, currentCart}) {
	if (uid) {
		return ref.child("cart/" + uid).once('value').then((cart) => {
			if (cart.val() && (!currentCart || currentCart.length == 0)) {
				commit('SET_CART', cart.val());
			}
		});
	} else {
		//console.log("User has not logged in");
		return null;
	}
}

export function updateFilteredProductList({commit}, filteredProductList) {
	if (filteredProductList) {
		commit('UPDATE_FILTERED_PRODUCT_LIST', filteredProductList);
	} else {
		return null;
	}
}

export function saveShoppingCart(_, {uid, cartItemList}) {
	return ref.child("cart/" + uid).set(cartItemList);
}

export function saveToTransaction(_, {uid, session, cartItemList}) {
	let newTransactionKey = ref.child("transactions").push().key;
	var newTransaction = {}
	newTransaction['/transactions/' + uid + '/' + newTransactionKey] = { status: "pending", session: session, cartItemList: cartItemList };
	return ref.update(newTransaction);
}

export async function getDBData(_, {collection}) {
	const res = await ref.child(collection).once('value');
	return res.val();
}

export function saveDBData(_, {collection, data}) {
	return ref.child(collection).set(data);
}