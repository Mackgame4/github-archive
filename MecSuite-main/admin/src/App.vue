<script setup>
import { useRouter } from 'vue-router';

const router = useRouter();

import { mdiHome, mdiAccountWrench, mdiCarBack, mdiReceiptText, mdiBank, mdiPackageVariantClosed, mdiAccountTie, mdiCog } from '@mdi/js'

const routes = [
  {
    name: 'POS', // Point of Sale rapido para venda de produtos e serviços
    path: '/',
    icon: mdiHome,
  },
  {
    name: 'Faturação', // Faturação de serviços e produtos (mais completo e permite manuseio de um arranjo)
    path: '/facturation',
    icon: mdiReceiptText,
  },
  {
    name: 'Veículos', // Gestão de veículos dos clientes, incluindo manutenção e histórico (bem como os atuais na oficina)
    path: '/vehicles',
    icon: mdiCarBack,
  },
  {
    name: 'Contas', // Gestão de contas a pagar e receber, bem como gestão de empregados e os seus acessos e pagamentos
    path: '/sales',
    icon: mdiBank,
  },
  {
    name: 'Clientes', // Gestão de clientes, incluindo informações de contato
    path: '/clients',
    icon: mdiAccountTie,
  },
  {
    name: 'Produtos', // Gestão de produtos, incluindo inventário e preços
    path: '/produtos',
    icon: mdiPackageVariantClosed,
  },
  {
    name: 'Serviços', // Gestão de serviços oferecidos, incluindo preços e descrição e tempo de execução
    path: '/services',
    icon: mdiAccountWrench,
  },
  {
    name: 'Definições', // Configurações do sistema, incluindo preferências e personalizações
    path: '/settings',
    icon: mdiCog,
  }
];

import Icon from '@/components/Icon.vue'
</script>

<template>
  <ILayout class="app-layout">
    <ILayoutHeader class="app-header _padding-x:1/2! _display:flex! _align-items:center! _background:light! _border-bottom:1!">
      <IDropdown size="sm">
        <a>Clientes</a>
        <template #body>
          <IDropdownItem>Action</IDropdownItem>
        </template>
      </IDropdown>
      <IDropdown size="sm">
        <a>Veiculos</a>
        <template #body>
          <IDropdownItem>Action</IDropdownItem>
        </template>
      </IDropdown>
      <IDropdown size="sm">
        <a>Produtos</a>
        <template #body>
          <IDropdownItem>Action</IDropdownItem>
        </template>
      </IDropdown>
      <IDropdown size="sm">
        <a>Serviços</a>
        <template #body>
          <IDropdownItem>Action</IDropdownItem>
        </template>
      </IDropdown>
      <IDropdown size="sm">
        <a>Oficina</a>
        <template #body>
          <IDropdownItem>Action</IDropdownItem>
        </template>
      </IDropdown>
      <IDropdown size="sm">
        <a>Contas</a>
        <template #body>
          <IDropdownItem>Action</IDropdownItem>
        </template>
      </IDropdown>
      <IDropdown size="sm">
        <a>Ajuda</a>
        <template #body>
          <IDropdownItem>Action</IDropdownItem>
        </template>
      </IDropdown>
      <IDropdown size="sm">
        <a>Sair</a>
      </IDropdown>
    </ILayoutHeader>
    <ILayoutContent class="_padding:1!">
      <router-view/>
    </ILayoutContent>
    <ILayoutFooter class="_padding-x:1!">
      <ITabs class="_width:100%!" stretch v-model="router.currentRoute.value.path">
        <template #header>
          <ITabTitle v-for="route in routes" :key="route.name" :for="route.path" @click="router.push(route.path)">
            <div class="_display:flex! _flex-direction:column! _align-items:center!">
              <Icon :icon="route.icon" size="14" />
              <span class="_text:xs! _text-transform:uppercase!">{{ route.name }}</span>
            </div>
          </ITabTitle>
        </template>
      </ITabs>
    </ILayoutFooter>
  </ILayout>
</template>

<style>
* {
  box-sizing: border-box;
  margin: 0;
  padding: 0;
}

html, body {
  height: 100%;
  width: 100%;
}

#app {
  height: 100vh;
  width: 100vw;
  font-family: Inter, 'Avenir', Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-align: center;
}

.app-layout {
  height: 100vh;
  width: 100vw;
}

.app-header {
  position: sticky;
  top: 0;
  z-index: 1000;
  gap: 0.9rem;
  user-select: none;
}
</style>
