<template>
    <div class="app">
        <transition name="smenu-transition" :duration="{ enter: 200, leave: 150 }" mode="out-in">
        <v-list subheader flat class="list" v-if="!submenu" key="main">
            <v-subheader>General Settings</v-subheader>
            <!--v-list-item link @click="enterSub('wallpapers')">
                <v-list-item-icon>
                    <v-icon>mdi-microphone</v-icon>
                </v-list-item-icon>
                <v-list-item-content>
                    <v-list-item-title>Voice Settings</v-list-item-title>
                </v-list-item-content>
            </v-list-item!-->

            <v-divider></v-divider>

            <v-subheader>Appearance Settings</v-subheader>
            <v-list-item link @click="enterSub('wallpapers')">
                <v-list-item-icon>
                    <v-icon>mdi-wallpaper</v-icon>
                </v-list-item-icon>
                <v-list-item-content>
                    <v-list-item-title>Wallpapers</v-list-item-title>
                    <v-list-item-subtitle>Change your current wallpaper</v-list-item-subtitle>
                </v-list-item-content>
            </v-list-item>

            <v-divider></v-divider>

            <v-subheader>Sound and Notification Settings</v-subheader>

            <v-list-item link @click="enterSub('wallpapers')">
                <v-list-item-content>
                    <v-list-item-title>Ringtone</v-list-item-title>
                    <v-list-item-subtitle>Change your ringtone</v-list-item-subtitle>
                </v-list-item-content>
            </v-list-item>

            <v-list-item link @click="enterSub('wallpapers')">
                <v-list-item-content>
                    <v-list-item-title>Notification Sound</v-list-item-title>
                    <v-list-item-subtitle>Change your notification sound</v-list-item-subtitle>
                </v-list-item-content>
            </v-list-item>

            
            <v-list-item link @click="enterSub('wallpapers')">
                <v-list-item-content>
                    <v-list-item-title>App Notifications</v-list-item-title>
                    <v-list-item-subtitle>Toggle notifications for specific apps</v-list-item-subtitle>
                </v-list-item-content>
            </v-list-item>

            <v-list-item-group multiple>
                <v-list-item>
                    <v-list-item-action>
                        <v-switch v-model="active" color="red darken-4"></v-switch>
                    </v-list-item-action>

                    <v-list-item-content>
                        <v-list-item-title>Silent Mode</v-list-item-title>
                        <v-list-item-subtitle>Disable All Sounds</v-list-item-subtitle>
                    </v-list-item-content>
                </v-list-item>
            </v-list-item-group>

            <v-divider></v-divider>
            <v-list-item link @click="enterSub('about')">
                <v-list-item-content>
                    <v-list-item-title>About Phone</v-list-item-title>
                    <v-list-item-subtitle>View information about this device</v-list-item-subtitle>
                </v-list-item-content>
            </v-list-item>

        </v-list>
        <v-list subheader two-line flat class="list" v-if="submenu == 'wallpapers'" key="wallpapers">
            <v-subheader style="max-height: 10%;">Settings | Wallpapers</v-subheader>

            <v-list-item style="max-height: 10%;">
                <v-select v-model="wallpaperCurrent" :items="wallpaperSelect" label="Wallpaper" color="red darken-4" item-color="red darken-4" item-text="name" item-value="id"></v-select>
            </v-list-item>

            <v-list-item style="max-height: 10%;" v-if="wallpaperIsCustom">
                <v-text-field v-model="wallpaperURL" label="Custom Wallpaper URL" color="red darken-4" hint="Should start with 'https://' and end in *.png, *.jpg etc..."></v-text-field>
            </v-list-item>

            <v-list-item link style="max-height: 8%;" v-if="wallpaperIsCustom" :disabled="!wallpaperIsURLValid" @click="wallpaperSetCustom">
                <v-list-item-content>
                    <v-list-item-title>Save Custom Wallpaper</v-list-item-title>
                </v-list-item-content>
            </v-list-item>

            <div class="preview">
                <div class="img" :style="wallpaperPreviewStyle">

                </div>
            </div>
        </v-list>
        <v-list subheader two-line flat class="list" v-if="submenu == 'about'" key="about">
            <v-subheader>Settings | About</v-subheader>

            <v-list-item>
                <v-list-item-content>
                    <v-list-item-title>Phone Number</v-list-item-title>
                    <v-list-item-subtitle>555-555-555</v-list-item-subtitle>
                </v-list-item-content>
            </v-list-item>

            <v-list-item>
                <v-list-item-content>
                    <v-list-item-title>Network</v-list-item-title>
                    <v-list-item-subtitle>Fruit Mobile</v-list-item-subtitle>
                </v-list-item-content>
            </v-list-item>

            <v-list-item link> <!-- Please add a game to this it would be funny :) -->
                <v-list-item-content>
                    <v-list-item-title>Software Version</v-list-item-title>
                    <v-list-item-subtitle>Bandroid 8.1.1</v-list-item-subtitle>
                </v-list-item-content>
            </v-list-item>

            <v-list-item disabled>
                <v-list-item-content>
                    <v-list-item-title>Build Number</v-list-item-title>
                    <v-list-item-subtitle>Last phone update here</v-list-item-subtitle>
                </v-list-item-content>
            </v-list-item>
            
        </v-list>
        </transition>
    </div>
</template>

<script>
import { defaultWallpapers } from '../config';

export default {
    name: 'Settings',
    components: {

    },
    data: () => ({
        submenu: false,
        settings: [

        ],
        wallpaperCurrent: 'default',
        wallpaperURL: '',
        wallpaperSelect: [],
        created: false,
        active: false,
    }),
    props: {},
    methods: {
        goBack() {
            if (this.submenu) {
                this.submenu = false;
            }
        },
        enterSub(sub) {
            this.submenu = sub;
        },
        wallpaperSetCustom() {
            if (this.wallpaperIsURLValid) {
                this.$store.dispatch('setWallpaper', {
                    wallpaper: this.wallpaperURL,
                });
            }
        }
    },
    computed: {
        wallpaperPreviewStyle() {
            let state = {};
            const wp = this.$store.getters.getWallpaper;
            if (this.wallpaperIsURLValid) {
                state['background-image'] = `url('${this.wallpaperURL}')`;
            } else {
                if (wp.type === 0) {
                    state['background-image'] = `url('${defaultWallpapers[wp.wallpaper].asset}')`;
                } else if (wp.type === 1) {
                    state['background-image'] = `url('${this.wallpaperURL}')`;
                }
            }

            return state;
        },
        wallpaperIsCustom() {
            return this.$store.getters.getWallpaper.type === 1 || this.wallpaperCurrent == 'custom';
        },
        wallpaperIsURLValid() {
            if (this.wallpaperURL.length > 0 && this.wallpaperURL.startsWith('https://')) {
                return true;
            }
            return false;
        }
    },
    created() {
        this.wallpaperSelect = [
            { name: 'Custom Wallpaper', id: 'custom' },
        ];

        for (const wpIndex in defaultWallpapers) {
            this.wallpaperSelect.push({ name: defaultWallpapers[wpIndex].name, id: wpIndex });
        }

        const wp = this.$store.getters.getWallpaper;

        if (wp.type === 0) {
            this.wallpaperCurrent = wp.wallpaper;
        }

        setTimeout(() => this.created = true, 250);
    },
    mounted() {
        this.$root.$on('goBack', this.goBack);
    },
    beforeDestroy() {
        this.$root.$off('goBack', this.goBack);
    },
    watch: {
        wallpaperCurrent(val) {
            if (this.created) {
                if (val === 'custom') {
                    console.log('now custom')
                    this.wallpaperURL = 'https://imgur.com/2aq45F9l.jpg';
                } else {
                    this.wallpaperURL = '';
                    this.$store.dispatch('setWallpaper', {
                        wallpaper: val,
                    })
                }
            }
        }
    }
};

</script>

<style scoped lang="less">
@import '@/arp-theme.less';

.app {
    width: 100%;
    height: 100%;
    overflow-y: scroll;
    overflow-x: hidden;
    display: flex;
    flex-direction: column;
    background: #1e1e1e;
    &::-webkit-scrollbar {
        display: none;
    }
    .list {
        height: 100%;

        .preview {
            height: 62%;
            padding: 3% 20%;
            .img {
                transition: .5s;
                background-color: @midnight;
                background-size: cover;
                outline: 4px solid #000000;
                width: 100%;
                height: 100%;
            }
        }
    }
}

</style>
