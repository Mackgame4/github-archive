<template>
    <div id="app" v-bind:class="{ devBG: development }">
        <v-app>
            <div class="watermark">
                <img src="assets/largerlogo.png" />
            </div>
            <regular-hud :hide="hiddenMode" />
            <vehicle-hud :hide="hiddenMode" />
            <location-hud :hide="hiddenMode" />
            <cinematic :enabled="cinematicMode"/>
            <settings :open="menuOpen" :cinematic="cinematicMode" :hideHUD="hiddenMode" />
            <anatomy :hide="hiddenMode" />
        </v-app>
    </div>
</template>

<script>
import Nui from './utils/Nui';
// UI Components
import VehicleHud from './components/VehicleHud';
import RegularHud from './components/RegularHud';
import LocationHud from './components/LocationHud';
import Cinematic from './components/Cinematic';
import Settings from './components/Settings';
import Anatomy from './components/Anatomy';

export default {
    name: 'App',
    components: { Cinematic, VehicleHud, RegularHud, LocationHud, Settings, Anatomy },
    data: () => ({
        listener: null,
        keyListener: null,
        development: false,

        cinematicMode: false,
        hiddenMode: false,
        forceHidden: true,
        menuOpen: false,
    }),
    mounted() {
        this.listener = window.addEventListener('message', e => {

            const item = e.data || e.detail;
            const { event, data } = item;
            if (event) {
                this.development = false;
                this.$root.$emit(event, data)
            }
        }, false);

        this.keyListener = window.addEventListener('keydown', (event) => {
            const key = event.key
            if (this.menuOpen) {
                if (key === 'Escape') {
                    Nui.send('startClosingSettings', {});
                }
            }
        });

        if (Nui.inDev()) {
            this.development = true;
            Nui.addEmulatedResponse('saveHUD', { success: false });
        }

        this.$root.$on('forceHideState', (state) => {
            this.forceHidden = state;
            this.hiddenMode = state;
        })

        this.$root.$on('updateHUDSettings', (data) => {
            this.$store.commit('updateHUDSettings', data);
        })

        this.$root.$on('openMenu', () => {
            this.menuOpen = true;
        });

        this.$root.$on('closeMenu', () => {
            this.menuOpen = false;
        });

        this.$root.$on('toggleCinematicMode', (val) => {
            this.cinematicMode = val;
            this.hiddenMode = val;
        });

        this.$root.$on('toggleHiddenMode', (val) => {
            if (!this.forceHidden) {
                this.hiddenMode = val;
            }
        });

        if (Nui.inDev()) {
            this.$root.$emit('openMenu', true);
        }
    },
    methods: {

    }
}
</script>

<style lang="less">
@import '@/arp-theme.less';
@import url('https://fonts.googleapis.com/css2?family=Oswald:wght@200;300;400;500;600;700&display=swap');
@import url('https://fonts.googleapis.com/css2?family=Montserrat:wght@200;300;400;500;600;700&display=swap');

body, html, #app {
    width: 100vw;
    height: 100vh;
    overflow: hidden !important;
    padding: 0;
    margin: 0;
    -webkit-font-smoothing: antialiased;
    -moz-osx-font-smoothing: grayscale;
    font-family: 'Montserrat', sans-serif;
}

.v-application {
    background: transparent !important;
}

.devBG {
    background: @dark;
}

.watermark {
    position: fixed;
    z-index: 99;
    top: 1vh;
    left: 0.5vw;
    img {
        height: 5vh;
    }
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

&::-webkit-scrollbar {
    width: 5px;
}

&::-webkit-scrollbar-track {
    background: transparent; 
}

&::-webkit-scrollbar-thumb {
    background: @darker; 
}

</style>
