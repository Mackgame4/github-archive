<template>
    <div id="app" v-if="showHud">
        <v-app v-bind:style="{ backgroundImage: 'url(' + bg + ')' }">
            <div class="circleHud" v-if="hudMode == 0">
                <div class="border"></div>
                <div class="status">
                    <v-progress-circular class="life statusBar" :value="lifeValue" color="red darken-4"><v-icon style="font-size: 16px;">mdi-heart</v-icon></v-progress-circular>
                    <v-progress-circular class="shield statusBar" :value="shieldValue" color="blue darken-4"><v-icon style="font-size: 16px;">mdi-shield</v-icon></v-progress-circular>
                    <v-progress-circular class="hunger statusBar" :value="hungerValue" color="orange darken-4"><v-icon style="font-size: 16px;">mdi-food-drumstick</v-icon></v-progress-circular>
                    <v-progress-circular class="thirst statusBar" :value="thirstValue" color="cyan darken-4"><v-icon style="font-size: 16px;">mdi-cup</v-icon></v-progress-circular>
                    <v-progress-circular class="dynamic statusBar" v-if="hasDynamicValue" :value="dynamicValue" color="red accent-4"><v-icon style="font-size: 16px;">mdi-car-turbocharger</v-icon></v-progress-circular> <!-- Dynamic status, it can be changed depending on what its being updated on the moment, or what the player is doing (ex: inside car with boost, shows the boost quantity) -->
                </div>
                <div class="voiceStatus">
                    <v-progress-circular class="statusBar" :rotate="-90" :value="voiceValue" :color="voiceColor" @click="debug()"><v-icon style="font-size: 23px;">{{ icon }}</v-icon><!--span>[Radio] {{ radioFreq }}MHz</span--></v-progress-circular>
                </div>
            </div>
            <div class="squareHud" v-if="hudMode == 1">
                <div class="status">
                    <v-progress-linear class="life statusBar" :value="lifeValue" color="red darken-4" height="27">
                        <v-icon style="position: absolute; left: 3px; font-size: 20px;">mdi-heart</v-icon>
                    </v-progress-linear>
                    <v-progress-linear class="shield statusBar" :value="shieldValue" color="blue darken-4" height="27">
                        <v-icon style="position: absolute; left: 3px; font-size: 20px;">mdi-shield</v-icon>
                    </v-progress-linear>
                    <v-progress-linear class="hunger statusBar" :value="hungerValue" color="orange darken-4" height="27">
                        <v-icon style="position: absolute; left: 3px; font-size: 20px; transform: rotate(90deg);">mdi-food-drumstick</v-icon>
                    </v-progress-linear>
                    <v-progress-linear class="thirst statusBar" :value="thirstValue" color="cyan darken-4" height="27">
                        <v-icon style="position: absolute; left: 3px; font-size: 20px; transform: rotate(90deg);">mdi-cup</v-icon>
                    </v-progress-linear>
                    <v-progress-linear class="dynamic statusBar" :value="dynamicValue" color="red accent-4" height="27">
                        <v-icon style="position: absolute; left: 3px; font-size: 20px; transform: rotate(90deg);">mdi-car-turbocharger</v-icon>
                    </v-progress-linear>
                </div>
                <!--v-alert class="voiceStatus" color="indigo darken-4" :icon="icon" dense @click="debug()">Voice mode changed</v-alert-->
            </div>
            <div class="minimalistHud" v-if="hudMode == 2">
                <div class="border"></div>
                <div class="status">
                    <v-progress-circular :rotate="-90" :size="50" :value="voiceValue" color="indigo darken-4" @click="debug()">
                        <v-progress-circular :rotate="-90" :size="42" :value="lifeValue" color="red darken-4">
                            <v-progress-circular :rotate="-90" :size="34" :value="shieldValue" color="blue darken-4">
                                <v-progress-circular :rotate="-90" :size="26" :value="hungerValue" color="orange darken-4">
                                    <v-progress-circular :rotate="-90" :size="18" :value="thirstValue" color="cyan darken-4">
                                        <v-progress-circular :rotate="-90" :size="10" :value="dynamicValue" color="red accent-4"></v-progress-circular>
                                    </v-progress-circular>
                                </v-progress-circular>
                            </v-progress-circular>
                        </v-progress-circular>
                    </v-progress-circular>
                </div>
            </div>
            <v-slide-x-transition>
                <div v-if="IsInVehicle">
                    <div id="speedometer" class="speedometer" :style="[this.IsInVehicle && this.hudMode == 1 ? {'left': '28.8vh', 'bottom': '3.5vh'} : {'left': '22.8vh', 'bottom': '4.5vh'}]">
                        <v-progress-circular class="statusBar" :rotate="-90" :size="47" :width="5" :value="rpmValue" :color="rpmColor"><span class="speed">{{ speedValue }}</span><span class="metric">{{ metric }}</span></v-progress-circular>
                        <v-progress-circular class="statusBar" style="top: 1vh; left: 5px;" :rotate="-90" :size="30" :width="4" :value="fuelValue" :color="fuelColor"><v-icon style="font-size: 14px;">mdi-gas-station</v-icon></v-progress-circular>
                        <v-icon v-if="engineShowWarning" style="top: 1vh; margin-left: 15px; font-size: 22px;" :color="engineColor">mdi-engine</v-icon>
                        <v-icon v-if="lightsShowWarning" style="top: 1vh; margin-left: 8px; font-size: 22px;" color="info">mdi-car-light-high</v-icon>
                        <v-icon v-if="seatbeltValue == false" style="top: 1vh; margin-left: 7px; font-size: 22px;" color="red darken-4">mdi-seatbelt</v-icon>
                    </div>
                </div>
            </v-slide-x-transition>
        </v-app>
    </div>
</template>

<script>
import Nui from './utils/Nui';

export default {
    name: 'ui-hud',
    components: {
    },
    data: () => ({
        development: false,
        showHud: true,
        hudMode: 0,
        bg: null,
        icon: "mdi-microphone",
        voiceMode: "normal",
        voiceColor : "indigo darken-4",
        IsInVehicle: true,
        voiceValue: 50,
        radioFreq: 0,
        lifeValue: 100,
        shieldValue: 100,
        hungerValue: 100,
        thirstValue: 100,
        hasDynamicValue: false,
        dynamicValue: 100,
        metric: "kmh",
        speedValue: 150,
        rpmValue: 100,
        rpmColor: "red darken-4",
        fuelValue: 100,
        fuelColor: "green darken-4",
        engineValue: 100,
        engineShowWarning: false,
        lightsShowWarning: false,
        engineColor: "white",
        seatbeltValue: false
    }),
    mounted() {
        this.listener = window.addEventListener('message', e => {
            const item = e.data || e.detail;
            const { event, data } = item;
            if (event) {
                this.$root.$emit(event, data)
                this.$root.$emit('addNuiEventLog', false, event, data);
            }

            //console.log(this.lightsShowWarning, item.headlights)
            if (item.pauseMenu == false) {
                this.showHud = true;
                this.hudMode = item.hudMode;
                this.lightsShowWarning = item.headlights;
                this.lifeValue = item.health;
                this.shieldValue = item.shield;
                this.hungerValue = item.hunger;
                this.thirstValue = item.thirst;
                this.seatbeltValue = item.seatbelt;
                this.metric = item.metric;
                this.speedValue = item.speedValue;
                this.hasDynamicValue = item.hasDynamicValue;
                this.dynamicValue = item.dynamicValue;
                this.IsInVehicle = item.InVehicle;
                if (item.voiceMode == "Normal") {
                    this.icon = "mdi-microphone"
                    this.voiceValue = 50
                } else if (item.voiceMode == "Shouting") {
                    this.icon = "mdi-microphone-plus"
                    this.voiceValue = 80
                } else if (item.voiceMode == "Whisper") {
                    this.icon = "mdi-microphone-minus"
                    this.voiceValue = 20
                } else if (item.voiceMode == "Megaphone") {
                    this.icon = "mdi-bullhorn"
                    this.voiceValue = 100
                } else if (item.voiceMode == "Radio") {
                    this.icon = "mdi-radio-handheld"
                    this.radioFreq = item.radioFreq;
                    this.voiceValue = 100
                }
                if (item.isTalking) {
                    this.voiceColor = "red darken-1"
                } else {
                    this.voiceColor = "indigo darken-4"
                }
            } else if (item.pauseMenu == true) {
                this.showHud = false;
            }
        }, false);

        if (Nui.inDev()) {
            this.development = true;
        }

        console.log(`UI Loaded [${Nui.inDev() ? 'Development Mode' : 'Built'}]`);
    },
    watch: {
        hudMode: function () {
            if (this.development && this.hudMode == 0) {
                this.bg = "https://i.imgur.com/EJ4gHbo.png"
            } else if (this.development && this.hudMode == 1) {
                this.bg = "https://i.imgur.com/3l715ri.png"
            } else if (this.development && this.hudMode == 2) {
                this.bg = "https://i.imgur.com/EJ4gHbo.png"
            }
        },
        speedValue: function () {
            this.rpmValue = (45 / 100) * this.speedValue;
            if (this.rpmValue == 0) {
                this.rpmColor = "white"
            } else if (this.rpmValue <= 30 && this.rpmValue <= 50) {
                this.rpmColor = "green darken-4"
            } else if (this.rpmValue <= 50 && this.rpmValue <= 80) {
                this.rpmColor = "yellow darken-4"
            } else if (this.rpmValue >= 80) {
                this.rpmColor = "red darken-4"
            }
        },
        fuelValue: function () {
            if (this.fuelValue == 0) {
                this.fuelColor = "white"
            } else if (this.fuelValue <= 30 && this.fuelValue <= 50) {
                this.fuelColor = "red darken-4"
            } else if (this.fuelValue <= 50 && this.fuelValue <= 80) {
                this.fuelColor = "yellow darken-4"
            } else if (this.fuelValue >= 80) {
                this.fuelColor = "green darken-4"
            }
        },
        engineValue: function () {
            if (this.engineValue == 0 || this.engineValue <= 30 && this.engineValue <= 50) {
                this.engineShowWarning = true
                this.engineColor = "red darken-4"
            } else if (this.engineValue <= 50 && this.engineValue <= 80) {
                this.engineShowWarning = true
                this.engineColor = "yellow darken-4"
            } else if (this.engineValue >= 80) {
                this.engineShowWarning = false
            }
        }
    },
    methods: {
        debug: function() {
            console.log(this.voiceMode, this.icon)
            if (this.voiceMode == "normal") {
                this.icon = "mdi-microphone"
                this.voiceMode = "shout"
                this.voiceValue = 50
            } else if (this.voiceMode == "shout") {
                this.icon = "mdi-microphone-plus"
                this.voiceMode = "whisper"
                this.voiceValue = 80
            } else if (this.voiceMode == "whisper") {
                this.icon = "mdi-microphone-minus"
                this.voiceMode = "megaphone"
                this.voiceValue = 20
            } else if (this.voiceMode == "megaphone") {
                this.icon = "mdi-bullhorn"
                this.voiceMode = "radio"
                this.voiceValue = 100
            } else if (this.voiceMode == "radio") {
                this.icon = "mdi-radio-handheld"
                this.voiceMode = "normal"
                this.voiceValue = 100
            }
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
    background: none;
    background-size: contain;
    -webkit-font-smoothing: antialiased;
    -moz-osx-font-smoothing: grayscale;
}

.circleHud {

    .border {
        width: 20.951vh;
        height: 20.951vh;
        border: 3px solid rgba(171, 171, 171, 0.9);
        border-radius: 50%;
        position: absolute;
        bottom: 2.5vh;
        left: 2.5vh;
        display: inline-block;
    }

    .status {
        position: absolute;
        bottom: -0.3vh;
        left: -0.2vh;

        .life {
            position: absolute;
            bottom: 20.8vh;
            left: 1.8vh;
        }

        .shield {
            position: absolute;
            bottom: 23.2vh;
            left: 5.7vh;
        }

        .hunger {
            position: absolute;
            bottom: 24.7vh;
            left: 10vh;
        }

        .thirst {
            position: absolute;
            bottom: 24.5vh;
            left: 14.5vh;
        }

        .dynamic {
            position: absolute;
            bottom: 22.7vh;
            left: 18.5vh;
        }
    }

    .statusBar {
        width: 3.5vh !important;
        height: 3.5vh !important;
        background-color: #121212;
        border-radius: 50%;
    }

    .voiceStatus {
        position: absolute;
        bottom: 0.8vh;
        left: 0.5vh;
        
        .statusBar {
            width: 5vh !important;
            height: 5vh !important;
            
            span {
                font-family: Avenir, Helvetica, Arial, sans-serif;
                font-size: 12px;
                font-weight: 700;
                color: #949697;
                text-shadow: 1.25px 0 0 #000, 0 -1.25px 0 #000,0 1.25px 0 #000, -1.25px 0 0 #000;
                position: absolute;
                bottom: 0.0vh;
                left: 6.5vh;
            }
        }
    }
}

.squareHud {

    .status {
        position: absolute;
        width: 25.2vh;
        height: 3.2vh;
        bottom: -0.4vh;
        left: 2.5vh;
        padding-left: 5px;
        padding-right: 5px;
        display: flex;

        .statusBar {
            border: 1px black solid;
        }

        .life {
            width: 8vh;
        }

        .shield {
            width: 8vh;
            margin-left: 0.3vh;
        }

        .hunger {
            width: 27px;
            margin-left: 0.3vh;
            transform: rotate(-90deg);
        }

        .thirst {
            width: 27px;
            margin-left: 0.3vh;
            transform: rotate(-90deg);
        }

        .dynamic {
            width: 27px;
            margin-left: 0.2vh;
            transform: rotate(-90deg);
        }
    }
    
    .voiceStatus {
        position: absolute;
        bottom: 0.8vh;
        left: 0.5vh;
    }
}

.minimalistHud {

    .border {
        width: 20.951vh;
        height: 20.951vh;
        border: 3px solid rgba(171, 171, 171, 0.9);
        border-radius: 50%;
        position: absolute;
        bottom: 2.5vh;
        left: 2.5vh;
        display: inline-block;
    }

    .status {
        position: absolute;
        bottom: 0.8vh;
        left: 0.5vh;
    }
}

.speed {
    position: absolute;
    top: 10px;
    font-weight: bold;
}

.metric {
    position: absolute;
    top: 26.5px;
    color: lightgray;
    font-size: 8px;
}

.speedometer {
    position: absolute;
    width: 100%;
    left: 22.8vh;
    bottom: 4.5vh;
    text-shadow: 1px 1px #121212;

    .statusBar {
        background-color: #121212;
        border-radius: 50%;
    }
}
</style>