<template>
    <div id="app">
        <v-app>
            <v-card class="mx-auto" max-width="344" style="top: 20vw;">
                <v-list-item three-line>
                    <v-list-item-content>
                        <div class="text-overline mb-4">Execute NUI Event</div>
                        <v-list-item-title class="text-h5 mb-1">Execute a test event</v-list-item-title>
                        <v-list-item-subtitle>This dialog executes a test event from the NUI to the resource back-end</v-list-item-subtitle>
                    </v-list-item-content>
                </v-list-item>
                <v-card-actions>
                    <v-btn outlined text color="success" v-on:click="execute">Execute</v-btn>
                    <v-btn outlined text color="error" v-on:click="close">Close</v-btn>
                </v-card-actions>
            </v-card>
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
        close: function() {
            console.log(`NUI executed "close"`);
        },
        execute: function() {
            console.log(`NUI executed "confirm"`);
        }
    }
}
</script>

<style lang="less">
@import '@/theme.less';

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