<template>
<div style="position: relative; margin: 22px 22px 22px 22px;">
  <div class="product-card">
      <SfProductCard
        :image="item.thumbnail_url"
        imageWidth="100%"
        imageHeight="auto"
        badgeLabel="New"
        :title="item.title"
        :link="'/product/' + item.id"
        :regularPrice="storeConfig.currency+item.price"
        wishlistIcon=""
        showAddToCartButton
        :isAddedToCart="false"
      />
      <span class="desktop-only" style="position: absolute; bottom: 3vh; left: 8vw; z-index: 1;">{{ item.quantity }} left in stock</span>
      <span class="smartphone-only" style="position: absolute; bottom: 10px; left: 55px; z-index: 1;">{{ item.quantity }} left in stock</span>
  </div>
</div>
<!--div class="mb-3 col-sm-6 col-md-4 item" :class="{'list-group-item': displayList}">
  <div class="thumbnail card">
    <div class="img-event intrinsic">
      <img :src="item.thumbnail_url" alt="" class="grow thumbnail-image card-img-top intrinsic-item p-3">
    </div>
    <div class="card-body">
      <router-link :to="'/product/' + item.id" tag="h5" class="card-title"><a>{{ item.title }}</a></router-link>
      <h6 class="card-subtitle mb-2 remain">{{ item.quantity }} left in stock</h6>

      <p class="card-text truncate">{{ item.description | shortDescription}}</p>

      <div class="row">
        <p class="col-6 lead">${{ item.price }}</p>
        <p class="col-6">
          <button class="btn btn-success pull-right" :disabled="item.quantity === 0" @click="addItem">
            Add to cart
          </button>
        </p>
      </div>
    </div>
  </div>
</div-->
</template>

<script>
import {
  mapActions
} from 'vuex';
import { SfProductCard } from '@storefront-ui/vue';
import { storeConfig } from '../../config/storeConfig';
export default {
  props: ['item', 'displayList'],
  data() {
    return {
      storeConfig
    };
  },
  components: {
    SfProductCard
  },
  methods: {
    ...mapActions(['updateCart']),
    addItem() {
      const order = {
        item: Object.assign({}, this.item),
        quantity: 1,
        isAdd: true
      };
      this.updateCart(order);
    }
  },
  filters: {
    shortDescription(value) {
      if (value && value.length > 100) {
        return value.substring(0, 100) + '...';
      } else {
        return value;
      }
    }
  }
}
</script>

<style>
/*.sf-product-card__rating {
  display: none !important;
}

.sf-product-card__reviews-count {
  margin: 0 0 0 0 !important;
}*/

.product-card {
  width: 200px;
  float: left;
}

.sf-product-card__add-button {
  bottom: -10px !important;
  right: 7px !important;
  z-index: 9999;
}
</style>