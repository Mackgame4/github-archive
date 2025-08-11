<script lang="ts" setup>
import { ref, computed, onMounted, onUnmounted } from 'vue';
import Config from '@/utils/config';

const activeTab = ref<string>('services');

import Icon from '@/components/Icon.vue';

import { mdiPlus, mdiCashRegister, mdiAccount, mdiBackspaceOutline, mdiEqual, mdiMinus, mdiClose } from '@mdi/js';

// Calculator logic
const displayValue = ref<string>('0');
const previousValue = ref<number | null>(null);
const operation = ref<string | null>(null);
const shouldResetDisplay = ref<boolean>(false);
const parcelar = ref<number>(1);

const inputDigit = (digit: string) => {
  if (shouldResetDisplay.value) {
    displayValue.value = digit;
    shouldResetDisplay.value = false;
  } else {
    displayValue.value = displayValue.value === '0' ? digit : displayValue.value + digit;
  }
};

const inputDecimal = () => {
  if (shouldResetDisplay.value) {
    displayValue.value = '0.';
    shouldResetDisplay.value = false;
    return;
  }
  if (!displayValue.value.includes('.')) {
    displayValue.value += '.';
  }
};

const handleKeyDown = (e: KeyboardEvent) => {
  const key = e.key;
  if (e.code.startsWith('F') && parseInt(e.code.slice(1))) {
    return;
  }
  if (/[0-9]|\.|\+|-|\*|\/|Enter|=|Backspace|Escape/.test(key)) {
    e.preventDefault();
    if (/[0-9]/.test(key)) {
      inputDigit(key);
    } else if (key === '.') {
      inputDecimal();
    } else if (key === '+' || key === '-' || key === '*' || key === '/') {
      setOperation(key);
    } else if (key === 'Enter' || key === '=') {
      handleEquals();
    } else if (key === 'Escape') {
      clearAll();
    } else if (key === 'Backspace') {
      clearChar();
    }
  }
};

// TODO: if theres a search bar, handle search input and prevent default behavior
onMounted(() => {
  window.addEventListener('keydown', handleKeyDown);
});

onUnmounted(() => {
  window.removeEventListener('keydown', handleKeyDown);
});

const addToProducts = () => {
  // Add a "others" product
  calculateResult();
  const value = parseFloat(displayValue.value);
  if (isNaN(value) || value <= 0) return;
  selectedProducts.value.push({
    id: 0,
    name: 'Outros',
    price: value,
    quantity: 1
  });
};

const clearAll = () => {
  displayValue.value = '0';
  previousValue.value = null;
  operation.value = null;
  shouldResetDisplay.value = false;
};

const clearChar = () => {
  if (displayValue.value.length > 1) {
    displayValue.value = displayValue.value.slice(0, -1);
  } else {
    displayValue.value = '0';
  }
  shouldResetDisplay.value = false;
};

const calculateResult = () => {
  if (previousValue.value === null || operation.value === null) return;
  const currentValue = parseFloat(displayValue.value);
  let result: number;
  switch (operation.value) {
    case '+':
      result = previousValue.value + currentValue;
      break;
    case '-':
      result = previousValue.value - currentValue;
      break;
    case '*':
      result = previousValue.value * currentValue;
      break;
    case '/':
      result = previousValue.value / currentValue;
      break;
    default:
      return;
  }
  displayValue.value = result.toString();
  previousValue.value = result;
  shouldResetDisplay.value = true;
  operation.value = null;
};

const setOperation = (op: string) => {
  if (operation.value && !shouldResetDisplay.value) {
    calculateResult();
  }
  previousValue.value = parseFloat(displayValue.value);
  operation.value = op;
  shouldResetDisplay.value = true;
};

const handleEquals = () => {
  if (operation.value && previousValue.value !== null) {
    calculateResult();
  }
};

// Product list logic
const products = ref([
  { id: 1, name: 'Serviço Jurídico', price: 500 },
  { id: 2, name: 'Consulta', price: 200 },
  { id: 3, name: 'Elaboração de Contrato de Servico', price: 800 },
  { id: 4, name: 'Audiência', price: 300 },
  { id: 5, name: 'Parecer Técnico', price: 600 }
]);

const selectedProducts = ref<{id: number, name: string, price: number, quantity: number}[]>([]);

const total = computed(() => {
  return selectedProducts.value.reduce((sum, product) => {
    return sum + (product.price * product.quantity);
  }, 0);
});

const addProduct = (product: {id: number, name: string, price: number}) => {
  const existingProduct = selectedProducts.value.find(p => p.id === product.id);
  if (existingProduct) {
    existingProduct.quantity += 1;
  } else {
    selectedProducts.value.push({...product, quantity: 1});
  }
};

const removeProduct = (productId: number) => {
  const index = selectedProducts.value.findIndex(p => p.id === productId);
  if (index !== -1) {
    selectedProducts.value.splice(index, 1);
  }
};

const removeOneProduct = (productId: number) => {
  const product = selectedProducts.value.find(p => p.id === productId);
  if (product) {
    if (product.quantity > 1) {
      product.quantity -= 1;
    } else {
      removeProduct(productId);
    }
  }
};
</script>

<template>
  <ILayout vertical>
    <ILayoutContent class="_padding-right:1!">
      <ITabs stretch v-model="activeTab">
        <template #header>
          <ITabTitle for="services">Serviços</ITabTitle>
          <ITabTitle for="products">Produtos</ITabTitle>
        </template>
        <ITab name="services">
          <div class="product-list">
            <IButton  v-for="product in products"  :key="product.id"  size="lg"  active  @click="addProduct(product)" class="product-button">
              <div class="_display:flex! _flex-direction:column! _align-items:center!">
                <span class="_font-weight:semibold! _font-size:md! _margin-bottom:1/4!">{{ product.name }}</span>
                <span class="_font-size:sm!">{{ product.price.toFixed(2) }}{{ Config.currencySymbol }}</span>
              </div>
            </IButton>
          </div>
        </ITab>
        <ITab name="products"> Tab 2 content </ITab>
      </ITabs>
    </ILayoutContent>
    <ILayoutAside>
      <IButton size="lg" class="_margin-bottom:1! _width:100%!">
        <template #icon>
          <Icon :icon="mdiAccount" size="24" />
        </template>
        Fatura Cliente
      </IButton>
      <div class="_background:light! _border-radius:1! _padding-x:1! _padding-y:1/2! _border-radius:md! _height:100%!" id="selectedProducts">
        <div v-if="selectedProducts.length === 0" class="_text:center! _text:sm!">Nenhum produto selecionado</div>
        <div v-else>
          <div v-for="product in selectedProducts" :key="product.id" class="_display:flex! _justify-content:space-between! _align-items:center! _margin-bottom:1/4!">
            <IButton color="danger" @click="removeOneProduct(product.id)" size="sm">
              <template #icon>
                <Icon :icon="mdiClose" size="10" />
              </template>
            </IButton>
            <span>{{ product.name }} ({{ product.quantity }})</span>
            <span>{{ (product.price * product.quantity).toFixed(2) }}{{ Config.currencySymbol }}</span>
          </div>
        </div>
      </div>
      <div class="_display:flex! _flex-direction:column! _align-items:center! _margin-top:1!">
        <div class="_display:flex! _flex-direction:row! _justify-content:space-between! _width:100%!">
          <span class="_font-weight:semibold! _font-size:sm!">Subtotal:</span>
          <span class="_font-size:sm!">{{ total.toFixed(2) }}{{ Config.currencySymbol }}</span>
        </div>
        <div class="_display:flex! _flex-direction:row! _justify-content:space-between! _width:100%!">
          <span class="_font-weight:semibold! _font-size:lg!">Total:</span>
          <span class="_font-size:lg! _font-weight:bold!">{{ total.toFixed(2) }}{{ Config.currencySymbol }}</span>
        </div>
        <div class="_display:flex! _flex-direction:row! _justify-content:space-between! _width:100%!">
          <span class="_font-weight:semibold! _font-size:sm!">Parcelas:</span>
          <span class="_font-size:sm!">
            {{ parcelar }}x {{ (total / parcelar).toFixed(2) }}{{ Config.currencySymbol }}
          </span>
        </div>
        <INumberInput size="sm" v-model="parcelar" :min="1" :max="100" class="_width:100%! _margin-top:1/4!" />
      </div>
      <IButtonGroup class="_margin-top:1/2! _margin-bottom:1! _width:100%!">
        <IButton color="primary" @click="addToProducts" class="_width:100%!">
          <template #icon>
            <Icon :icon="mdiCashRegister" size="18" />
          </template>
          Registar
        </IButton>
      </IButtonGroup>
      <div class="calculator-display">
        <IInput type="text" readonly v-model="displayValue" placeholder="Value" />
        <IButton @click="clearChar"><Icon :icon="mdiBackspaceOutline" size="14" /></IButton>
        <IButton @click="clearAll">C</IButton>
        <IButton color="secondary" @click="addToProducts">CE</IButton>
      </div>
      <div class="calculator-buttons">
        <IButton size="sm" @click="inputDigit('7')">7</IButton>
        <IButton size="sm" @click="inputDigit('8')">8</IButton>
        <IButton size="sm" @click="inputDigit('9')">9</IButton>
        <IButton size="sm" @click="setOperation('*')"><Icon :icon="mdiClose" size="14" /></IButton>
        <IButton size="sm" @click="inputDigit('4')">4</IButton>
        <IButton size="sm" @click="inputDigit('5')">5</IButton>
        <IButton size="sm" @click="inputDigit('6')">6</IButton>
        <IButton size="sm" @click="setOperation('-')"><Icon :icon="mdiMinus" size="14" /></IButton>
        <IButton size="sm" @click="inputDigit('1')">1</IButton>
        <IButton size="sm" @click="inputDigit('2')">2</IButton>
        <IButton size="sm" @click="inputDigit('3')">3</IButton>
        <IButton size="sm" @click="setOperation('+')"><Icon :icon="mdiPlus" size="14" /></IButton>
        <IButton size="sm" @click="setOperation('/')">/</IButton>
        <IButton size="sm" @click="inputDigit('0')">0</IButton>
        <IButton size="sm" @click="inputDecimal">.</IButton>
        <IButton size="sm" color="primary" @click="handleEquals"><Icon :icon="mdiEqual" size="14" /></IButton>
      </div>
    </ILayoutAside>
  </ILayout>
</template>

<style scoped>
.product-list {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
  gap: 10px;
  margin-bottom: 20px;
}

.product-button :deep(.button-content) {
  max-width: 100%;
  overflow: hidden;
  text-overflow: ellipsis;
}

.calculator-display {
  display: flex;
  flex-direction: row;
  align-items: center;
  justify-content: space-between;
  gap: 10px;
  margin-bottom: 10px;
}

#selectedProducts {
  overflow-y: auto;
  max-height: calc(100vh - 630px);
}

.calculator-buttons {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 10px;
}

.layout-aside :deep(.layout-aside-children) {
  display: flex;
  flex-direction: column;
  height: 100%;
}
</style>