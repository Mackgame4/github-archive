<template>
<div v-if="userData.isAdmin" style="margin: 17px;">
  <div style="display: flex;">
    <h2 class="sf-heading__title h2">Painel Administrativo - {{ storeConfig.storeName }}</h2>
    <SfNotification
      style="margin-left: auto; padding-right: 40px;"
      v-if="notification"
      visible
      :persistent="false"
      message="Novas encomendas recebidas"
      type="secondary"
      @click:close="notification = false, closeNotification()"
    />
  </div>
  <SfTabs style="margin-bottom: -25px;" :openTab="openedTab">
    <SfTab title="Encomendas">
      <div style="display: flex; justify-content: center;">
        <span style="margin: auto;">Total encomendas: {{ transactions.length }}</span>
        <span style="margin: auto;">Encomendas completas: {{ totalCompletedOrders }}</span>
        <span style="margin: auto;">Total completas: {{ totalMadeCompleted+storeConfig.currency }}</span>
        <span style="margin: auto;">Total: {{ totalMade+storeConfig.currency }}</span>
      </div>
      <SfTable>
    <SfTableHeading>
      <SfTableHeader>Order ID</SfTableHeader>
      <SfTableHeader>Cliente</SfTableHeader>
      <SfTableHeader>Localidade</SfTableHeader>
      <SfTableHeader>Subtotal/Total</SfTableHeader>
      <SfTableHeader>Status</SfTableHeader>
      <SfTableHeader>Detalhes</SfTableHeader>
      <SfTableHeader>Ações</SfTableHeader>
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
      <SfTableData>
        <SfButton @click="selectedItem = i, orderId = { uid: item.uid, id: item.id }, modal = true">Mudar status</SfButton>
      </SfTableData>
    </SfTableRow>
  </SfTable>
    </SfTab>
    <SfTab title="Produtos">
      <span class="color-secondary sf-button" @click="addProduct()">Adicionar Produto</span><br>
      <SfInput
        v-model="productFilter"
        class="sf-input--filled"
        value=""
        label="Search Product"
        name="searchProduct"
        type="text"
      />
      <div style="display: flex; flex-wrap: wrap; overflow: auto;">
        <SfCategoryCard
          style="margin: 0 7px 14px 7px;"
          v-for="(product, i) in filteredProducts"
          :key="i"
          :label="product.title+' Quantidade: '+product.quantity"
          :count="'Regular: '+storeConfig.currency+product.price.regular+[product.price.sale != 0 ? ' Sale: '+storeConfig.currency+product.price.sale : '']"
          :background='product.thumbnail_url'
          link="#"
          @click="editProduct(product)"
        />
      </div>
    </SfTab>
    <SfTab title="Aplicação">
      <SfTextarea
        v-model="appDataTextArea"
        :cols="120"
        :rows="28"
        label="AppData Text Editor"
        name="appData"
        valid
        error-message="errorMessage"
        required
        placeholder="Data"
      />
      <span v-if="errorText" style="color: red;">{{ errorText }}</span>
      <SfButton @click="saveAppData()">Salvar</SfButton>
    </SfTab>
    <SfTab title="Pagamentos">
      <SfButton @click="openInNewTab('https://dashboard.stripe.com')">Abrir Stripe Dashboard</SfButton>
    </SfTab>
  </SfTabs>
  <div><hr class="sf-divider" /></div><br>
  <SfButton @click="$router.push('/store').catch(()=>{})">Voltar</SfButton>
  <SfModal v-if="modal" title="My title" visible cross overlay :persistent="false" @close="closeModal()">
    <p>Mudar status</p>
    <span class="color-warning sf-button" @click="changeStatus('pending')">Pending</span><br>
    <span class="color-info sf-button" @click="changeStatus('inprogress')">InProgress</span><br>
    <span class="color-secondary sf-button" @click="changeStatus('sent')">Sent</span><br>
    <span class="color-success sf-button" @click="changeStatus('completed')">Completed</span><br>
    <span class="color-danger sf-button" @click="changeStatus('deleted')">Delete</span>
  </SfModal>
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
</div>
</template>
<script>
import VueHtml2pdf from 'vue-html2pdf';
import { mapActions, mapGetters } from 'vuex'
import { storeConfig } from '../config/storeConfig';
import {
  SfInput,
  SfCategoryCard,
  SfImage,
  SfModal,
  SfTable,
  SfTextarea,
  SfTabs,
  SfNotification,
  SfButton
} from "@storefront-ui/vue";
export default {
  name: "AdminPanel",
  components: {
    VueHtml2pdf,
    SfInput,
    SfCategoryCard,
    SfImage,
    SfModal,
    SfTable,
    SfTextarea,
    SfTabs,
    SfNotification,
    SfButton
  },
  data() {
    return {
      storeConfig,
      openedTab: 1,
      notification: false,
      productFilter: '',
      selectedItem: -1,
      orderId: null,
      modal: false,
      appDataTextArea: '',
      errorText: '',
      transactions: []
    };
  },
  computed: {
    ...mapGetters(['products', 'isProductLoading', 'filteredProducts', 'userData', 'appData']),
    filteredProducts() {
      return this.products.filter(product => {
        return product.title.toLowerCase().includes(this.productFilter.toLowerCase());
      });
    },
    totalCompletedOrders() {
      return this.transactions.filter(transaction => {
        return transaction.data.status === 'completed';
      }).length;
    },
    totalMadeCompleted() {
      return this.transactions.filter(transaction => {
        return transaction.data.status === 'completed';
      }).reduce((acc, transaction) => {
        return acc + parseFloat((transaction.data.session.amount_total + '').replace(/[^\d.-]/g, ''))/100;
      }, 0);
    },
    totalMade() {
      let total = 0;
      this.transactions.forEach(transaction => {
        total += parseFloat((transaction.data.session.amount_total + '').replace(/[^\d.-]/g, ''))/100;
      });
      return total;
    }
  },
  mounted() {
    if (this.userData.isAdmin) {
      this.getDBData({
        collection: 'transactions'
      }).then(res => {
        //console.log(res, Object.keys(res).length);
        /*this.transactions = res.map(item => {
          return {
            id: item.id,
            orderId: item.orderId,
            date: item.date,
            location: item.location,
            quantity: item.quantity,
            status: item.status,
            transaction: item.transaction
          }
        })*/
        for (let i = 0; i < Object.keys(res).length; i++) {
          //this.transactions.push(res[Object.keys(res)[i]]);
          for (let j = 0; j < Object.keys(res[Object.keys(res)[i]]).length; j++) {
            this.transactions.push({ uid: Object.keys(res)[i], id: Object.keys(res[Object.keys(res)[i]])[j], data: res[Object.keys(res)[i]][Object.keys(res[Object.keys(res)[i]])[j]]});
          }
        }
      });
      this.getAppData().then(() => {
        const appData = this.appData;
        if (appData) {
          let dataToText = JSON.stringify(appData, null, 4);
          this.notification = appData.newShippings;
          //console.log(appData, dataToText);
          this.appDataTextArea = dataToText;
        }
      });
    } else {
      this.$router.push('/');
    }
  },
  methods: {
    ...mapActions(['updateCart', 'updateFilteredProductList', 'getAppData', 'updateAppData', 'getDBData', 'saveDBData']),
    saveAppData() {
        try {
          let data = this.appDataTextArea;
          let dataToJson = JSON.parse(data);
          this.updateAppData({ data: dataToJson });
          this.$toast.success('AppData saved!');
      } catch(e) {
        this.errorText = 'Invalid JSON, please fix before saving! No changes have been made.';
        setTimeout(() => {
          this.errorText = '';
        }, 7000);
        this.$toast.error(e.message);
        //alert(e);
      }
    },
    closeNotification() {
      this.updateAppData({
        name: "newShippings",
        data: false
      });
    },
    changeStatus(status) {
      console.log(this.orderId, status);
      this.saveDBData({
        collection: 'transactions/' + this.orderId.uid + '/' + this.orderId.id + '/status',
        data: status
      })
    },
    closeModal() {
      this.modal = false;
    },
    generatePdf(order) {
      console.log(order);
      this.$refs.html2Pdf.generatePdf()
    },
    openInNewTab: function (link) {
      window.open(link, "_blank");
    }
  }
};
</script>
<style lang="scss" scoped>
textarea {
  background: url(http://i.imgur.com/2cOaJ.png);
  background-attachment: local;
  background-repeat: no-repeat;
  padding-left: 35px;
  padding-top: 10px;
  border-color:#ccc;
}

.sf-category-card {
  background-position: center !important;
  background-size: cover !important;
  background-repeat: no-repeat !important;
}
</style>