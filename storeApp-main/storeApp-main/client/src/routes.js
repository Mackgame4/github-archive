import Home from './components/Home.vue';
import Store from './components/Store.vue';
import Pages from './components/Pages.vue';
import CheckoutSuccess from './components/checkout/CheckoutSuccess.vue';
import CheckoutError from './components/checkout/CheckoutError.vue';
import ProductDetails from './components/ProductDetails.vue';
import Account from './components/auth/Account.vue';
import AccountRecovery from './components/auth/AccountRecovery.vue';
import AdminPanel from './components/AdminPanel.vue';
import PageNotFound from './components/PageNotFound.vue';

export const routes = [
	{path: '/', component: Home, name: 'mainpage'},
	{path: '/store', component: Store, name: 'store'},
	{path: '/checkout/success', component: CheckoutSuccess, name: 'checkoutsuccess'},
	{path: '/checkout/error', component: CheckoutError, name: 'checkouterror'},
	{path: '/product/:id', component: ProductDetails, name: 'product'},
	{path: '/pages-*', component: Pages, name: 'pages'},
	{path: '/account', component: Account, name: 'account', onlyGuest: true },
	{path: '/recovery', component: AccountRecovery, name: 'accountrecovery' },
	{path: '/admin', component: AdminPanel, name: 'adminpanel', onlyAdmin: true },
	{path: '*', component: PageNotFound }
];