<template>
  <div id="cart">
    <SfSidebar :visible="isCartSidebarOpen" title="Carrinho" class="sf-sidebar--right sf-sidebar--icon" @close="() => { $emit('closeCart') }">
      <template #content-top>
        <SfProperty class="sf-property--large cart-summary desktop-only" name="Produtos" :value="$store.getters.cartItemList.length" />
      </template>
      <transition name="sf-fade" mode="out-in">
        <div v-if="cartItemList.length > 0" key="my-cart" class="my-cart">
          <div class="collected-product-list">
            <transition-group name="sf-fade" tag="div">
              <SfCollectedProduct
                v-for="cartItem in cartItemList"
                :key="cartItem.id"
                v-model="cartItem.quantity"
                :image="cartItem.thumbnail_url"
                :title="cartItem.title+' - '+cartItem.description"
                :link="'/product/' + cartItem.id"
                :regular-price="storeConfig.currency+cartItem.price.regular"
                :special-price="cartItem.price.sale != 0 ? storeConfig.currency+cartItem.price.sale : ''"
                class="collected-product"
                @click:remove="removeItem(cartItem)"
              >
              <template #configuration>
                  <div v-if="cartItem.configuration" class="collected-product__properties">
                    <SfProperty v-for="(property, i) in cartItem.configuration" :key="i" :name="property.name" :value="property.value" />
                  </div>
                  <div v-else></div>
                </template>
                <template #actions>
                  <div></div>
                </template>
              </SfCollectedProduct>
            </transition-group>
          </div>
        </div>
        <div v-else key="empty-cart" class="empty-cart">
          <div class="empty-cart__banner">
            <SfImage alt="Empty bag" class="empty-cart__image" :width="140" :height="200" src="https://i.imgur.com/hq7pVWT.png" />
            <SfHeading title="O carrinho está vazio" :level="2" class="empty-cart__heading" description="Parece que você ainda não adicionou nenhum item à sacola. Comece a comprar para preenchê-lo." />
          </div>
        </div>
      </transition>
      <template #content-bottom>
        <transition name="sf-fade">
          <div v-if="cartValue > 0">
            <SfProperty name="Total" class="sf-property--full-width sf-property--large my-cart__total-price" :value="storeConfig.currency+cartValue" />
            <SfButton class="sf-button--full-width color-secondary" @click="checkout">Checkout</SfButton>
          </div>
          <div v-else>
            <SfButton class="sf-button--full-width color-primary" @click="$emit('closeCart')">Continuar a comprar</SfButton>
          </div>
        </transition>
      </template>
    </SfSidebar>
  </div>
</template>
<script>
import { storeConfig } from '../config/storeConfig';
import { mapActions, mapGetters } from 'vuex'
import {
  SfSidebar,
  SfButton,
  SfHeading,
  SfProperty,
  SfImage,
  SfCollectedProduct,
} from "@storefront-ui/vue";
export default {
  name: "Cart",
  props: {
    isCartSidebarOpen: {
      type: Boolean,
      default: false,
    },
  },
  components: {
    SfSidebar,
    SfButton,
    SfHeading,
    SfImage,
    SfProperty,
    SfCollectedProduct,
  },
  data() {
    return {
      storeConfig,
      cartItems: []
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
  methods: {
    ...mapActions([
      'saveShoppingCart',
      'saveToTransaction',
      'clearCart',
      'updateCart', 
      'removeItemInCart'
    ]),
    removeItem(cartItem) {
			this.removeItemInCart({
				item: cartItem
			});
		},
    checkValidCart(itemList, prodList) {
      let isValid = true
      let message = ''

      itemList.map((item) => {
        for (let prodIdx = 0; prodIdx < prodList.length; prodIdx++) {
          if (prodList[prodIdx].id == item.id) {
            if (prodList[prodIdx].quantity < item.quantity) {
              message = `Only ${prodList[prodIdx].quantity} ${item.title} available in stock`
              isValid = false
              return
            }
            break
          }
        }
      })
      return {
        isValid,
        message,
      }
    },
    checkout() {
      if (this.isLoggedIn) {
        if (!this.cartItemList || this.cartItemList.length == 0) {
          this.$toast.error('Your cart is empty!');
          return
        }
        let { isValid, message } = this.checkValidCart(
          this.cartItemList,
          this.products
        )
        if (isValid) {
          this.$toast.info('Redirecionando para a página de pagamento...');
            fetch("http://localhost:3000/sendCurrentProducts", {
              method: "POST",
              headers: {
                "Content-Type": "application/json",
              },
              body: JSON.stringify({
                products: this.products,
              }),
            })
            .then(res => {
              if (res.ok && res.status == 200) {
                this.cartItemList.map((item) => {
                  this.cartItems.push({
                    id: item.id,
                    quantity: item.quantity,
                  });
                });
                fetch("http://localhost:3000/create-checkout-session", {
                  method: "POST",
                  headers: {
                    "Content-Type": "application/json",
                  },
                  body: JSON.stringify({
                    items: this.cartItems,
                    cartItemList: this.cartItemList,
                    uid: this.currentUser.uid,
                    /*items: [
                      { id: 1, quantity: 3 },
                      { id: 2, quantity: 1 },
                    ],*/
                  }),
                })
                .then(res => {
                  if (res.ok) return res.json()
                  return res.json().then(json => Promise.reject(json))
                })
                .then(({ url }) => {
                  window.location = url
                  this.cartItems = [];
                  /*this.saveToTransaction({
                    cartItemList: this.cartItemList,
                    uid: this.currentUser.uid,
                  }).then(() => {
                    this.$toast.success('Your order has been successfully processed!');
                    this.saveShoppingCart({
                      cartItemList: [],
                      uid: this.currentUser.uid,
                    })
                    this.clearCart()
                    //this.$router.push('/').catch(()=>{})
                  })*/
                })
                .catch(e => {
                  console.error(e.error)
                })
              }
            })
            .catch(e => {
              console.error(e.error)
            })
        } else {
          this.$toast.error(message);
        }
      } else {
        this.$toast.warning('Please login to checkout.');
      }
    },
  },
};
</script>
<style lang="scss">
@import "~@storefront-ui/vue/styles";
.sf-sidebar__aside {
  z-index: 9999 !important;
}
.sf-collected-product__more-actions {
  display: none !important;
}
#cart {
  @include for-desktop {
    & > * {
      --sidebar-bottom-padding: var(--spacer-base);
      --sidebar-content-padding: var(--spacer-base);
    }
  }
}
.cart-summary {
  margin-top: var(--spacer-xl);
}

.my-cart {
  flex: 1;
  display: flex;
  flex-direction: column;
  &__total-items {
    margin: 0;
  }
  &__total-price {
    --price-font-size: var(--font-size--xl);
    --price-font-weight: var(--font-weight--medium);
    margin: 0 0 var(--spacer-base) 0;
  }
}
.empty-cart {
  --heading-description-margin: 0 0 var(--spacer-xl) 0;
  --heading-title-margin: 0 0 var(--spacer-xl) 0;
  --heading-title-color: var(--c-primary);
  --heading-title-font-weight: var(--font-weight--semibold);
  display: flex;
  flex: 1;
  align-items: center;
  flex-direction: column;
  &__banner {
    display: flex;
    justify-content: center;
    flex-direction: column;
    align-items: center;
    flex: 1;
  }
  &__heading {
    padding: 0 var(--spacer-base);
  }
  &__image {
    --image-width: 13.1875rem;
    margin: 0 0 var(--spacer-xl) 0;
    @include for-desktop {
      --image-width: 23.3125rem;
      margin: 0 0 var(--spacer-2xl) 0;
    }
  }
  @include for-desktop {
    --heading-title-font-size: var(--font-size--xl);
    --heading-title-margin: 0 0 var(--spacer-sm) 0;
  }
}
.collected-product-list {
  flex: 1;
}
.collected-product {
  margin: 0 0 var(--spacer-sm) 0;
  &__properties {
    margin: var(--spacer-xs) 0 0 0;
    display: flex;
    flex-direction: column;
    justify-content: flex-end;
    align-items: flex-start;
    flex: 2;
    &:first-child {
      margin-bottom: 8px;
    }
  }
  &__actions {
    transition: opacity 150ms ease-in-out;
  }
  &__save,
  &__compare {
    --button-padding: 0;
    &:focus {
      --cp-save-opacity: 1;
      --cp-compare-opacity: 1;
    }
  }
  &__save {
    opacity: var(--cp-save-opacity, 0);
  }
  &__compare {
    opacity: var(--cp-compare-opacity, 0);
  }
  &:hover {
    --cp-save-opacity: 1;
    --cp-compare-opacity: 1;
    @include for-desktop {
      .collected-product__properties {
        display: none;
      }
    }
  }
}
</style>