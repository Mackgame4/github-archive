<template>
    <div id="app">
        <v-app v-if="showUI">
            <v-switch v-if="development" class="ma-2" v-model="screenModeSwitch" :label="`Screen Mode Switch: ${screenModeSwitch.toString()}`" inset></v-switch>
            <v-btn v-if="development" style="width: 300px;" elevation="2" @click="$store.commit('setHomePage', !$store.state.homePage);">Open/Close App</v-btn>
            <img class="frame" :src="screenMode">
            <div class="bg" v-bind:style="{ backgroundImage: 'url(' + updateBg + ')' }"></div>
            <div class="screen">
                <v-scale-transition>
                <div v-if="this.$store.state.homePage">
                    <draggable class="deskApps" :animation="200" v-model="deskApps" group="people" ghost-class="ghostClass" @start="drag=true" @end="drag=false">
                        <div class="deskApp elevation-5" v-bind:style="{ background: app.bgColor}" v-for="app in deskApps" :key="app.name" v-on:click="openApp(app.clickEvent)"><v-icon style="font-size: 35px; padding: 9px;">{{app.icon}}</v-icon><span>{{app.name}}</span></div>
                    </draggable>
                </div>
                </v-scale-transition>
                <v-fade-transition>
                <div v-if="!this.$store.state.homePage">
                    <div id="appHandler">
                        <policeApp v-if="clickEvent == 'openPolice'" />
                        <medApp v-if="clickEvent == 'openMed'" />
                        <settingsApp v-if="clickEvent == 'openSettings'" />
                    </div>
                </div>
                </v-fade-transition>
            </div>
        </v-app>
    </div>
</template>

<script>
import Nui from './utils/Nui';
import draggable from 'vuedraggable';
import policeApp from './components/policeApp.vue';
import medApp from './components/medApp.vue';
import settingsApp from './components/settingsApp.vue';

export default {
    name: 'App',
    components: {
        draggable,
        policeApp,
        medApp,
        settingsApp
    },
    data: () => ({
        development: process.env.NODE_ENV === 'development',
        showUI: false,
        screenModeSwitch: false,
        screenMode: './assets/tablet.png',
        clickEvent: null,
        deskApps: [
            /*{ name: 'Twitter', icon: 'mdi-twitter', bgColor: 'linear-gradient(#076CE2, #298FE1)', clickEvent: "openTwitter"},
            { name: 'Safari', icon: 'mdi-apple-safari', bgColor: 'linear-gradient(#08C2EA, #0F58E0)'},
            { name: 'Appstore', icon: 'mdi-shopping', bgColor: 'linear-gradient(#2a00ff, #12006e)'},
            { name: 'Calendar', icon: 'mdi-calendar', bgColor: 'linear-gradient(#FF7BAC, #662D91)'},*/
            // MDT
            { name: 'Police Terminal', icon: 'mdi-shield-star', bgColor: 'linear-gradient(#076CE2, #298FE1)', clickEvent: "openPolice"},
            { name: 'Med Terminal', icon: 'mdi-ambulance', bgColor: 'linear-gradient(#e20707, #e12929)', clickEvent: "openMed"},
            { name: 'Settings', icon: 'mdi-cog', bgColor: 'linear-gradient(#1C1C1C, #353535)', clickEvent: "openSettings"},
        ],
    }),
    mounted() {
        this.listener = window.addEventListener('message', e => {
            const item = e.data || e.detail;
            const { event, data } = item;
            if (event) {
                this.$root.$emit(event, data)
                this.$root.$emit('addNuiEventLog', false, event, data);
            }

            if (item.show) {
                this.$store.commit('setHomePage', true);
                this.showUI = true;
            } else if (item.show == false) {
                this.showUI = false;
            }
        }, false);

        if (Nui.inDev()) {
            this.development = true;
        }

        console.log(`UI Loaded [${Nui.inDev() ? 'Development Mode' : 'Built'}]`);
    },
    watch: {
        showUI: function() {
            console.log(`UI Visible: ${this.showUI}`);
        },
        screenModeSwitch: function(val) {
            if (val) {
                this.screenMode = './assets/pc.png';
            } else {
                this.screenMode = './assets/tablet.png';
            }
        }
    },
    computed: {
        updateBg() {
            return this.$store.state.background;
        }
    },
    methods: {
        openApp: function(event) {
            console.log(event);
            this.$store.commit('setHomePage', false);
            this.clickEvent = event;
        }
    }
}
</script>

<style lang="less" scoped>
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

.frame {
    position: absolute;
    top: 28vw;
    left: 50vw;
    width: 60vw;
    transform: translate(-50%, -50%);
    z-index: 2;
}

.bg {
    position: absolute;
    top: 5vw;
    left: 21vw;
    width: 57vw;
    height: 32vw;
    background-size: cover;
    background-position: center;
    background-repeat: no-repeat;
    z-index: 1;
}

.screen {
    position: absolute;
    top: 5vw;
    left: 21vw;
    width: 57vw;
    height: 67vw;
    z-index: 3;

    .deskApps {
        margin-top: -10px;
        margin-left: 40px;
        .deskApp {
            width: 53px;
            height: 53px;
            border-radius: 12px;
            margin: 35px 0 35px 0;

            span {
                margin-top: 3px;
                font-size: 12px;
                line-height: 13px;
                font-weight: bold;
                text-align: center;
                display: flex;
                align-items: center;
                justify-content: center;
            }
        }
    }
}

#appHandler {
    position: absolute;
    top: 0.6vw;
    left: 1.2vw;
    z-index: 3;
}
</style>

<style>
.ghostClass {
    opacity: 0.5;
    background: #F7FAFC;
}

::-webkit-scrollbar {
    width: 10px;
}

::-webkit-scrollbar-track {
    background: none; 
}

::-webkit-scrollbar-thumb {
    background: #1E1E1E;
    border-radius: 7px;
}

::-webkit-scrollbar-thumb:hover {
    background: rgb(10, 10, 10); 
}
</style>