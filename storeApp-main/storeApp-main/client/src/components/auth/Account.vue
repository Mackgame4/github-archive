
<template>
  <div id="my-account">
    <Login v-if="!isLoggedIn"></Login>
    <SfContentPages
      v-else
      style="height: fit-content; margin-top: 0px; margin-bottom: 0px;"
      :title="currentUser.displayName ? 'Bem-vindo de volta, '+currentUser.displayName+'!' : 'Minha conta'"
      :active="activePage"
      class="my-account"
      @click:change="changeActivePage"
    >
      <SfContentCategory title="Detalhes pessoais">
        <SfContentPage title="Minha conta">
          <div class="float-container">
          <h3 class="sf-heading__title h3">Mudar Conta</h3><br>
          <SfInput :value="userData.firstName" label="Nome" name="name" type="text" />
          <SfInput :value="userData.lastName" label="Apelido" name="surname" type="text" />
          <SfInput :value="currentUser.email" label="Email" name="email" type="email" />
          <h3 class="sf-heading__title h3">Mudar Password</h3><br>
          <SfInput v-model="newpassword" name="password" label="Nova Password" type="password" class="form__element" :has-show-password="true" />
          <span class="sf-button" @click="onPasswordChange()">Salvar</span>
          </div>
        </SfContentPage>
        <!--SfContentPage title="Shipping details">
          <SfShippingDetails
            :account="account"
            :countries="countries"
            @update:shipping="account = { ...account, ...$event }"
          />
        </SfContentPage-->
      </SfContentCategory>
      <SfContentCategory title="Encomendas">
        <SfContentPage title="Histórico de encomendas">
          <h3 class="sf-heading__title h3">Encomendas</h3><br>
          <span>Verifique os detalhes e o status dos seus pedidos na loja online. Você também pode cancelar seu pedido ou solicitar uma devolução.</span>
          <SfTable>
            <SfTableHeading>
              <SfTableHeader>Order ID</SfTableHeader>
              <SfTableHeader>Cliente</SfTableHeader>
              <SfTableHeader>Localidade</SfTableHeader>
              <SfTableHeader>Subtotal/Total</SfTableHeader>
              <SfTableHeader>Status</SfTableHeader>
              <SfTableHeader>Detalhes</SfTableHeader>
            </SfTableHeading>
            <SfTableRow v-for="(item, i) in transactions" :key="i">
              <SfTableData style="padding-right: 10px;">{{ item.id.substring(1) }}</SfTableData>
              <SfTableData>{{ item.data.session.shipping.name }}</SfTableData>
              <SfTableData style="padding-right: 10px;">{{ item.data.session.shipping.address.city }}, {{ item.data.session.shipping.address.line1 }}, {{ item.data.session.shipping.address.postal_code }}</SfTableData>
              <SfTableData>{{ parseFloat((item.data.session.amount_subtotal + '').replace(/[^\d.-]/g, ''))/100 }}{{ storeConfig.currency }}/{{ parseFloat((item.data.session.amount_total + '').replace(/[^\d.-]/g, ''))/100 }}{{ storeConfig.currency }}</SfTableData>
              <SfTableData v-if="item.data.status == 'pending' || item.data.status == 'inprogress'" :class="[item.data.status == 'pending' ? 'text-warning' : 'text-info']">{{ item.data.status.charAt(0).toUpperCase() + item.data.status.slice(1) }}</SfTableData>
              <SfTableData v-if="item.data.status == 'sent'" class="text-secondary">{{ item.data.status.charAt(0).toUpperCase() + item.data.status.slice(1) }}</SfTableData>
              <SfTableData v-if="item.data.status == 'completed' || item.data.status == 'deleted'" :class="[item.data.status == 'completed' ? 'text-success' : 'text-danger']">{{ item.data.status.charAt(0).toUpperCase() + item.data.status.slice(1) }}</SfTableData>
              <SfTableData>
                <button class="sf-button--text sf-button" @click="selectedItem = i, generatePdf(item)">Ver encomenda</button>
              </SfTableData>
            </SfTableRow>
          </SfTable>
          <VueHtml2pdf
    :show-layout="false"
    :float-layout="true"
    :enable-download="false"
    :preview-modal="true"
    :paginate-elements-by-height="1400"
    filename="almastoreorder"
    :pdf-quality="2"
    :manual-pagination="false"
    pdf-format="a4"
    pdf-orientation="portrait"
    pdf-content-width="800px"
    ref="html2Pdf"
  >
    <section slot="pdf-content">
      <SfImage style="margin-top: 7px; margin-left: 7px;" :src="storeConfig.logoLight" alt="logo" :height="55" />
      <h1 class="text-appprimary" style="margin-top: -55px; margin-left: 100px; font-size: 45px; font-family: 'Waterfall', cursive;">Alma Store</h1>
      <div v-if="selectedItem >= 0">
        <div style="margin-top: -80px; margin-left: 510px;">
          <p>Costumer Name: {{ transactions[selectedItem].data.session.shipping.name }}</p>
          <p>Email: {{ transactions[selectedItem].data.session.customer_details.email }}</p>
        </div>
        <SfTable>
          <SfTableHeading>
            <SfTableHeader>Order ID</SfTableHeader>
            <SfTableHeader>Subtotal/Total</SfTableHeader>
          </SfTableHeading>
          <SfTableRow>
            <SfTableData style="padding-right: 10px;">{{ transactions[selectedItem].id.substring(1) }}</SfTableData>
            <SfTableData>{{ parseFloat((transactions[selectedItem].data.session.amount_subtotal + '').replace(/[^\d.-]/g, ''))/100 }}{{ storeConfig.currency }}/{{ parseFloat((transactions[selectedItem].data.session.amount_total + '').replace(/[^\d.-]/g, ''))/100 }}{{ storeConfig.currency }}</SfTableData>
          </SfTableRow>
        </SfTable><br>
        <SfTable>
          <SfTableHeading>
            <SfTableHeader>Shipping</SfTableHeader>
          </SfTableHeading>
          <SfTableRow>
            <SfTableData v-if="transactions[selectedItem].data.session.shipping.address.state" style="padding-right: 10px;">{{ transactions[selectedItem].data.session.shipping.address.city }}, {{ transactions[selectedItem].data.session.shipping.address.line1 }}, {{ transactions[selectedItem].data.session.shipping.address.state }}, {{ transactions[selectedItem].data.session.shipping.address.country }}, {{ transactions[selectedItem].data.session.shipping.address.postal_code }}</SfTableData>
            <SfTableData v-else style="padding-right: 10px;">{{ transactions[selectedItem].data.session.shipping.address.city }}, {{ transactions[selectedItem].data.session.shipping.address.line1 }}, {{ transactions[selectedItem].data.session.shipping.address.country }}, {{ transactions[selectedItem].data.session.shipping.address.postal_code }}</SfTableData>
          </SfTableRow>
        </SfTable><br>
        <SfTable>
          <SfTableHeading>
            <SfTableHeader>Item</SfTableHeader>
            <SfTableHeader>Name</SfTableHeader>
            <SfTableHeader>Description</SfTableHeader>
            <SfTableHeader>Quantity</SfTableHeader>
            <SfTableHeader>Price</SfTableHeader>
          </SfTableHeading>
          <SfTableRow v-for="(item, i) in transactions[selectedItem].data.cartItemList" :key="i">
            <SfTableData><img :src="item.thumbnail_url" width="47px" /></SfTableData>
            <SfTableData>{{ item.title }}</SfTableData>
            <SfTableData style="padding-right: 10px;">{{ item.description }}</SfTableData>
            <SfTableData>{{ item.quantity }}</SfTableData>
            <SfTableData v-if="item.price.sale != 0">{{ item.price.sale }}{{ storeConfig.currency }}</SfTableData>
            <SfTableData v-else>{{ item.price.regular }}{{ storeConfig.currency }}</SfTableData>
          </SfTableRow>
        </SfTable>
        <div style="margin-top: -35px; margin-left: 162px;">
          <h1 class="text-appprimary" style="font-size: 65px; font-family: 'Waterfall', cursive;">Obrigado pela sua compra!</h1>
          <h3 class="text-appprimary" style="margin-top: -55px; font-family: 'Waterfall', cursive;">- {{ storeConfig.storeName }}</h3>
        </div>
      </div>
    </section>
  </VueHtml2pdf>
        </SfContentPage>
      </SfContentCategory>
      <SfContentPage v-if="userData.isAdmin" title="Admin Panel" />
      <SfContentPage title="Log out" />
    </SfContentPages>
  </div>
</template>
<script>
import VueHtml2pdf from 'vue-html2pdf';
import {
  mapActions, mapGetters
} from 'vuex';
import {
  SfImage, 
  SfContentPages,
  SfInput,
  SfTable
} from "@storefront-ui/vue";
import Login from "./Login";
import { storeConfig } from '../../config/storeConfig';
import { countries } from "./internalData";
export default {
  name: "MyAccount",
  components: {
    Login,
    VueHtml2pdf,
    SfImage,
    SfContentPages,
    SfInput,
    SfTable
  },
  data() {
    return {
      storeConfig,
      activePage: "Minha conta",
      newpassword: "",
      selectedItem: -1,
      orderId: null,
      transactions: [],
      countries
    };
  },
  computed: {
    ...mapGetters([
      'isLoggedIn',
      'currentUser',
      'userData'
    ]),
  },
  mounted() {
    this.getDBData({
      collection: 'transactions'
    }).then(res => {
      //console.log(res, Object.keys(res).length);
      const uid = this.currentUser.uid;
      for (let i = 0; i < Object.keys(res).length; i++) {
        if (uid == Object.keys(res)[i]) {
          for (let j = 0; j < Object.keys(res[Object.keys(res)[i]]).length; j++) {
            this.transactions.push({ uid: Object.keys(res)[i], id: Object.keys(res[Object.keys(res)[i]])[j], data: res[Object.keys(res)[i]][Object.keys(res[Object.keys(res)[i]])[j]]});
          }
        }
      }
    });
  },
  /*watch: {
    isLoggedIn() {
      //console.log(this.userData);
      this.account.email = this.currentUser.email;
    },
    activePage() {
      console.log(this.activePage);
      this.account.email = this.currentUser.email;
    },
  },*/
  methods: {
    ...mapActions(['updatePassword', 'logout', 'getDBData']),
    changeActivePage(title) {
      if (title === "Log out") {
        this.logout();
        return;
      } else if (title === "Admin Panel") {
        this.$router.push("/admin");
        return;
      }
      this.activePage = title;
    },
    onPasswordChange() {
      let data = {
        newPassword: this.newpassword
      }
      this.updatePassword(data).then(() => {
        this.newpassword = "";
      });
    },
    generatePdf(orderId) {
      console.log(orderId);
      this.$refs.html2Pdf.generatePdf()
    }
  },
};
</script>
<style lang="scss" scoped>
@import "~@storefront-ui/vue/styles";
.float-container {
  padding: 20px;
}
#my-account {
  box-sizing: border-box;
  @include for-desktop {
    /*max-width: 1272px;
    padding: 0 var(--spacer-sm);*/
    margin: 0 auto;
  }
}
.my-account {
  @include for-mobile {
    --content-pages-sidebar-category-title-font-weight: var(
      --font-weight--normal
    );
    --content-pages-sidebar-category-title-margin: var(--spacer-sm)
      var(--spacer-sm) var(--spacer-sm) var(--spacer-base);
  }
  @include for-desktop {
    --content-pages-sidebar-category-title-margin: var(--spacer-xl) 0 0 0;
  }
}
.breadcrumbs {
  padding: var(--spacer-base) 0 var(--spacer-lg);
}
</style>