<template>
    <div id="app">
        <v-app>
            <div class="appBar elevation-4">
                <span class="appIcon"><v-icon style="font-size: 82px;" color="rgba(0, 0, 0, 0.45)">mdi-cog</v-icon></span>
                <v-subheader>Welcome back,</v-subheader>
                <p>{{characterName}}</p>
            </div>
            <div class="appContainer">
                <v-list flat nav dense style="background: none;">
                    <v-list-item-group v-model="selectedItem">
                        <v-list-item>
                            <v-list-item-icon>
                                <v-icon :color="getPhoneData.mainColor">mdi-phone</v-icon>
                            </v-list-item-icon>
                            <v-list-item-content>
                                <v-list-item-title>Phone</v-list-item-title>
                                <v-list-item-subtitle>Change phone volume</v-list-item-subtitle>
                                <v-slider prepend-icon="mdi-volume-high" value="50" max="100" min="0" :color="getPhoneData.mainColor"></v-slider>
                                <v-list-item-subtitle>Change phone color</v-list-item-subtitle>
                                <v-color-picker v-model="color" style="background: none;" hide-canvas hide-inputs hide-swatches></v-color-picker>
                            </v-list-item-content>
                        </v-list-item>
                        <v-list-item @click="accountModal = true">
                            <v-list-item-icon>
                                <v-icon :color="getPhoneData.mainColor">mdi-account</v-icon>
                            </v-list-item-icon>
                            <v-list-item-content>
                                <v-list-item-title>Your Account</v-list-item-title>
                                <v-list-item-subtitle>Change your account</v-list-item-subtitle>
                            </v-list-item-content>
                            <v-list-item-action>
                                <v-icon v-if="loggedIn" color="success">mdi-check</v-icon>
                                <v-icon v-if="!loggedIn" color="error">mdi-close</v-icon>
                            </v-list-item-action>
                        </v-list-item>
                        <v-list-item @click="phoneCoverModal = true">
                            <v-list-item-icon>
                                <v-icon :color="getPhoneData.mainColor">mdi-wallpaper</v-icon>
                            </v-list-item-icon>
                            <v-list-item-content>
                                <v-list-item-title>Phone Cover</v-list-item-title>
                                <v-list-item-subtitle>Change your phone cover/model</v-list-item-subtitle>
                            </v-list-item-content>
                        </v-list-item>
                        <v-list-item @click="backgroundModal = true">
                            <v-list-item-icon>
                                <v-icon :color="getPhoneData.mainColor">mdi-image</v-icon>
                            </v-list-item-icon>
                            <v-list-item-content>
                                <v-list-item-title>Background</v-list-item-title>
                                <v-list-item-subtitle>Change your phone background</v-list-item-subtitle>
                            </v-list-item-content>
                        </v-list-item>
                        <v-list-item @click="switch1 = !switch1">
                            <v-list-item-icon>
                                <v-icon :color="getPhoneData.mainColor">mdi-bell</v-icon>
                            </v-list-item-icon>
                            <v-list-item-content>
                                <v-list-item-title>Don't disturbe</v-list-item-title>
                                <v-list-item-subtitle>Disable phone disturbing sounds</v-list-item-subtitle>
                            </v-list-item-content>
                            <v-list-item-action>
                                <v-switch v-model="switch1" inset :color="getPhoneData.mainColor"></v-switch>
                            </v-list-item-action>
                        </v-list-item>
                        <v-list-item @click="reset()">
                            <v-list-item-icon>
                                <v-icon :color="getPhoneData.mainColor">mdi-restore</v-icon>
                            </v-list-item-icon>
                            <v-list-item-content>
                                <v-list-item-title>Reset</v-list-item-title>
                                <v-list-item-subtitle>Delete all phone data</v-list-item-subtitle>
                            </v-list-item-content>
                        </v-list-item>
                    </v-list-item-group>
                </v-list>
                <v-slide-y-transition>
                    <v-card class="popupCard" v-if="accountModal" dark>
                        <v-card-title>Change your account</v-card-title>
                        <v-card-subtitle>Your Account</v-card-subtitle>
                        <v-card-actions>
                            <v-col>
                                <div style="display: flex; justify-content: space-between;"><v-avatar size="45"><img src="https://cdn.vuetifyjs.com/images/john.jpg"></v-avatar>‏‏‎ ‎‏‏‎ ‎<v-text-field outlined dense label="Avatar" placeholder="https://i.imgur.com/" :color="getPhoneData.mainColor"></v-text-field></div>
                                <v-text-field filled dense label="Username" :color="getPhoneData.mainColor"></v-text-field>
                                <v-text-field filled dense label="Password" :color="getPhoneData.mainColor" :append-icon="show1 ? 'mdi-eye' : 'mdi-eye-off'" :rules="[rules.min]" :type="show1 ? 'text' : 'password'" hint="At least 8 characters" @click:append="show1 = !show1"></v-text-field>
                                <v-btn outlined block color="error" @click="accountModal = false">Cancel</v-btn><br>
                                <v-btn outlined block color="success">Confirm</v-btn>
                            </v-col>
                        </v-card-actions>
                        <v-icon class="backBtn">mdi-account</v-icon>
                        <!--v-btn class="backBtn" icon color="error" @click="accountModal = false"><v-icon>mdi-close</v-icon></v-btn-->
                    </v-card>
                    <v-card class="popupCard" v-if="phoneCoverModal" dark>
                        <v-card-title>Change phone cover</v-card-title>
                        <v-card-subtitle>Phone Cover</v-card-subtitle>
                        <v-card-actions>
                            <v-list flat nav dense style="width: 100%; background: none;">
                                <v-list-item-group>
                                    <v-list-item v-on:click="changeCase('https://i.imgur.com/qrjUi3W.png'), phoneCoverModal = false">
                                        <v-list-item-content>
                                            <v-list-item-title>iPhone X</v-list-item-title>
                                        </v-list-item-content>
                                    </v-list-item>
                                    <v-list-item v-on:click="changeCase('https://i.imgur.com/lwDH62V.png'), phoneCoverModal = false">
                                        <v-list-item-content>
                                            <v-list-item-title>Samsung S21</v-list-item-title>
                                        </v-list-item-content>
                                    </v-list-item>
                                    <v-list-item v-on:click="changeCase('https://i.imgur.com/ScBEOJx.png'), phoneCoverModal = false">
                                        <v-list-item-content>
                                            <v-list-item-title>Huawei P40 Pro</v-list-item-title>
                                        </v-list-item-content>
                                    </v-list-item>
                                    <v-list-item v-on:click="changeCase(''), phoneCoverModal = false">
                                        <v-list-item-content>
                                            <v-list-item-title>Clear</v-list-item-title>
                                        </v-list-item-content>
                                    </v-list-item>
                                </v-list-item-group>
                            </v-list>
                        </v-card-actions>
                        <v-icon class="backBtn">mdi-wallpaper</v-icon>
                    </v-card>
                    <v-card class="popupCard" v-if="backgroundModal" dark>
                        <v-card-title>Change background</v-card-title>
                        <v-card-subtitle>Background</v-card-subtitle>
                        <v-card-actions style="margin-top: -25px;">
                            <v-list flat nav dense style="width: 100%; background: none;">
                                <v-list-item-group>
                                    <v-list-item v-on:click="changeBg('https://i.pinimg.com/564x/92/7f/e6/927fe675092970cc89241207067daa23.jpg'), backgroundModal = false">
                                        <v-list-item-content>
                                            <v-list-item-title>Galaxy</v-list-item-title>
                                        </v-list-item-content>
                                    </v-list-item>
                                    <v-list-item v-on:click="changeBg('https://4.bp.blogspot.com/-AqlJ9uWhed0/Xc4FcpIE2nI/AAAAAAAAJdw/LmwOWLWbVg0q2l82ufISLDTdiGFdCK4-wCLcBGAsYHQ/d/A%2Bbeautiful%2Bphone%2Bwallpaper%2B4%2Bart%2Bby%2BMattia%2BLau.png'),backgroundModal = false">
                                        <v-list-item-content>
                                            <v-list-item-title>Prodigy RP</v-list-item-title>
                                        </v-list-item-content>
                                    </v-list-item>
                                    <v-subheader>Custom color</v-subheader>
                                    <v-color-picker v-model="bgColor" style="background: none;" hide-canvas hide-inputs hide-swatches></v-color-picker>
                                    <v-subheader>Custom image</v-subheader>
                                    <v-list-item>
                                        <v-list-item-content>
                                            <v-text-field v-model="customBg" outlined dense label="Custom" placeholder="https://i.imgur.com/" :color="getPhoneData.mainColor"></v-text-field>
                                            <v-btn outlined block dense color="success" @click="backgroundModal = false">Confirm</v-btn>
                                        </v-list-item-content>
                                    </v-list-item>
                                </v-list-item-group>
                            </v-list>
                        </v-card-actions>
                        <v-icon class="backBtn">mdi-image</v-icon>
                    </v-card>
                </v-slide-y-transition>
                <div v-if="accountModal || phoneCoverModal || backgroundModal" @click="accountModal = false, phoneCoverModal = false, backgroundModal = false" class="bgBlur"></div>
            </div>
        </v-app>
    </div>
</template>

<script>

export default {
    name: 'SettingsApp',
    components: {
    },
    data: () => ({
        userName: "Mack", // if logged in
        characterName: "Clean Boy", // if doesnt have account / isnt logged in
        loggedIn: true,
        selectedItem: null,
        accountModal: false,
        phoneCoverModal: false,
        backgroundModal: false,
        hex: '#FF00FF',
        bgHex: '#FF00FF',
        customBg: '',
        switch1: false,
        show1: false,
        rules: {
            //required: value => !!value || 'Required.',
            min: v => v.length >= 8 || 'Min 8 characters'
        },
    }),
    mounted() {
    },
    computed: {
        color: {
            get () {
                return this['hex']
            },
            set (v) {
                this['hex'] = v
            },
        },
        bgColor: {
            get () {
                return this['bgHex']
            },
            set (v) {
                this['bgHex'] = v
            },
        },
        getPhoneData() {
            const phone = this.$store.state.phoneData;
            if (phone) {
                return phone
            }
            return '';
        }
    },
    watch: {
        hex: function(newVal) {
            if (newVal) {
                this.$store.commit('hex', this.hex)
            }
        },
        bgHex: function(newVal) {
            if (newVal) {
                let webBgHex = this.bgHex;
                webBgHex = webBgHex.slice(1);
                this.$store.commit('bgHex', webBgHex)
            }
        },
        customBg: function(newVal) {
            if (newVal) {
                this.$store.commit('customBg', this.customBg)
            }
        }
    },
    methods: {
        reset() {
            this.changeBg('https://i.pinimg.com/564x/92/7f/e6/927fe675092970cc89241207067daa23.jpg');
            this.changeCase('https://i.imgur.com/qrjUi3W.png');
            this.$store.commit('reset');
        },
        changeBg(val) {
            this.$store.commit('changeBg', val)
        },
        changeCase(val) {
            this.$store.commit('changeCase', val)
        }
    }
}
</script>

<style lang="less" scoped>
@import '@/theme.less';

#app {
    border-top-left-radius: 32px;
    border-top-right-radius: 32px;
}

.appBar {
    padding-top: 35px;
    height: 120px;
    background: linear-gradient(to top right, #CCC, #3f3f3f, #5f5f5f);
}

.appBar p {
    position: absolute;
    top: 61px;
    left: 15px;
    font-size: 25px;
}

.appIcon {
    position: absolute;
    top: 28px;
    left: 196px;
    font-size: 27px;
    transform: rotate(7deg);
}

.appContainer {
    width: 305px;
    max-width: 305px;
    height: 432px;
    max-height: 432px;
    padding-left: 7px;
    padding-right: 7px;
    font-size: 17px;
    overflow-y: auto;
}

.popupCard {
    position: absolute;
    top: 108px;
    width: 290px;
    height: fit-content;
    max-height: 445px;
    z-index: 4;

    .backBtn {
        position: absolute;
        top: 8px;
        right: 8px;
    }
}

.bgBlur {
    position: absolute;
    top: 0;
    left: 0;
    width: 320px;
    height: 580px;
    background-color: rgba(0, 0, 0, 0.5);
    z-index: 1;
}
</style>