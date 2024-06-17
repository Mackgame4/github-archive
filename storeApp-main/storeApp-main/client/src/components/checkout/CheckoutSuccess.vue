<template>
  <div class="container">
    <SfCircleIcon icon="check"  iconSize="xxl" /><br>
    <h1 class="sf-heading__title h1">Encomenda realizada com sucesso!</h1><br>
    <SfButton class="sf-button--underlined sf-button" @click="$router.push('/account').catch(()=>{})">Verifique aqui o status da sua encomenda.</SfButton>
    <p>ou</p>
    <SfButton @click="$router.push('/store').catch(()=>{})">Voltar às compras</SfButton>
  </div>
</template>
<script>
import { mapActions, mapGetters } from 'vuex'
import {
  SfButton, SfCircleIcon
} from "@storefront-ui/vue";
export default {
  name: "CheckoutSuccess",
  components: {
    SfButton,
    SfCircleIcon
  },
  data() {
    return {
    };
  },
  computed: {
    ...mapGetters([
      'cartItemList',
      'isLoggedIn',
      'products',
      'currentUser',
      'cartValue',
    ]),
  },
  mounted() {
    console.log('CheckoutSuccess mounted');
    fetch("http://localhost:3000/fetchSessionID", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify(
        {
          session_id: this.$route.query.session_id,
        }
      ),
    })
    .then(res => {
      if (res.ok) return res.json()
      return res.json().then(json => Promise.reject(json))
    })
    .then(({ session, successfulCheckout, cartItemList, uid }) => {
      console.log('CheckoutSuccess session', session, session.status, successfulCheckout, cartItemList);
      if (successfulCheckout && session.status === 'complete' || successfulCheckout && session.status === 'paid') {
        console.log('CheckoutSuccess successfulCheckout', successfulCheckout, cartItemList, uid, this.currentUser.uid);
        this.saveToTransaction({
          session: session,
          cartItemList: cartItemList,
          uid: uid,
        }).then(() => {
          this.$toast.success('Your order has been successfully processed!');
          this.updateAppData({
            name: "newShippings",
            data: true
          });
          /*this.saveShoppingCart({
            cartItemList: [],
            uid: this.currentUser.uid,
          })*/
          //this.clearCart()
        })
      } else {
        this.$toast.error('Ocorreu um erro ao processar a sua encomenda.');
        this.$router.push('/checkout/error').catch(()=>{})
      }
    })
    .catch(e => {
      console.error(e.error)
    })
  },
  methods: {
    ...mapActions([
      'saveShoppingCart',
      'saveToTransaction',
      'clearCart',
      'updateCart', 
      'removeItemInCart',
      'updateAppData'
    ]),
  }
};
</script>
<style lang="scss" scoped>
.container {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  height: 100%;
  margin-top: 30px;
  margin-bottom: 30px;
}
</style>