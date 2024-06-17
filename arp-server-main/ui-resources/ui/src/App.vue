<template>
    <div id="app" v-bind:class="{ devBG: development }">
        <v-app>
            <notifications group="main" animation-type="velocity" :max="10" position="top right">
                <template slot="body" slot-scope="props">
                    <div class="arp-notif" v-bind:class="getNotifClass(props.item.type)">
                        <div class="custom-template-icon" v-if="props.item.data && props.item.data.icon">
                            <span class="mdi" :class="props.item.data.icon"></span>
                        </div>
                        <div class="custom-template-content">
                            <div class="custom-template-title" v-if="props.item.title">
                                {{props.item.title}}
                            </div>
                            <div class="custom-template-text" v-html="props.item.text">
                            </div>
                        </div>
                    </div>
                </template>
            </notifications>
            <notifications group="persistent" position="bottom center" animation-type="velocity">
                <template slot="body" slot-scope="props">
                    <div class="arp-notif" v-bind:class="getNotifClass(props.item.type)">
                        <div class="custom-template-icon" v-if="props.item.data && props.item.data.icon">
                            <span class="mdi" :class="props.item.data.icon"></span>
                        </div>
                        <div class="custom-template-content">
                            <div class="custom-template-title" v-if="props.item.title">
                                {{props.item.title}}
                            </div>
                            <v-progress-linear
                                v-if="persistentProgress"
                                v-model="progressPercentage"
                                color="grey darken-1"
                                height="20"
                                rounded
                            >
                                <strong>{{ Math.ceil(progressPercentage) }}%</strong>
                            </v-progress-linear>
                            <div class="custom-template-text" v-else v-html="props.item.text"></div>
                        </div>
                    </div>
                </template>
            </notifications>
            <Menu />
            <InteractMenu />
            <InteractHover />
            <InteractionDialog />
            <InteractionCharacter />
            <Targeting />
            <Bank />
        </v-app>
    </div>
</template>

<script>
import Nui from './utils/Nui';
// UI Components
import Menu from './components/Menu/Menu';
import InteractMenu from './components/Interactions/InteractMenu';
import InteractHover from './components/Interactions/Hover';
import InteractionDialog from './components/Interactions/Dialog';
import InteractionCharacter from './components/Interactions/CharacterCreate';
import Targeting from './components/Targeting';
import Bank from './components/Banking/Bank';

export default {
    name: 'App',
    components: {
        Menu,
        InteractMenu,
        Targeting,
        InteractHover,
        InteractionDialog,
        InteractionCharacter,
        Bank,
    },
    data: () => ({
        development: false,
        persistentNotif: false,
        persistentProgress: true,
        progressPercentage: 0,
        progressInterval: false,
        clickListener: false,
    }),
    mounted() {
        this.listener = window.addEventListener('message', e => {
            const item = e.data || e.detail;
            const { event, data } = item;
            if (event) {
                this.$root.$emit(event, data)
            }
        }, false);

        this.$root.$on('clipboardCopy', (string) => {
            if (string && typeof(string) === 'string') {
                this.$copyText(string);
            }
        })

        this.$root.$on('arpNotification', (data) => {
            if (!data.type) return;
            this.$notify({
                group: 'main',
                title: data.title,
                text: data.text || null,
                type: data.type,
                duration: data.time || 7000,
                data: {
                    icon: data.icon || false
                }
            });
        })

        this.$root.$on('updatePersistentNotif', (data) => {
            if (!data.type) return;
            if (this.persistentNotif) {
                this.$notify({ group: 'persistent', clean: true });
            }
            if (data.progress) {
                this.persistentProgress = true;
                this.progressPercentage = 0;
                const seconds = data.progress / 1000;
                const percentPerSecond = 5 / seconds;
                if (this.progressInterval) {
                    clearInterval(this.progressInterval);
                    this.progressInterval = false;
                }
                this.progressInterval = setInterval(() => {
                    this.progressPercentage += percentPerSecond;
                    if (this.progressPercentage >= 100.0) {
                        clearInterval(this.progressInterval);
                        this.progressInterval = false;
                    } 
                }, 50);
            } else {
                this.persistentProgress = false;
            }
            this.persistentNotif = true;
            this.$notify({
                group: 'persistent',
                title: data.title,
                text: data.text || null,
                type: data.type,
                duration: data.progress || -1,
                data: {
                    icon: data.icon || false
                }
            });
        })

        this.$root.$on('removePersistentNotif', () => {
            if (this.persistentNotif) {
                this.$notify({
                    group: 'persistent',
                    clean: true
                });
                this.persistentNotif = false;
            }
        });

        this.$root.$on('listenForClicks', (data) => {
            this.clickListener = data;
        });

        window.addEventListener('mousedown', (e) => {
            Nui.send('mouseClick', {
                button: e.button,
            })
        });

        window.addEventListener('keyup', (e) => {
           const key = e.key
           if (key === 'Escape') {
               Nui.send('escapeButton', {})
           }
        });

        if (Nui.inDev()) {
            this.development = true;
        }
    },
    methods: {
        getNotifClass(type) {
            return {
                'arp-notif-success': type === 'success',
                'arp-notif-error':  type === 'error',
                'arp-notif-info': type === 'info',
                'arp-notif-warn': type === 'warn'
            }
        },
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

.arp-notif {
    display: flex;
    flex-direction: row;
    //flex-wrap: wrap;
    text-align: left;
    font-size: 13px;
    margin: 5px;
    margin-bottom: 0;
    align-items: center;
    justify-content: center;
    color: @lighter;

    background-color: @dark;
    border: 2px solid @light;
    .custom-template-icon {
        width: 20%;
        //flex: 0 1 auto;
        text-align: center;
        color: @light;
        font-size: 36px;
        padding-right: 5%;
        //padding: 0 2.5%;
    }
    .custom-template-content {
        width: 70%;
        padding: 5% 0;
        //flex: 1 0 auto;
        overflow-wrap: break-word !important;
        .custom-template-title {
            letter-spacing: 1px;
            text-transform: uppercase;
            font-size: 10px;
            font-weight: 600;
        }
        //.custom-template-text {

            //word-break: break-all;
        //}
    }
}

.arp-notif-error {
    border: 2px solid @red2;
    .custom-template-icon {
        color: @red2;
    }
}

.arp-notif-success {
    border: 2px solid #4caf50;
    .custom-template-icon {
        color: #4caf50;
    }
}   

.arp-notif-info {
    border: 2px solid #5991c7;
    .custom-template-icon {
        color: #5991c7;
    }
}

.arp-notif-warn {
    border: 2px solid #deae26;
    .custom-template-icon {
        color: #deae26;
    }
}

.v-application {
    background: transparent !important;
}

.devBG {
    background: @dark;
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
