<template>
    <div id="app">
        <v-app>
            <div v-if="development" class="debugMenu">
                <span>Debug Mode: {{ development }}</span>
                <v-select v-model="notification.position" :items="positions" label="Show notification"></v-select>
                <v-checkbox v-model="notification.toastMode.enabled" label="Show notification in toastMode"></v-checkbox>
                <v-text-field v-model="notification.timeout" label="Notification timeout"></v-text-field>
                <v-text-field v-model="notification.message" label="Notification text"></v-text-field>
                <v-btn @click="spawnNotification">Spawn Notification</v-btn><br><br>
                <v-divider></v-divider><br>
                <v-select v-model="snackbar.position" :items="positions" label="Show snackbar"></v-select>
                <v-btn @click="spawnSnackbar">Spawn Snackbar</v-btn>
            </div>
            <div v-for="(pos, i) in positions" :key="i" :class="'notificationContainer--'+pos">
                <div v-for="(notify, k) in notificationList" :key="k">
                    <v-scale-transition>
                        <v-alert class="elevation-7" v-if="!notify.toastMode.enabled && !notify.settings.unstyled && notify.type && notify.show && notify.position == pos" :type="notify.type" :light="notification.lightMode">{{ notify.message }}</v-alert>
                    </v-scale-transition>
                    <v-scale-transition>
                        <v-alert class="elevation-7" v-if="!notify.settings.border && !notify.toastMode.enabled && !notify.settings.unstyled && !notify.type && notify.show && notify.position == pos" :color="notify.settings.color" :icon="'mdi-'+notify.settings.icon" :shaped="notify.settings.shaped" :text="notify.settings.text" :outlined="notify.settings.outlined" :prominent="notify.settings.prominent" :dense="notify.settings.dense" :type="notify.settings.type" :colored-border="notify.settings.coloredborder" :dismissible="notify.settings.dismissible" close-icon="mdi-close" :light="notification.lightMode">{{ notify.message }}</v-alert>
                        <v-alert class="elevation-7" v-if="notify.settings.border && !notify.toastMode.enabled && !notify.settings.unstyled && !notify.type && notify.show && notify.position == pos" :color="notify.settings.color" :icon="'mdi-'+notify.settings.icon" :shaped="notify.settings.shaped" :text="notify.settings.text" :outlined="notify.settings.outlined" :prominent="notify.settings.prominent" :dense="notify.settings.dense" :type="notify.settings.type" :colored-border="notify.settings.coloredborder" :dismissible="notify.settings.dismissible" :border="notify.settings.border" close-icon="mdi-close" :light="notification.lightMode">{{ notify.message }}</v-alert>
                    </v-scale-transition>
                    <v-scale-transition>
                        <v-card v-if="!notify.toastMode.enabled && notify.settings.unstyled && notify.show && notify.position == pos" style="margin-bottom: 7px;" color="" :light="notification.lightMode">
                            <v-card-text>{{ notify.message }}</v-card-text>
                        </v-card>
                    </v-scale-transition>
                    <v-scale-transition>
                        <v-alert v-if="notify.toastMode.enabled && notify.show && notify.position == pos" class="elevation-7 toast" :color="notify.settings.color" :icon="'mdi-'+notify.settings.icon" :shaped="notify.settings.shaped" :text="notify.settings.text" :outlined="notify.settings.outlined" :prominent="notify.settings.prominent" :dense="notify.settings.dense" :type="notify.settings.type" :colored-border="notify.settings.coloredborder" :light="notification.lightMode">
                            <h3 v-if="notify.toastMode.title" class="text-h5">{{ notify.toastMode.title }}</h3>
                            <div v-if="notify.message">{{ notify.message }}</div>
                            <v-divider class="my-4"></v-divider>
                            <v-row align="center" no-gutters>
                                <div v-if="notify.toastMode.action" style="margin-right: 12px;" class="grow">{{ notify.toastMode.action }}</div>
                                <v-btn :color="notify.toastMode.button.color" :outlined="notify.toastMode.button.outlined" :text="notify.toastMode.button.text" small @click="notify.show = false">{{ notify.toastMode.button.message }}</v-btn> <!-- TODO: remove toast notifications if timeout are not set -->
                            </v-row>
                        </v-alert>
                    </v-scale-transition>
                </div>
            </div>
            <v-snackbar v-model="snackbar.show" :top="snackbar.top" :bottom="snackbar.bottom" :left="snackbar.left" :right="snackbar.right" :timeout="snackbar.timeout" :color="snackbar.settings.color" :rounded="snackbar.settings.rounded ? 'pill' : ''" :tile="snackbar.settings.tile" :outlined="snackbar.settings.outlined" :text="snackbar.settings.text" :shaped="snackbar.settings.shaped" :multi-line="snackbar.settings.multiLine" :vertical="snackbar.settings.vertical" :light="snackbar.lightMode">
                {{ snackbar.message }}
                <template v-slot:action="{ attrs }">
                    <v-btn color="error" text v-bind="attrs" @click="snackbar.show = false">Close</v-btn>
                </template>
            </v-snackbar>
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
        // Debug
        development: process.env.NODE_ENV === 'development',
        // Notification default settings
        notification: {
            id: 0, // Unique id for each notification for same timeout notifications
            lightMode: false, // Light mode for notifications
            position: 'top-right',
            message: 'This is a notification!',
            type: 'info',
            timeout: 5000,
            toastMode: {
                enabled: false,
                title: 'Title',
                action: 'This is a toast notification action!',
                button: {
                    color: 'error',
                    outlined: false,
                    text: false,
                    message: 'Close'
                }
            },
            settings: {
                unstyled: false,
                color: 'success',
                icon: 'check',
                dense: false,
                prominent: false,
                outlined: false,
                text: false,
                shaped: false,
                dismissible: false,
                border: ''
            }
        },
        // Snackbar default settings
        snackbar: {
            show: false,
            lightMode: false, // Light mode for snackbar
            position: 'bottom-center',
            message: 'This is a snackbar!',
            top: false,
            bottom: false,
            left: false,
            right: false,
            timeout: -1,
            settings: {
                color: '',
                rounded: false,
                tile: false,
                outlined: false,
                text: false,
                shaped: false,
                multiLine: false,
                vertical: false
            }
        },
        // App settings
        positions: ['top-center', 'top-left', 'top-right', 'bottom-center', 'bottom-left', 'bottom-right', 'center', 'center-left', 'center-right'],
        notificationList: []
    }),
    mounted() {
        if (!this.development) {
            this.listener = window.addEventListener('message', e => {
                const item = e.data || e.detail;
                const { event, data } = item;
                if (event) {
                    this.$root.$emit(event, data)
                    this.$root.$emit('addNuiEventLog', false, event, data);
                }

                if (item.debug != null) { this.development = item.debug }

                if (item.mode == 'notification') {
                    if (item.lightMode) { this.notification.lightMode = item.lightMode; }
                    if (item.position) { this.notification.position = item.position; }
                    if (item.message) { this.notification.message = item.message; }
                    if (item.type) { this.notification.type = item.type; } else { this.notification.type = ''; }
                    if (item.timeout) { this.notification.timeout = item.timeout; }
                    if (item.toastMode) {
                        this.notification.toastMode.enabled = true;
                        this.notification.toastMode.title = item.toastMode.title;
                        this.notification.toastMode.action = item.toastMode.action;
                        this.notification.toastMode.button = item.toastMode.button;
                    } else {
                        this.notification.toastMode.enabled = false;
                    }
                    if (item.settings) { this.notification.settings = item.settings; }
                    this.spawnNotification();
                } else if (item.mode == 'snackbar') {
                    if (item.lightMode) { this.snackbar.lightMode = item.lightMode; }
                    if (item.position) { this.snackbar.position = item.position; }
                    if (item.message) { this.snackbar.message = item.message; }
                    if (item.timeout == 0) {
                        this.snackbar.timeout = -1;
                    } else if (item.timeout) {
                        this.snackbar.timeout = item.timeout;
                    }
                    if (item.settings) { this.snackbar.settings = item.settings; }
                    this.spawnSnackbar();
                }
            }, false);

            if (Nui.inDev()) {
                this.development = true;
            }

            console.log(`UI Loaded [${Nui.inDev() ? 'Development Mode' : 'Built'}]`);
        }
    },
    methods: {
        spawnNotification() {
            this.notification.id = this.notification.id + 1;
            this.notificationList.push({
                id: this.notification.id,
                show: false,
                position: this.notification.position,
                message: this.notification.message,
                type: this.notification.type,
                timeout: this.notification.timeout,
                toastMode: {
                    enabled: this.notification.toastMode.enabled,
                    title: this.notification.toastMode.title,
                    desc: this.notification.toastMode.desc,
                    action: this.notification.toastMode.action,
                    button: {
                        color: this.notification.toastMode.button.color,
                        outlined: this.notification.toastMode.button.outlined,
                        text: this.notification.toastMode.button.text,
                        message: this.notification.toastMode.button.message
                    }
                },
                settings: {
                    unstyled: this.notification.settings.unstyled,
                    color: this.notification.settings.color,
                    icon: this.notification.settings.icon,
                    dense: this.notification.settings.dense,
                    prominent: this.notification.settings.prominent,
                    outlined: this.notification.settings.outlined,
                    text: this.notification.settings.text,
                    shaped: this.notification.settings.shaped,
                    dismissible: this.notification.settings.dismissible,
                    border: this.notification.settings.border
                }
            });
            setTimeout(() => {
                this.notificationList.forEach(item => {
                    if (item.id == this.notification.id) {
                        item.show = true;
                        this.removeNotification(item.id);
                    }
                });
            }, 1);
        },
        removeNotification(id) {
            if (this.notification.timeout != 0) {
                setTimeout(() => {
                    this.notificationList.forEach(item => {
                        if (item.id == id) {
                            item.show = false;
                            /*setTimeout(() => {
                                this.notificationList.splice(this.notificationList.indexOf(item), 1);
                            }, 2300);*/
                            // Clearn list when theres no showing notifications
                            setTimeout(() => {
                                if (this.notificationList.filter(item => item.show).length == 0) {
                                    this.notificationList = [];
                                }
                            }, 2500);
                        }
                    });
                }, this.notification.timeout);
            }
        },
        spawnSnackbar: function() {
            if (this.snackbar.position == 'top-center') {
                this.snackbar.top = true;
                this.snackbar.bottom = false;
                this.snackbar.left = false;
                this.snackbar.right = false;
            } else if (this.snackbar.position == 'top-left') {
                this.snackbar.top = true;
                this.snackbar.bottom = false;
                this.snackbar.left = true;
                this.snackbar.right = false;
            } else if (this.snackbar.position == 'top-right') {
                this.snackbar.top = true;
                this.snackbar.bottom = false;
                this.snackbar.left = false;
                this.snackbar.right = true;
            } else if (this.snackbar.position == 'bottom-center') {
                this.snackbar.bottom = true;
                this.snackbar.top = false;
                this.snackbar.left = false;
                this.snackbar.right = false;
            } else if (this.snackbar.position == 'bottom-left') {
                this.snackbar.bottom = true;
                this.snackbar.top = false;
                this.snackbar.left = true;
                this.snackbar.right = false;
            } else if (this.snackbar.position == 'bottom-right') {
                this.snackbar.bottom = true;
                this.snackbar.top = false;
                this.snackbar.left = false;
                this.snackbar.right = true;
            }
            this.snackbar.show = true;
        }
    }
}
</script>

<style lang="less">
@import '@/theme.less';

body, html, #app {
    width: 100vw;
    height: 100vh;
    overflow-y: hidden;
    padding: 0;
    margin: 0;
    -webkit-font-smoothing: antialiased;
    -moz-osx-font-smoothing: grayscale;
}

::-webkit-scrollbar {
    display: none;
}

.v-application {
    background: transparent !important;
}

.v-alert {
    width: fit-content !important; // Maybe?
}

.debugMenu {
    position: fixed;
    top: 0;
    left: 0;
    margin: 12px;
    padding: 5px;
    background-color: rgba(0, 0, 0, 0.7);
    border-radius: 4px;
    z-index: 9999;
}

.notificationContainer {
    position: absolute;
    top: 0;
    right: 0;
    margin: 12px;
    min-width: 400px;
    max-width: 600px;

    &--top-left {
        position: absolute;
        margin-top: 12px;
        margin-left: 12px;
    }

    &--top-right {
        position: absolute;
        margin-top: 12px;
        margin-right: 12px;
        top: 0;
        right: 0;
    }

    &--bottom-left {
        position: absolute;
        //margin-bottom: 12px;
        margin-left: 12px;
        bottom: 0;
        left: 0;
    }

    &--bottom-right {
        position: absolute;
        //margin-bottom: 12px;
        margin-right: 12px;
        bottom: 0;
        right: 0;
    }

    &--top-center {
        position: absolute;
        margin-top: 12px;
        top: 0;
        left: 50%;
        transform: translateX(-50%);
    }

    &--bottom-center {
        position: absolute;
        //margin-bottom: 12px;
        bottom: 0;
        left: 50%;
        transform: translateX(-50%);
    }

    &--center {
        display: flex;
        justify-content: center;
        align-items: center;
        text-align: center;
        min-height: 100vh;
    }

    &--center-left {
        position: absolute;
        margin-left: 12px;
        top: 50%;
        left: 0;
        transform: translateY(-50%);
    }

    &--center-right {
        position: absolute;
        margin-right: 12px;
        top: 50%;
        right: 0;
        transform: translateY(-50%);
    }
}

.toast {
    min-width: 300px;
}
</style>