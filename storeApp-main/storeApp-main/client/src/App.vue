<template>
<vue-scroll :ops="storeConfig.vuescrollOptions">
      <div class="nav">
        <div class="desktop-only">
          <SfImage style="position: absolute; top: 4px; left: 3px;" :src="storeConfig.logoLight" alt="logo" :height="55" @click="searching = false, $router.push('/').catch(()=>{})" />
          <h1 class="text-appprimary" style="position: absolute; top: -27px; left: 113px; font-size: 45px; font-family: 'Waterfall', cursive;" @click="searching = false, $router.push('/').catch(()=>{})">Alma Store</h1>
        </div>
        <div class="smartphone-only">
          <h1 class="text-appprimary" style="position: absolute; top: -27px; left: 8px; font-size: 45px; font-family: 'Waterfall', cursive;" @click="searching = false, $router.push('/').catch(()=>{})">Alma Store</h1>
        </div>
        <transition name="sf-slide-right">
          <SfSearchBar style="position: fixed; right: 12px; max-width: 180px;" v-if="searching" placeholder="Procurar" v-model="search" :icon='{"size":"1.25rem","color":"green-primary"}' aria-label="Search" />
          <SfIcon v-if="!searching" icon="search" size="md" color="green-primary" @click="searching = true, $router.push('/store').catch(()=>{})" />
        </transition>
      </div>
<main @click="[searching ? searching = false : searching = false ]">
<ShoppingCart :isCartSidebarOpen="isCartSidebarOpen" v-on:closeCart="isCartSidebarOpen = false"></ShoppingCart>
<router-view></router-view>
<SfFooter :column="4" multiple :open='["Páginas","Pagamento e entrega","Social"]' :logo="storeConfig.logo" title="Alma Store">
    <SfFooterColumn title="Páginas">
      <SfList>
        <SfListItem><SfMenuItem label="‣ Sobre Nós" @click="$router.push('/pages-1').catch(()=>{})" /></SfListItem>
        <SfListItem><SfMenuItem label="‣ Contacto" @click="$router.push('/pages-1').catch(()=>{})" /></SfListItem>
        <SfListItem><SfMenuItem label="‣ Guia de Tamanhos" @click="$router.push('/pages-4').catch(()=>{})" /></SfListItem>
      </SfList>
    </SfFooterColumn>
    <SfFooterColumn title="Pagamento e entrega">
      <SfList>
        <SfListItem><SfMenuItem label="‣ Termos de compra" @click="$router.push('/pages-3').catch(()=>{})" /></SfListItem>
        <SfListItem><SfMenuItem label="‣ Garantia e entrega" @click="$router.push('/pages-3').catch(()=>{})" /></SfListItem>
        <div style="margin-left: 17px;">
          <img src="https://img.icons8.com/fluency/48/000000/visa.png"/>
          <img src="https://img.icons8.com/fluency/48/000000/mastercard.png"/>
          <img src="https://img.icons8.com/fluency/48/000000/stripe.png"/>
        </div>
      </SfList>
    </SfFooterColumn>
    <SfFooterColumn title="Social" class="desktop-only">
      <div style="display: flex;">
        <button class="sf-circle-icon sf-button" @click="openInNewTab(storeConfig.socialMedia.facebook, true)">
          <SfImage src="https://img.icons8.com/fluency/96/000000/facebook-new.png" alt="facebook" :width="32" :height="32" />
        </button>
        <button style="margin-left: 7px;" class="sf-circle-icon sf-button" @click="openInNewTab(storeConfig.socialMedia.twitter, true)">
          <SfImage src="https://img.icons8.com/color/96/000000/twitter.png" alt="twitter" :width="32" :height="32" />
        </button>
        <button style="margin-left: 7px;" class="sf-circle-icon sf-button" @click="openInNewTab(storeConfig.socialMedia.instagram, true)">
          <SfImage src="https://img.icons8.com/color/96/000000/instagram-new--v1.png" alt="instagram" :width="32" :height="32" />
        </button>
      </div>
    </SfFooterColumn>
    <SfFooterColumn title="Social" class="smartphone-only">
      <div style="margin-left: 17px; display: flex;">
        <button class="sf-circle-icon">
          <SfImage src="https://img.icons8.com/fluency/96/000000/facebook-new.png" alt="facebook" :width="32" :height="32" />
        </button>
        <button style="margin-left: 7px;" class="sf-circle-icon">
          <SfImage src="https://img.icons8.com/color/96/000000/twitter.png" alt="twitter" :width="32" :height="32" />
        </button>
        <button style="margin-left: 7px;" class="sf-circle-icon">
          <SfImage src="https://img.icons8.com/color/96/000000/instagram-new--v1.png" alt="instagram" :width="32" :height="32" />
        </button>
      </div>
    </SfFooterColumn>
    <!--SfFooterColumn title="Linguaguem" class="desktop-only">
      <span class="color-light sf-button">
        <SfImage src="https://img.icons8.com/color/96/000000/portugal-circular.png" alt="flag of the USA" :width="30" :height="30" />
        ‏‏‎‎Português
      </span>
    </SfFooterColumn-->
    <SfFooterColumn title="Newsletter">
      <div id="newsletter" style="display: flex;">
        <SfInput style="display: inline; width: 300px; height: 55px;" class="sf-input--outline" type="text" placeholder="Email" />
        <span class="sf-button" @click="$router.push('/pages-2').catch(()=>{})">Subscrever</span>
      </div>
    </SfFooterColumn>
  </SfFooter>
  <SfBottomNavigation>
    <SfBottomNavigationItem v-for="(navItem, i) in navItems" :key="i" :icon="navItem.icon" :isActive="navItem.isActive" :iconActive="navItem.icon" :label="navItem.label" @click="$router.push(navItem.route).catch(()=>{}), handleMenuClick(i)" />
    <SfBottomNavigationItem icon="empty_cart" label="Carrinho" isFloating @click="isCartSidebarOpen = !isCartSidebarOpen, handleMenuClick(-1)" />
    <span v-if="this.$store.getters.cartItemList.length > 0" class="sf-badge--number sf-badge desktop-only" style="position: fixed; bottom: 3%; right: 8%; font-family: 'Roboto', sans-serif;">{{ this.$store.getters.cartItemList.length }}</span>
    <span v-if="this.$store.getters.cartItemList.length > 0" class="sf-badge--number sf-badge smartphone-only" style="position: fixed; bottom: 3%; right: 3%; font-family: 'Roboto', sans-serif;">{{ this.$store.getters.cartItemList.length }}</span>
  </SfBottomNavigation>
  </main>
</vue-scroll>
</template>

<script>
import { storeConfig } from './config/storeConfig';
import { SfBottomNavigation, SfFooter, SfList, SfImage, SfMenuItem, SfInput, SfSearchBar, SfIcon } from '@storefront-ui/vue';
import { mapActions, mapGetters } from 'vuex';
import ShoppingCart from './components/ShoppingCart';
  export default {
    components: {
      SfBottomNavigation,
      SfFooter,
      SfList,
      SfImage,
      SfMenuItem,
      SfInput,
      SfSearchBar,
      SfIcon,
      ShoppingCart
    },
    data() {
      return {
        searching: false,
        search: '',
        searchQuery: '',
        isCartSidebarOpen: false,
        // Static data
        storeConfig,
        navItems: [
          {
            icon: 'home',
            label: 'Inicio',
            isActive: true,
            route: '/'
          },
          {
            icon: 'menu',
            label: 'Páginas',
            isActive: false,
            route: '/pages-1'
          },
          {
            icon: 'store',
            label: 'Loja',
            isActive: false,
            route: '/store'
          },
          {
            icon: 'profile',
            label: 'Conta',
            isActive: false,
            route: '/account'
          }
        ],
      }
    },
    watch: {
      search: function(val) {
        this.searchQuery = val;
        this.updateFilteredProductList(this.filteredList);
        //console.log(this.filteredList, this.filteredProducts);
      }
    },
    computed: {
      ...mapGetters(['products', 'isProductLoading', 'filteredProducts']),
      filteredList() {
          return this.products.filter(product => {
            return product.title.toLowerCase().includes(this.searchQuery.toLowerCase())
          })
        }
      },
    methods: {
      ...mapActions(['getShoppingCart', 'listenToProductList', 'updateFilteredProductList']),
      handleMenuClick(i) {
        this.navItems.forEach((item, index) => {
          item.isActive = index === i;
        });
      },
      openInNewTab: function (link, newTab) {
        if (newTab) {   
          window.open(link, "_blank");
        } else {
          window.location.href = link;
        } 
      }
    },
    created() {
      let uid = this.$store.getters.currentUser.uid;
      this.listenToProductList();
      this.getShoppingCart({uid, currentCart: this.$store.getters.cartItemList});
    }
  }
</script>

<style>
@import url('https://fonts.googleapis.com/css2?family=Roboto&display=swap');
@import url('https://fonts.googleapis.com/css2?family=Raleway&display=swap');
@import url('https://fonts.googleapis.com/css2?family=Waterfall&display=swap');

* {
  box-sizing: border-box;
  font-family: 'Raleway', sans-serif;
  -webkit-tap-highlight-color: transparent;
}

body, html {
  width: 100vw;
  max-width: 100%;
  height: 100vh;
  padding: 0;
  margin: 0;
  overflow-x: hidden;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  -ms-overflow-style: none;
  scrollbar-width: none;
}

body::-webkit-scrollbar {
  display: none;
}

input:focus, textarea:focus, select:focus{
  outline: none;
}

.__bar-is-vertical {
  margin-top: 3px !important;
}

#newsletter {
  --input-color: white;
}

.nav {
  display: flex;
  flex-direction: row;
  justify-content: space-between;
  align-items: center;
  padding: 0 20px;
  height: 60px;
  background: #fff;
  box-shadow: 0px 2px 4px rgba(0, 0, 0, 0.1);
}
</style>