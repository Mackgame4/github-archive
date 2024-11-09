import { createApp } from 'vue'
import './css/style.css'
import App from './App.vue'

import './js/jquery.js'
import './js/webfont.js'
WebFont.load({
    google: {
    families: ["Great Vibes:400", "Sorts Mill Goudy:regular,italic", "Sorts Mill Goudy:regular,italic"]
    }
});

createApp(App).mount('#app')
