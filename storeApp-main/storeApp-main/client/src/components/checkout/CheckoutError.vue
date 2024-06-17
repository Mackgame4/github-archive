<template>
  <div class="container">
    <SfCircleIcon icon="error"  iconSize="xxl" /><br>
    <h1 class="sf-heading__title h1">Ocorreu um erro a processar a sua encomenda!</h1><br>
    <SfButton @click="$router.push('/store').catch(()=>{})">Voltar às compras</SfButton>
  </div>
</template>
<script>
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
  mounted() {
  },
  methods: {
  }
};
</script>
<style lang="scss" scoped>
.container {
  display: flex;
  text-align: center;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  height: 100%;
  margin-top: 30px;
  margin-bottom: 30px;
}
</style>