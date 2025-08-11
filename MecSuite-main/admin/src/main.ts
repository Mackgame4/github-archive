import { createApp } from 'vue';
import App from '@/App.vue';
import router from '@/router';
import { Inkline, components } from '@inkline/inkline';
import '@inkline/inkline/css/variables/index.scss'; // npx inkline generate scss -o src/css/variables
import '@inkline/inkline/css/index.scss';
import '@inkline/inkline/css/utilities.scss';
import './registerServiceWorker';

createApp(App).use(Inkline, { colorMode: 'light', components }).use(router).mount('#app');
