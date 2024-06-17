<template>
<div style="margin: 17px 17px 0 17px;">
  <SfTabs :openTab="openedTab">
    <SfTab title="Sobre Nós">
      <div style="display: table; margin: 0 auto;">
        <SfBanner title="#Se gostas usa" :subtitle="storeConfig.storeName" :description="'Aqui na '+storeConfig.storeName+' apoiamos a liberdade do vestuaria femenino e procuramos tudo na moda para te fazer destacar, pois tudo que tu gostas deves mostrar e usar. Porque estás à espera, visita-nos e descobre um novo tu?'" image="https://docs.storefrontui.io/static/media/Banner2.ed9cc6ce.jpg" />
        <div style="display: table; margin: 0 auto;">
        <h2>Quem somos?</h2>
        <div>
          <div style="max-width: 565px; margin-bottom: 20px; float: left;">{{ storeConfig.storeName }} foi fundada a 15 DE NOVEMBRO DE 2021 no Arco de Baúlhe por Joana Oliveira (@joana___oliveiraa). Uma loja de roupa feminina focada na liberdade de vestuário e moda atual.</div>
          <SfImage style="margin-left: 2vw;" class="desktop-only" src="https://i.imgur.com/zfYjEiQ.png" alt="@joana___oliveiraa" width="386" height="auto" />
          <SfImage style="margin-left: 2vw;" class="smartphone-only" src="https://i.imgur.com/zfYjEiQ.png" alt="@joana___oliveiraa" width="90%" height="auto" />
        </div>
        <h2>O nosso lema é:</h2>
        <span>Esquece as regras, se tu gostas USA! As roupas não vão mudar o mundo, as mulheres que as vestem vão.</span>
        <h2>A nossa marca apoia:</h2>
        <SfCharacteristic style="float: left; margin-bottom: 35px; margin-right: 5vw;" icon="account" title="Segurança" description="Cada produto é cuidadosamente embalado e enviado com um toque pessoal." />
        <SfCharacteristic style="float: left; margin-bottom: 35px; margin-right: 5vw;" icon="gift" title="Carinho" description="Cada cliente é especial para nós, e para isso cuidamos de todos." />
        <SfCharacteristic style="float: left; margin-bottom: 35px;" icon="heart" title="Individualidade" description="Todos os nossos clientes podem contar connosco." />
        </div>
      </div>
      <SfStoreLocator style="margin: 0 auto;" class="locator desktop-only" :tileServerAttribution="storeConfig.storeName+'&copy;'+storeConfig.stores[0].location+', '+storeConfig.stores[0].address" :center="storeConfig.stores[0].latlng" :zoom="8" :flyToStoreZoom="18">
        <SfStore :latlng="storeConfig.stores[0].latlng"
          :name="storeConfig.storeName"
          picture="https://i.imgur.com/pqCn7AR.png"
          :pictureWidth="82"
          :pictureHeight="112"
          :address="storeConfig.stores[0].location+', '+storeConfig.stores[0].address+', @'+storeConfig.stores[0].latlng"
          :phone="storeConfig.stores[0].phone"
          :email="storeConfig.stores[0].email"
        />
      </SfStoreLocator>
      <SfStoreLocator style="margin: 0 auto;" class="smartphone-only" :tileServerAttribution="storeConfig.storeName+'&copy;'+storeConfig.stores[0].location+', '+storeConfig.stores[0].address" :center="storeConfig.stores[0].latlng" :zoom="8" :flyToStoreZoom="18">
        <SfStore :latlng="storeConfig.stores[0].latlng"
          :name="storeConfig.storeName"
          picture="https://i.imgur.com/pqCn7AR.png"
          :pictureWidth="82"
          :pictureHeight="112"
          :address="storeConfig.stores[0].location+', '+storeConfig.stores[0].address+', @'+storeConfig.stores[0].latlng"
          :phone="storeConfig.stores[0].phone"
          :email="storeConfig.stores[0].email"
        />
      </SfStoreLocator>
    </SfTab>
    <SfTab title="Newsletter">
      <div style="display: table; margin: 0 auto;">
        <h2>Newsletter</h2>
        <span>Esteja atualizado das próximas vendas e eventos. Receba presentes e ofertas especiais!</span>
        <SfInput style="margin-top: 15px;" value="" label="Email" name="name" type="text" :required="true" />
        <span class="sf-button">Subscrever</span>
        <SfCheckbox v-model="checkbox" style="margin-top: 18px;" name="terms" label="I agree with the terms and conditions" :required="true" :selected="false" />
        </div>
    </SfTab>
    <SfTab title="Termos e Garantia">
      <h1># Termos de utilização e compra</h1>
      <div>
        <iframe src="https://pastebin.com/embed_iframe/FzG7aLSt" style="border:none;width:100%"></iframe>
      </div>
      <h1># Garantia e entrega</h1>
      <div>
        <b>• Entrega normal (3-7 dias úteis)</b>
        <p>5{{ storeConfig.currency }} de portes, grátis para encomendas de valor superior a 50{{ storeConfig.currency }}</p>
        <b>• Entrega expresso (1-3 dias úteis)</b>
        <p>15,00{{ storeConfig.currency }} de portes, grátis para encomendas de valor superior a 99{{ storeConfig.currency }}</p>
        <b>
        <p>Tenha em atenção que a entrega normal pode demorar mais tempo para localizações remotas.</p>
        <p>A {{ storeConfig.storeName }} não faz entregas diretamente na Madeira nem nos Açores.</p>
        <p>Todos os produtos têm um prazo de devolução de 7 dias após entrega.</p>
        </b>
        </div>
    </SfTab>
    <SfTab title="Guia de Tamanhos">
      <SfTable>
        <SfTableHeading>
          <SfTableHeader>Guia de Tamanhos</SfTableHeader>
        </SfTableHeading>
        <SfTableRow v-for="(size, i) in sizeGuideTable" :key="i">
          <SfTableData><b>{{ size.name }}</b></SfTableData>
          <SfTableData v-for="(row, k) in size.sizes" :key="k">{{ row }}</SfTableData>
        </SfTableRow>
      </SfTable>
    </SfTab>
  </SfTabs>
  <div style="position: absolute; left: 0; width: 100%;" @mouseover="hover = true" @mouseleave="hover = false">
  <SfTopBar>
    <template #center>
      <h3>Website made with <img v-if="hover" style="margin-bottom: -7px;" src="https://img.icons8.com/material-sharp/24/000000/like--v1.png"/><img v-else style="margin-bottom: -7px;" src="https://img.icons8.com/material-outlined/24/000000/like--v1.png"/> by <a href="https://github.com/Mackgame4">Mackgame4</a></h3>
    </template>
  </SfTopBar>
  </div>
</div>
</template>
<script>
import { storeConfig } from '../config/storeConfig';
import L from 'leaflet';
delete L.Icon.Default.prototype._getIconUrl;
import {
  SfTabs,
  SfTable,
  SfStoreLocator,
  SfCharacteristic,
  SfBanner,
  SfImage,
  SfTopBar,
  SfInput,
  SfCheckbox
} from "@storefront-ui/vue";
export default {
  name: "Category",
  components: {
    SfTabs,
    SfTable,
    SfStoreLocator,
    SfCharacteristic,
    SfBanner,
    SfImage,
    SfTopBar,
    SfInput,
    SfCheckbox
  },
  data() {
    return {
      storeConfig,
      hover: false,
      checkbox: false,
      openedTab: parseInt(this.$route.params.pathMatch),
      sizeGuideTable: [
        { name: "EUA Homem", sizes: [3.5,4,4.5,5,5.5,6,6.5,7,7.5,8,8.5,9,9.5,10,10.5,11,11.5,12,12.5,13,13.5,14,14.5,15,15.5,16,16.5,17,17.5,18,18.5,19,19.5,20,20.5,21,21.5,22] },
        { name: "EUA Mulher", sizes: [5,5.5,6,6.5,7,7.5,8,8.5,9,9.5,10,10.5,11,11.5,12,12.5,13,13.5,14,14.5,15,15.5,16,16.5,17,17.5,18,18.5,19,19.5,20,20.5,21,21.5,22,22.5,23,23.5] },
        { name: "RU", sizes: [3,3.5,4,4.5,5,5.5,6,6,6.5,7,7.5,8,8.5,9,9.5,10,10.5,11,11.5,12,12.5,13,13.5,14,14.5,15,15.5,16,16.5,17,17.5,18,18.5,19,19.5,20,20.5,21] },
        { name: "CM", sizes: [22.5,23,23.5,23.5,24,24,24.5,25,25.5,26,26.5,27,27.5,28,28.5,29,29.5,30,30.5,31,31.5,32,32.5,33,33.5,34,34.5,35,35.5,36,36.5,37,37.5,38,38.5,39,39.5,40] },
        { name: "UE", sizes: [35.5,36,36.5,37.5,38,38.5,39,40,40.5,41,42,42.5,43,44,44.5,45,45.5,46,47,47.5,48,48.5,49,49.5,50,50.5,51,51.5,52,52.5,53,53.5,54,54.5,55,55.5,56,56.5] }
      ]
    };
  },
  mounted() {
    L.icon({
        iconUrl: 'https://i.imgur.com/9lhSpme.png',
        shadowUrl: 'https://i.imgur.com/9lhSpme.png',
    });
  },
  methods: {
  }
};
</script>
<style lang="scss" scoped>
.sf-characteristic {
  max-width: 300px !important;
}
.locator {
  max-width: 70% !important;
}
</style>