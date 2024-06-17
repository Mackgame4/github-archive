<template>
    <div id="app" :style="useStyles">
        <v-app>
            <div class="phoneCase" v-bind:style="{ 'background-image': 'url(' + getPhoneData.case + ')'}"></div>
            <div class="phoneScreen" v-bind:style="{ 'background-image': 'url(' + getPhoneData.wallpaper + ')'}">
                <div class="infoBar" v-on:click="retrieveNotification()">
                    <span class="clock">{{currentDateTime()}}</span>
                    <span class="infoBarStatus"><v-icon style="font-size: 13px;">mdi-wifi</v-icon><v-icon style="font-size: 13px;" v-on:click="debug()">mdi-signal-5g</v-icon><v-icon style="font-size: 13px;">mdi-signal-cellular-3</v-icon><v-icon style="font-size: 13px;">mdi-battery</v-icon></span>
                    <div id="notificationHandler" style="display: none;">
                        <!-- Test notification, the others should be nodes of this one (probably dynamic ids?)-->
                        <!-- TODO: Show notification on receive, the only show all if clicked on infoBar -->
                        <div class="notification elevation-2"><p class="notificationTitle"><v-icon color="info" style="font-size: 17px; bottom: 3px;">mdi-twitter</v-icon> Test Notification</p><p class="notificationDesc">This is a test notification!</p><p class="notificationSender">{{thisMessageSender}} - {{currentTime()}}</p></div>
                        <div class="notification elevation-2"><p class="notificationTitle"><v-icon color="success" style="font-size: 17px; bottom: 3px;">mdi-phone</v-icon> Call Notification</p><p class="notificationDesc">{{thisMessageSender}} is calling you!</p><div class="notificationActions"><v-btn icon color="success"><v-icon>mdi-phone-incoming</v-icon></v-btn><v-btn icon color="error"><v-icon>mdi-phone-off</v-icon></v-btn></div><p class="notificationSender">{{currentDateTime()}}</p></div>
                    </div>
                </div>
                <div id="desk" class="desk">
                    <draggable class="deskApps" v-model="deskApps1" group="people" @start="drag=true" @end="drag=false">
                        <div class="deskApp elevation-1" v-bind:style="{ background: app.bgColor}" v-for="app in deskApps1" :key="app.name" v-on:click="openApp(app.clickEvent)"><v-icon style="font-size: 35px; padding: 10px;">{{app.icon}}</v-icon><span>{{app.name}}</span></div>
                    </draggable>
                    <br>
                    <draggable class="deskApps" v-model="deskApps2" group="people" @start="drag=true" @end="drag=false">
                        <div class="deskApp elevation-1" v-bind:style="{ background: app.bgColor}" v-for="app in deskApps2" :key="app.name" v-on:click="openApp(app.clickEvent)"><v-icon style="font-size: 35px; padding: 10px;">{{app.icon}}</v-icon><span>{{app.name}}</span></div>
                    </draggable>
                    <draggable class="deskApps" v-model="deskApps3" group="people" @start="drag=true" @end="drag=false">
                        <div class="deskApp elevation-1" v-bind:style="{ background: app.bgColor}" v-for="app in deskApps3" :key="app.name" v-on:click="openApp(app.clickEvent)"><v-icon style="font-size: 35px; padding: 10px;">{{app.icon}}</v-icon><span>{{app.name}}</span></div>
                    </draggable>
                    <draggable class="deskApps" v-model="deskApps4" group="people" @start="drag=true" @end="drag=false">
                        <div class="deskApp elevation-1" v-bind:style="{ background: app.bgColor}" v-for="app in deskApps4" :key="app.name" v-on:click="openApp(app.clickEvent)"><v-icon style="font-size: 35px; padding: 10px;">{{app.icon}}</v-icon><span>{{app.name}}</span></div>
                    </draggable>
                </div>
                <draggable id="dock" class="dock elevation-2" v-model="dockApps" group="people" @start="drag=true" @end="drag=false">
                    <div class="dockApp elevation-1" v-bind:style="{ background: app.bgColor}" v-for="app in dockApps" :key="app.name" v-on:click="openApp(app.clickEvent)"><v-icon style="font-size: 35px; padding: 10px;">{{app.icon}}</v-icon></div>
                </draggable>
                <div class="homeBtn" v-on:click="homeBtn()"></div>
            </div>
            <div id="appHandler" style="display: none;">
                <v-scale-transition>
                    <CallApp v-if="clickHandler == 'openCalls'"/>
                    <TwitterApp v-if="clickHandler == 'openTwitter'"/>
                    <BankApp v-if="clickHandler == 'openBank'"/>
                    <InfoApp v-if="clickHandler == 'openInfo'"/>
                    <SettingsApp v-if="clickHandler == 'openSettings'"/>
                </v-scale-transition>
            </div>
        </v-app>
    </div>
</template>

<script>
import Nui from './utils/Nui';
import draggable from 'vuedraggable';
import moment from 'moment';

// Routes
import CallApp from './components/Call/CallApp';
import TwitterApp from './components/Twitter/TwitterApp';
import BankApp from './components/Bank/BankApp';
import InfoApp from './components/Info/InfoApp';
import SettingsApp from './components/Settings/SettingsApp';

export default {
    name: 'App',
    components: {
        draggable,
        BankApp,
        CallApp,
        TwitterApp,
        InfoApp,
        SettingsApp
    },
    data: () => ({
        development: false,
        clickHandler: null,
        thisMessageSender: " Mack",
        showingMode: 0,
        deskApps1: [
            { name: 'Twitter', icon: 'mdi-twitter', bgColor: 'linear-gradient(#076CE2, #298FE1)', clickEvent: "openTwitter"},
            { name: 'Safari', icon: 'mdi-apple-safari', bgColor: 'linear-gradient(#08C2EA, #0F58E0)'},
            { name: 'Appstore', icon: 'mdi-shopping', bgColor: 'linear-gradient(#2a00ff, #12006e)'},
            { name: 'Calendar', icon: 'mdi-calendar', bgColor: 'linear-gradient(#FF7BAC, #662D91)'}
        ],
        deskApps2: [
            { name: 'Bank', icon: 'mdi-credit-card', bgColor: 'linear-gradient(#1C1C1C, #353535)', clickEvent: "openBank"},
            { name: 'Info', icon: 'mdi-information-variant', bgColor: 'linear-gradient(#2659CC, #2A1BBE)', clickEvent: "openInfo"},
            { name: 'Tasks', icon: 'mdi-book', bgColor: 'linear-gradient(#7E41DD, #6116B7)'},
            { name: 'Voice', icon: 'mdi-microphone', bgColor: 'linear-gradient(#23C2E0, #16979C)'}
        ],
        deskApps3: [
            { name: 'Spotify', icon: 'mdi-spotify', bgColor: 'linear-gradient(#1ED760, #138C3F)'},
            { name: 'Youtube', icon: 'mdi-youtube', bgColor: 'linear-gradient(#FE0000, #CD0000)'},
            { name: 'Instagram', icon: 'mdi-instagram', bgColor: 'linear-gradient(#FECC6B, #EB4D50, #DE2F6F, #9539BF)'},
            { name: 'Netflix', icon: 'mdi-netflix', bgColor: 'linear-gradient(#E50915, #B1060F)'}
        ],
        deskApps4: [
            { name: 'Radio', icon: 'mdi-radio-tower', bgColor: 'linear-gradient(#FF6332, #FE0E65)'},
            { name: 'Clock', icon: 'mdi-alarm', bgColor: 'linear-gradient(#63D7A5, #25895A)'},
            { name: 'Home', icon: 'mdi-home-variant', bgColor: 'linear-gradient(#211F1F, #0A0909)'},
            { name: 'Camera', icon: 'mdi-camera', bgColor: 'linear-gradient(#a1a1a1, #797a7d)'}
        ],
        dockApps: [
            { name: 'Phone', icon: 'mdi-phone', bgColor: 'linear-gradient(#1DCC19, #129718)', clickEvent: "openCalls"},
            { name: 'Contacts', icon: 'mdi-account', bgColor: 'linear-gradient(#DE5415, #E94404)'},
            { name: 'Messages', icon: 'mdi-message', bgColor: 'linear-gradient(#17934D, #136115)'},
            { name: 'Settings', icon: 'mdi-cog', bgColor: 'linear-gradient(#1C1C1C, #353535)', clickEvent: "openSettings"}
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
        }, false);

        if (Nui.inDev()) {
            this.development = true;
        }

        console.log(`UI Loaded [${Nui.inDev() ? 'Development Mode' : 'Built'}]`);
    },
    computed: {
        useStyles() {
            return {
                '--showMode': this.showingMode
            }
        },
        getPhoneData() {
            const phone = this.$store.state.phoneData;
            if (phone) {
                return phone
            }
            return '';
        }
    },
    methods: {
        currentDateTime() {
            return moment().format('LT');
        },
        currentTime() {
            return moment("20120620", "YYYYMMDD").fromNow(); // TODO: pick message/notification date and calc time from now
        },
        debug() {
            // Opens a console on the "appHandler" popout 
            console.log(`Debug mode enabled`);
        },
        homeBtn() {
            document.getElementById("appHandler").style.display = "none";
            document.getElementById("desk").style.display = "flex";
            document.getElementById("dock").style.display = "flex";
            this.clickHandler = undefined;
        },
        openApp(clickEvent) {
            // Enables the "appHandler" popout and then insert app data
            if (document.getElementById("appHandler").style.display == "none") {
                document.getElementById("appHandler").style.display = "flex";
                document.getElementById("desk").style.display = "none";
                document.getElementById("dock").style.display = "none";
            } else if (document.getElementById("appHandler").style.display == "flex") {
                document.getElementById("appHandler").style.display = "none";
                document.getElementById("desk").style.display = "flex";
                document.getElementById("dock").style.display = "flex";
            }
            if (clickEvent != undefined) { this.clickHandler = clickEvent }
        },
        retrieveNotification(data) {
            // Enables the "notificationHandler" popout and then insert notification data
            if (document.getElementById("notificationHandler").style.display == "none") {
                document.getElementById("notificationHandler").style.display = "block";
            } else if (document.getElementById("notificationHandler").style.display == "block") {
                document.getElementById("notificationHandler").style.display = "none";
            }
            if (data != undefined) { console.log(data) }
        }
    }
}
</script>

<style lang="less">
@import '@/theme.less';

@font-face {
    font-family: "San Francisco";
    src: local("San Francisco"), url('../public/assets/SF-UI-Display-Regular.otf') format("truetype");
}

body, html, #app {
    width: 100vw;
    height: 100vh;
    overflow: hidden;
    padding: 0;
    margin: 0;
    -webkit-font-smoothing: antialiased;
    -moz-osx-font-smoothing: grayscale;
}

::-webkit-scrollbar {
    display: none;
    width: 7px;
}

::-webkit-scrollbar-track {
    background: none; 
}

::-webkit-scrollbar-thumb {
    background: #555;
    border-radius: 7px; 
}

::-webkit-scrollbar-thumb:hover {
    background: rgb(54, 54, 54); 
}

.notify {
    position: absolute;
    left: 10px;
    top: 490px;
    max-width: 285px;
}

.phoneCase {
    position: absolute;
    right: 20px;
    bottom: calc(470px * var(--showMode));
    width: 350px;
    height: 600px;
    background-position: 0px 0px;
    background-repeat: no-repeat;
    background-size: cover;
    max-width: none;
    transition: 0.5s;
}

.phoneScreen {
    position: absolute;
    right: 41px;
    bottom: calc(470px * var(--showMode));
    width: 305px;
    height: 580px;
    background-position: center;
    background-repeat: no-repeat;
    background-size: cover;
    border-top-left-radius: 32px;
    border-top-right-radius: 32px;
    transition: 0.5s;
}

.infoBar {
    position: absolute;
    top: 0;
    left: 3px;
    width: 98%;
    height: 20px;
    background-color: rgba(0, 0, 0, 0.5);
    border-top-left-radius: 32px;
    border-top-right-radius: 32px;
    user-select: none;
    z-index: 4;
}

.dock {
    display: flex;
    position: absolute;
    left: 15px;
    bottom: 35px;
    width: 90.2%;
    height: 73px;
    background-color: rgba(175, 175, 175, 0.5);
    border-radius: 20px;
    backdrop-filter: blur(2px);
    user-select: none;
}

.homeBtn {
    position: absolute;
    right: 60px;
    bottom: 10px;
    width: 60%;
    height: 8px;
    background-color: rgba(255, 255, 255, 0.9);
    backdrop-filter: blur(2px);
    border-radius: 20px;
    z-index: 5;
}

.dockApp {
    width: 55px;
    height: 55px;
    margin-top: 9px;
    margin-left: 11px;
    border-radius: 12px;
    float: left;
}

.desk {
    display: flex;
    position: absolute;
    width: 305px;
    max-width: 305px;
    height: 580px;
    max-height: 580px;
    top: 33px;
    right: 10px;
    overflow-y: auto;
    user-select: none;
}

.deskApps {
    max-width: 42px;
    margin-left: 29px;
    float: left;
}

.deskApp {
    width: 55px;
    height: 55px;
    margin-bottom: 30px;
    border-radius: 12px;
    text-align: center;
    float: left;
}

.deskApp span {
    font-size: 13px;
}

.clock {
    position: absolute;
    left: 20px;
    bottom: 0px;
    font-size: 13px;
}

.infoBarStatus {
    position: absolute;
    right: 20px;
    bottom: -2px;
}

#appHandler {
    position: absolute;
    right: 41px;
    bottom: calc(24vw * var(--showMode));
    width: 305px;
    height: 580px;
    z-index: 3;
    transition: 0.5s;
}

#notificationHandler {
    width: 305px;
    height: 100px;
    max-height: 100px;
    color: black;
    border-top-left-radius: 32px;
    border-top-right-radius: 32px;
    overflow-y: auto;
    z-index: 4;
}

.notification {
    width: 290px;
    height: fit-content;
    margin-top: 25px;
    margin-left: 7px;
    background-color: rgba(175, 175, 175, 0.5);
    border-radius: 10px;
    backdrop-filter: blur(2px);
}

.notificationTitle {
    padding-top: 6px;
    padding-left: 7px;
    font-size: 14px;
    font-weight: 500;
}

.notificationDesc {
    margin-top: -18px;
    padding-left: 7px;
    font-size: 14px;
    font-weight: 400;
}

.notificationSender {
    margin-top: -14px;
    padding-left: 10px;
    padding-bottom: 3px;
    font-size: 12px;
    font-weight: 400;
}

.notificationActions {
    position: absolute;
    top: 26%;
    left: 68%;
    font-size: 14px;
    font-weight: 500;
}
</style>