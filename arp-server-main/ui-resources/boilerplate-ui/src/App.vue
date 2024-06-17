<template>
    <div id="app">
        <v-app>
            
        </v-app>
    </div>
</template>

<script>
import Nui from './utils/Nui';

export default {
    name: 'App',
    components: {

    },
    data: () => ({
        development: false,
    }),
    mounted() {
        this.listener = window.addEventListener('message', e => {
            const item = e.data || e.detail;
            const { event, data } = item;
            if (event) {
                this.$root.$emit(event, data)
                this.$root.$emit('addNuiEventLog', false, event, data);
            }
        }, false);


        if (Nui.inDev()) {
            this.development = true;
        }

        console.log(`UI Loaded [${Nui.inDev() ? 'Development Mode' : 'Built'}]`);

    },
    methods: {

    }
}
</script>

<style lang="less">
@import '@/arp-theme.less';

body, html, #app {
    width: 100vw;
    height: 100vh;
    overflow: hidden;
    padding: 0;
    margin: 0;
    -webkit-font-smoothing: antialiased;
    -moz-osx-font-smoothing: grayscale;
}

.v-application {
    background: transparent !important;
}

//Buttons
.v-btn__content {
    pointer-events: none;
}
// MultiSelector
.v-list-item__content {
    pointer-events: none;
}
.v-select__slot {
    pointer-events: none;
}
// Check box
.v-input--selection-controls__input {
    pointer-events: none;
}

</style>
