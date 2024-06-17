<template>
    <div id="app">
        <v-app>
            <div class="phoneOuter" :class="phoneClasses"></div>
            <div class="phoneInner" :style="phoneInnerStyle" :class="phoneClasses">
                <div class="phoneContainer">
                    <v-system-bar :lights-out="!appOpen" class="statusBar">
                        <span>{{ getGameTime }}</span>
                        <v-spacer></v-spacer>
                        <span v-if="getPhoneCall" @click="quickOpenApp('phone')">
                            <v-icon class="statusIcon" v-if="getPhoneCall.outgoing" color="green">mdi-phone-outgoing</v-icon>
                            <v-icon class="statusIcon" v-else color="green">mdi-phone-incoming</v-icon>
                            {{ getPhoneCall.length }}
                        </span>
                        <v-spacer></v-spacer>
                        <v-spacer></v-spacer>
                        <v-icon class="statusIcon">mdi-volume-vibrate</v-icon>
                        <v-icon class="statusIcon">mdi-wifi-arrow-up-down</v-icon>
                        <span @click="quickOpenApp('dev')"><v-icon color="red darken-4" class="statusIcon smaller">mdi-signal-5g</v-icon></span>
                        <v-icon class="statusIcon">mdi-signal-cellular-2</v-icon>
                        <v-icon class="statusIcon">mdi-battery-70</v-icon>
                    </v-system-bar>
        

                    <transition name="fade">
                        <div class="notificationContainer" v-if="appOpen !== 'notifications'">
                            <transition-group name="notification" :duration="{ enter: 250, leave: 200 }" mode="in-out">
                                <Notification v-for="item in getTopNotifications" v-bind:key="item.id" :data="item" @dismiss="dismissNotification(item.id)" />
                            </transition-group>
                        </div>
                    </transition>

                    <Dialogs @overlay="overlayOpacity" />
                    <SnackBar />

                    <div v-if="opacityOverlay" class="dialogOverlay"></div>
                    <div v-if="loadingOverlay" class="dialogOverlay">
                        <v-progress-circular indeterminate size="64" style="width: 100%; height: 15%; margin: 100% 0;"></v-progress-circular>
                    </div>

                    <HomeScreen />


                    <transition name="fade" @afterEnter="appOpened">
                        <div class="appContainer" id="appContainer" :style="appContainerStyle" v-if="appOpen">
                            <component v-if="currentAppComponent" v-bind:is="currentAppComponent" :initData="appInitData" />
                        </div>
                    </transition>
                </div>
                <div class="controls" :class="{ 'inApp': appOpen }">
                    <v-spacer></v-spacer>
                    <v-btn :disabled="homeButtonDisabled" class="outerBtn" icon color="white" medium @click="quickOpenApp('notifications')">
                        <v-icon class="tinyIcon">mdi-bell-outline</v-icon>
                    </v-btn>

                    <v-spacer></v-spacer>
                    <v-btn icon color="white" class="outerBtn" medium @click="controlBack">
                        <v-icon class="regIcon">mdi-chevron-left</v-icon>
                    </v-btn>
                    <v-spacer></v-spacer>
                    <v-btn :disabled="homeButtonDisabled" class="outerBtn" icon color="white" medium @click="homeButton">
                        <v-icon class="regIcon">mdi-circle-outline</v-icon>
                    </v-btn>
                    <v-spacer></v-spacer>
                    <v-btn icon color="white" class="outerBtn" medium @click="startClose">
                        <v-icon class="regIcon">mdi-chevron-down</v-icon>
                    </v-btn>
                    <v-spacer></v-spacer>

                    <v-btn :disabled="homeButtonDisabled" class="outerBtn" icon color="white" medium @click="quickOpenApp('settings')">
                        <v-icon class="tinyIcon">mdi-cog</v-icon>
                    </v-btn>
                    <v-spacer></v-spacer>
                </div>
            </div>
        </v-app>
    </div>
</template>

<script>
//import moment from 'moment';
import Nui from './utils/Nui';
import { defaultWallpapers } from './config'
import * as AppComponents from './appComponents';
import HomeScreen from './HomeScreen/Home';
import { Apps } from './appConfig';
import { Dialogs, SpinnyLoader } from './utilComponents';
import SnackBar from './components/SnackBar';
import Notification from './components/Notification';

export default {
    name: 'Phone',
    components: {
        HomeScreen,
        Dialogs,
        ...AppComponents,
        SnackBar,
        Notification,
        SpinnyLoader,
    },
    data: () => ({
        listener: null,
        keyListener: null,
        development: false,
        open: false,
        showing: 0,
        appOpen: false,
        appInitData: false,
        appFullyOpen: false,
        opacityOverlay: false,
        loadingOverlay: false,

        homeButtonDisabled: false,
    }),
    created() {
        this.listener = window.addEventListener('message', e => {
            const item = e.data || e.detail;
            const { event, data } = item;
            if (event) {
                this.$root.$emit(event, data)
                this.$store.commit('loggingAdd', {
                    direction: false,
                    event,
                    data,
                });
            }
        }, false);

        this.keyListener = window.addEventListener('keydown', (event) => {
            const key = event.key
            if (key === 'Escape') {
                this.startClose();
            } else if (key === 'Backspace') {
                if (this.appOpen) {
                    this.controlBack();
                } else {
                    this.startClose();
                }
            }
        });

        if (Nui.inDev()) {
            this.development = true;

            Nui.addEmulatedResponse('startClose', { success: true });
            Nui.addEmulatedResponse('setPhoneSetting', { success: true });
            Nui.addEmulatedResponse('contactEdit', { success: true });
            Nui.addEmulatedResponse('BankAccountdit', { success: true });
            Nui.addEmulatedResponse('contactAdd', { success: true });
            Nui.addEmulatedResponse('contactDelete', { success: true });
            Nui.addEmulatedResponse('sendTweet', { success: true, data: { content: 'Cunt', tweeter: 's', time: 1} });
            Nui.addEmulatedResponse('getAdverts', { success: true, data: [
                    { advert: 'This is an ad', number: '444-444-4444', name: 'Nick Riviera', time: 20000 },
                    { advert: 'No plz go away', number: '333-444-4444', name: 'Cunt Riviera', time: 2 },
                    { advert: 'Goodbye', number: '333-444-4444', name: 'Cunt Riviera', time: 8 },
                    { advert: 'hello', number: '333-444-4444', name: 'Cunt Riviera', time: 1 },
                ]
            });
            Nui.addEmulatedResponse('postAdvert', { success: true });

            this.openPhone();
        }
        Nui.setCb((dir, eventName, data, response) => {
            this.$store.commit('loggingAdd', {
                direction: dir,
                event: eventName,
                data,
                response
            });
        });

        //this.$store.dispatch('startPhoneCall', { number: '333-666-7777', outgoing: false })
        //setInterval(() => {
        //    this.$store.dispatch('notification', { text: 'text', title: 'title' });
        //}, 1000);
    },
    beforeDestroy() {
        window.removeEventListener(this.listener);
        window.removeEventListener(this.keyListener);
    },
    mounted() {
        this.$root.$on('phoneState:mutations', ({ type, payload }) => {
            this.$store.commit(type, payload);
        });

        this.$root.$on('phoneState:actions', ({ type, payload }) => {
            this.$store.dispatch(type, payload); 
        });

        this.$root.$on('open', () => {
            this.openPhone();
        });

        this.$root.$on('close', () => {
            this.close();
        });

        this.$root.$on('openApp', ({ app, data }) => {
            this.openPhoneApp(app, data);
        });

        this.$root.$on('forceCloseApps', () => {
            this.closePhoneApp();
        });

        console.log(`ARP Phone Loaded`);

        this.$root.$on('notification:show', ({ appName, icon, title, text, timeout }) => {
            this.showNotification(appName, icon, title, text, timeout);
        });

        this.$root.$on('notification:hide', () => {
            this.dismissNotification();
        });

        this.$root.$on('toggleLoading', (state) => {
            this.loadingOverlay = state;
        });

        this.$root.$on('phone:toggleHomeButton', (state) => {
            this.homeButtonDisabled = state;
        });

        //setInterval(() => {
        //    this.$store.commit('testAddMessage');
        //}, 5000)
    },
    methods: {
        print(e) {
            console.log(e);
        },
        openPhone() {
            this.open = true;
            this.showing = 2;
        },
        startClose() {
            Nui.send('startClose');
        },
        close() {
            if (this.open) {
                this.showing = 0;
                this.open = false;
            }
        },
        overlayOpacity(toggle) {
            this.opacityOverlay = toggle;
        },
        quickOpenApp(app) {
            if (!this.homeButtonDisabled) {
                this.$root.$emit('openApp', { app });
            }
        },
        controlBack() {
            this.$root.$emit('goBack');
        },
        openPhoneApp(app, data) {
            if (this.appOpen) this.closePhoneApp();
            this.appOpen = app;
            this.appInitData = data;
        },
        closePhoneApp() {
            this.appFullyOpen = false;
            this.appOpen = false;
            this.appInitData = {};
            this.$root.$emit('appJustClosed');
        },
        appOpened() {
            console.log('done')
            this.appFullyOpen = true;
        },
        dismissNotification(id) {
            this.$store.dispatch('notificationDismiss', id);
        },
        homeButton() {
            if (!this.homeButtonDisabled) {
                this.closePhoneApp();
            }
        }
    },
    computed: {
        phoneClasses() {
            if (this.showing === 0) {
                return 'hiddenState';
            } else if (this.showing === 1) { // notify state
                return 'notifyState'
            } else return '';
        },
        phoneInnerStyle() {
            let state = {}
            const wp = this.$store.getters.getWallpaper;
            if (wp.type === 0) {
                state['background-image'] = `url('${defaultWallpapers[wp.wallpaper].asset}')`
            } else if (wp.type === 1) {
                state['background-image'] = `url('${wp.wallpaper}')`
            }

            return state;
        },
        appContainerStyle() {
            let state = {};
            if (this.appOpen) {
                const appData = Apps[this.appOpen];
                if (appData) {
                    if (appData.background.length > 0) {
                        if (appData.background.startsWith('#')) {
                            state.background = appData.background;
                        } else {
                            state['background-image'] = `url(${appData.background})`;
                        }
                    }
                }
            }

            return state;
        },
        currentAppComponent() {
            if (this.appOpen) {
                const appData = Apps[this.appOpen];
                if (appData && appData.component) {
                    return appData.component;
                }
            }
            return false;
        },
        getTopNotifications() {
            const top = this.$store.getters.getNotifications.slice(0, 3); 
            return top.filter(n => n.onTop);
        },
        getGameTime() {
            return this.$store.state.gameTime;
        },
        getPhoneCall() {
            return this.$store.state.phoneCall;
        }
    },
    watch: {
        getTopNotifications(val) {
            console.log('notificaations chagne');
            if (val && !this.open) {
                if (val.length > 0) {
                    this.showing = 1;
                } else { // There are no more notifications, you can close the phone again
                    this.showing = 0;
                }
            }
        },
    }
}
</script>

<style lang="less">
@import '@/arp-theme.less';
@import url('https://fonts.googleapis.com/css2?family=Montserrat:wght@300&display=swap');
@import url('https://fonts.googleapis.com/css2?family=Roboto:wght@100&display=swap');

/* 
    Default Phone Sizing Values (for 1080p)

    outer-width: 375
    outer-height: 810
    inner-padding-width: 21
    inner-padding-height: 30

*/

:root {
    --resize-percentage: 1.0;
    --outer-width: 375px;
    --outer-height: 810px;
    --inner-padding-width: 21px;
    --inner-padding-height: 34px;

    @media only screen and (max-width: 3840px) and (min-height: 1500px) {
        --resize-percentage: 1.6;
        --outer-width: calc(375px * var(--resize-percentage));
        --outer-height: calc(810px * var(--resize-percentage));
        --inner-padding-width: calc(21px * var(--resize-percentage));
        --inner-padding-height: calc(34px * var(--resize-percentage));
    }

    @media only screen and (max-width: 2160px), (max-height: 1440px) and (min-height: 1100px) { // 1440p and 1440p ultrawide
        --resize-percentage: 1.2;
        --outer-width: calc(375px * var(--resize-percentage));
        --outer-height: calc(810px * var(--resize-percentage));
        --inner-padding-width: calc(21px * var(--resize-percentage));
        --inner-padding-height: calc(34px * var(--resize-percentage));
    }

    @media only screen and (max-width: 1900px), (max-height: 1080px) { // 1080p and 1080p ultrawide
        --resize-percentage: 1.0;
        --outer-width: calc(375px * var(--resize-percentage));
        --outer-height: calc(810px * var(--resize-percentage));
        --inner-padding-width: calc(21px * var(--resize-percentage));
        --inner-padding-height: calc(34px * var(--resize-percentage));
    }

    /// #if !DEBUG

    @media only screen and (max-width: 1600px) {
        --resize-percentage: 0.85;
        --outer-width: calc(375px * var(--resize-percentage));
        --outer-height: calc(810px * var(--resize-percentage));
        --inner-padding-width: calc(21px * var(--resize-percentage));
        --inner-padding-height: calc(34px * var(--resize-percentage));
    }

    /// #endif

}

body, html, #app {
    width: 100vw;
    height: 100vh;
    overflow: hidden;
    padding: 0;
    margin: 0;
    -webkit-font-smoothing: antialiased;
    -moz-osx-font-smoothing: grayscale;
    font-family: 'Roboto', sans-serif;
    //background: red;
}

* {
    &:focus {
        outline: none;
    }
}

.phoneOuter {
    position: fixed;
    -webkit-font-smoothing: antialiased;
    -moz-osx-font-smoothing: grayscale;
    background-image: url('/assets/phone.png');
    background-size: contain;
    transition: .8s;
    pointer-events: none;

    right: 10px;
    bottom: 20px;
    width: var(--outer-width);
    height: var(--outer-height);

    &.hiddenState {
        transform: translateY(calc(var(--outer-height) + 20px));
    }

    &.notifyState {
        transform: translateY(calc((var(--outer-height) * 0.8) + 20px));
    }
}

.phoneInner {
    position: fixed;
    background-color: @darker;
    background-size: cover;
    margin: 0;
    z-index: 0;
    transition: .8s;
    display: flex;
    flex-direction: column;

    right: calc(11.5px + (var(--inner-padding-width) / 2));
    bottom: calc(24px + (var(--inner-padding-height) / 2));
    width: calc(var(--outer-width) - var(--inner-padding-width));
    height: calc(var(--outer-height) - var(--inner-padding-height));

    &.hiddenState {
        transform: translateY(calc(var(--outer-height) + 20px));
    }

    &.notifyState {
        transform: translateY(calc((var(--outer-height) * 0.8) + 20px));
    }


    .phoneContainer {
        .statusBar {
            padding: 5.5% 2.5% 4% 3%;
            user-select: none;
            transition: .5s;

            font-size: calc(16px * var(--resize-percentage));
            .statusIcon {
                font-size: calc(17px * var(--resize-percentage));
                &.smaller {
                    font-size: calc(12px * var(--resize-percentage));
                }
            }
        }
        width: 100%;
        height: 95%;
        padding: 0;
        overflow-y: hidden;

        .notificationContainer {
            position: absolute;
            display: flex;
            flex-direction: column;
            z-index: 7;
        }

        .dialogOverlay {
            position: absolute;
            height: 95%;
            width: 100%;
            top: 0;
            background: black;
            z-index: 7;
            opacity: 50%;
        }

        .appContainer {
            position: absolute;
            width: 100%;
            height: 90.8%;
            top: 4.2%;
            background: transparent;
            background-size: cover;
            transform-origin: bottom;
        }
    }
    .controls {
        width: 100%;
        height: 5%;
        display: flex;
        flex-direction: row;
        justify-content: center;
        padding: 1% 0 0 0;
        transition: 0.5s;
        &.inApp {
            background-color: #000000;
        }

        .outerBtn {
            height: 100%;
        }

        .tinyIcon {
            font-size: calc(14px * var(--resize-percentage));
        }

        .regIcon  {
            font-size: calc(26px * var(--resize-percentage));
        }
    }
}

.simpleAppHeader {
    display: flex;
    flex-direction: row;
    .text { 
        font-size: calc(0.9rem * var(--resize-percentage)) !important;
        height: 100%;
    }
    .headerButton {
        height: 100%;
        padding-left: 2.5%;
        padding-right: 2.5%;
        .innerButton {
            margin-top: 25%;
        }
    }
}

.app-transition-enter-active {
    animation: app-transition .3s;
}
.app-transition-leave-active {
    animation: app-transition .3s reverse;
}

@keyframes app-transition {
    0% {
        transform: scale(0);
    }
    100% {
        transform: scale(1);
    }
}

.notification-enter-active {
    //transform-origin: top;
    animation: notification-transition .25s;
}
.notification-leave-active {
    //transform-origin: top;
    animation: notification-transition .25s reverse;
}

@keyframes notification-transition {
    0% {
        transform: scale(0);
    }
    100% {
        transform: scale(1);
    }
}

.smenu-transition-enter-active {
    animation: sm-transition .2s;
}
.smenu-transition-leave-active {
    animation: sm-transition .2s reverse;
}

@keyframes sm-transition {
    0% {
        transform: translateX(100%);
    }
    100% {
        //transform: scale(1);
    }
}


.tooltip {
    display: block !important;
    z-index: 10000;
    max-width: 100%;

    .popover .popover-inner {
        background: #f9f9f9;
        color: black;
        padding: 24px;
        border-radius: 5px;
        box-shadow: 0 5px 30px rgba(black, .1);
    }
    
    .popover .popover-arrow {
        border-color: #f9f9f9;
    }

    .tooltip-inner {
        background: rgba(100, 100, 100, 1);
        color: white;
        font-size: calc(.8rem * var(--resize-percentage));
        word-break: break-all;
        border-radius: 8px;
        padding: 5px 10px 4px;
    }

    &[x-placement^="top"] {
        margin-bottom: 5px;
    }
      
      
    &[x-placement^="bottom"] {
        margin-top: 5px;
    }
      
    &[x-placement^="right"] {
        margin-left: 5px;
    }
    
    &[x-placement^="left"] {
        margin-right: 5px;
    }

    &[aria-hidden='true'] {
        visibility: hidden;
        opacity: 0;
        transition: opacity .25s, visibility .25s;
    }
    
    &[aria-hidden='false'] {
        visibility: visible;
        opacity: 1;
        transition: opacity .25s;
    }
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
