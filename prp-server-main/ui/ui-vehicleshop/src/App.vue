<template>
    <div v-if="showMenu" id="app" @wheel="handleScroll">
        <v-app>
            <v-scroll-x-reverse-transition>
                <v-card v-if="selectedVehicle" class="detailsCard" elevation="7">
                    <v-card-title>{{ vehicleLabel }} <v-subheader v-if="useStocks" style="height: fit-content; padding: 0px 0px 0px 6px;">- Stock: {{ vehicleStock }}</v-subheader></v-card-title>
                    <v-card-subtitle v-if="vehicleMaker">{{ vehicleMaker }}</v-card-subtitle>
                    <v-card-text>
                        <v-row>
                            <v-chip class="ma-1" color="success darken-4" label>${{ numberWithCommas(vehiclePrice) }}</v-chip>
                            <v-spacer></v-spacer>
                            <v-chip class="ma-1" color="red darken-4">{{ vehicleType.toUpperCase() }}</v-chip>
                            <v-chip v-if="vehicleClass" class="ma-1" color="red darken-4">{{ vehicleClass.toUpperCase() }}</v-chip>
                        </v-row>
                    </v-card-text>
                    <v-divider class="mx-3"></v-divider>
                    <v-card-text>
                        <v-tabs v-model="colorType" :color="bgColor" centered grow>
                            <v-tab>Primary</v-tab>
                            <v-tab>Secondary</v-tab>
                        </v-tabs>
                        <v-color-picker v-model="bgColor" style="background: none;" hide-swatches></v-color-picker>
                    </v-card-text>
                    <v-card-actions style="margin-top: -30px;">
                        <v-btn elevation="5" color="error darken-4" large block @click="close()"><v-icon>mdi-close</v-icon>‏‏‎Close</v-btn>
                    </v-card-actions>
                    <v-card-actions>
                        <v-btn elevation="5" color="info darken-4" large block @click="startTestDrive()"><v-icon>mdi-car-multiple</v-icon>‏‏‎ Test Drive</v-btn>
                    </v-card-actions>
                    <v-card-actions>
                        <v-btn elevation="5" :color="!useStocks || vehicleStock > 10 ? 'success darken-4' : 'yellow darken-4'" large block @click="confirm()"><v-icon>mdi-currency-usd</v-icon>‏‏‎Pay</v-btn>
                    </v-card-actions>
                </v-card>
            </v-scroll-x-reverse-transition>
            <carousel class="carousel" v-model="vehCarousel" :per-page="4" :mouse-drag="true" :paginationEnabled="false" :navigationEnabled="true">
                <slide class="slide" v-for="(vehicle, i) in vehicles" :key="i" :data-index="i" :data-name="vehicle.name" :data-label="vehicle.label" :data-maker="vehicle.maker" :data-price="vehicle.price" :data-type="vehicle.type" :data-class="vehicle.class" :data-stock="vehicle.stock" @slideclick="handleSlideClick">
                    <img :src="'./assets/' + vehicle.name + '.png'">
                    <span>{{ vehicle.label }}</span>
                </slide>
            </carousel>
        </v-app>
    </div>
</template>

<script>
import Nui from './utils/Nui';
import { Carousel, Slide } from 'vue-carousel';

export default {
    name: 'App',
    components: {
        Carousel,
        Slide
    },
    data: () => ({
        development: false,
        showMenu: false,
        useStocks: true,
        vehCarousel: 0,
        selectedVehicle: '',
        colorType: -1,
        vehicleLabel: 'Adder',
        vehicleMaker: 'Truffade',
        vehiclePrice: 1000000,
        vehicleType: 'Cars',
        vehicleClass: 'Super',
        vehicleStock: 100,
        hex: '#FFFFFF',
        bgHex: '#FFFFFF',
        vehicles: [
            { name: 'adder', label: 'Adder', maker: 'Truffade', price: '1000000', type: 'Cars', class: 'Super', stock: '100' },
            { name: 'dominator3', label: 'Dominator GTX', maker: 'Vapid', price: '1000000', type: 'Cars', class: 'Sport', stock: '1' },
            { name: 'banshee2', label: 'Banshee Custom', maker: 'Bravado', price: '1000000', type: 'Cars', class: 'Sport', stock: '1' },
            { name: 'tailgater2', label: 'Tailgater S', maker: 'Obey', price: '1000000', type: 'Cars', class: 'Sport', stock: '1' }
        ]
    }),
    mounted() {
        this.listener = window.addEventListener('message', e => {
            const item = e.data || e.detail;
            const { event, data } = item;
            if (event) {
                this.$root.$emit(event, data)
                this.$root.$emit('addNuiEventLog', false, event, data);
            }

            if (item.showMenu == false) {
                this.showMenu = false;
            } else if (item.showMenu == true) {
                this.showMenu = true;
                this.vehicles = item.vehiclesList;
                this.useStocks = item.useStocks;
                if (item.customDataset != undefined) {
                    this.handleSlideClick(item.customDataset);
                    /*this.vehicleLabel = item.customDataset.label;
                    this.selectedVehicle = item.customDataset.name;
                    this.vehiclePrice = item.customDataset.price;
                    this.vehicleType = item.customDataset.type;
                    this.vehicleClass = item.customDataset.class;
                    this.vehicleStock = item.customDataset.stock;*/
                }
            }
        }, false);

        window.addEventListener('scroll', this.handleScroll);

        /*window.addEventListener("keypress", (event) => {
            console.log(event)
            if (event.key == "Escape") {
                this.showMenu = false;
                fetch(`https://ui-vehicleshop/handleEscape`, {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json; charset=UTF-8',
                    },
                    body: JSON.stringify({})
                }).then(resp => resp.json()).then(resp => console.log(resp));
            }
        });*/

        if (Nui.inDev()) {
            this.development = true;
        }

        console.log(`UI Loaded [${Nui.inDev() ? 'Development Mode' : 'Built'}]`);
    },
    destroyed () {
        window.removeEventListener('scroll', this.handleScroll);
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
                var color = v.substring(1);
                var aRgbHex = color.match(/.{1,2}/g);
                var aRgb = [
                    parseInt(aRgbHex[0], 16),
                    parseInt(aRgbHex[1], 16),
                    parseInt(aRgbHex[2], 16)
                ];
                fetch(`https://ui-vehicleshop/changeColor`, {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json; charset=UTF-8',
                    },
                    body: JSON.stringify({
                        color : aRgb,
                        colorType : this.colorType
                    })
                }).then(resp => resp.json()).then(resp => console.log(resp));
                this['bgHex'] = v
            },
        }
    },
    methods: {
        confirm() {
            this.showMenu = false;
            fetch(`https://ui-vehicleshop/handleConfirm`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json; charset=UTF-8',
                },
                body: JSON.stringify({
                    selectedVehicle: this.selectedVehicle
                })
            });
        },
        close() {
            this.showMenu = false;
            this.selectedVehicle = '';
            fetch(`https://ui-vehicleshop/handleEscape`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json; charset=UTF-8',
                },
                body: JSON.stringify({})
            });
        },
        startTestDrive() {
            this.showMenu = false;
            fetch(`https://ui-vehicleshop/startTestDrive`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json; charset=UTF-8',
                },
                body: JSON.stringify({
                    selectedVehicle: this.selectedVehicle
                })
            });
        },
        numberWithCommas(x) {
            return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',');
        },
        handleScroll (event) {
            if (event.deltaY !== 0) {
                if (event.deltaY < 0) {
                    this.vehCarousel++;
                }
                else {
                    this.vehCarousel--;
                }
            }
        },
        handleSlideClick (dataset) {
            /* Animate */
            this.selectedVehicle = '';
            setTimeout(() => { 
                this.selectedVehicle = dataset.name;
                this.vehicleLabel = dataset.label;
                this.vehicleMaker = dataset.maker;
                this.vehiclePrice = dataset.price;
                this.vehicleType = dataset.type;
                this.vehicleClass = dataset.class;
                this.vehicleStock = dataset.stock;
                fetch(`https://ui-vehicleshop/handleVehicleSelect`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json; charset=UTF-8',
                },
                body: JSON.stringify({
                    selectedVehicle: dataset.name
                })
            }).then(resp => resp.json()).then(resp => console.log(resp));
            }, 100);
        }
    }
}
</script>

<style lang="less">
@import '@/theme.less';
@import url('https://fonts.googleapis.com/css2?family=Poppins:wght@700&display=swap');

* {
    font-family: 'Poppins', sans-serif;
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

.detailsCard {
    position: absolute;
    top: 7%;
    left: 82.3%;
    width: 300px;
}

.carousel {
    position: absolute !important;
    left: 6%;
    bottom: 0;
    width: 90%;
    .slide {
        display: flex;
        margin-left: 10px;
        margin-right: 10px;
        height: 128px;
        max-width: 412px;
        min-width: 412px;
        background-color: #121212;
        border-radius: 17px;
        box-shadow: inset 1px 1px 23px 2px black;
        align-items: center;
        justify-content: center;
        
        img {
            margin-bottom: 20px;
            max-height: 92px !important;
            max-width: 164px !important;
        }

        span {
            position: absolute;
            bottom: 3px;
            color: #fff;
            font-weight: bold;
            text-shadow: black 0px 0px 10px;
            white-space: nowrap;
        }
    }
}

.slide:hover {
    border: #D50000 2px solid;
    transition: .1s;
}

.VueCarousel-wrapper {
    margin-bottom: 20px;
}

.VueCarousel-dot-container {
    position: relative;
    margin-top: -30px !important;
    bottom: 7px !important;
}

.VueCarousel-dot {
    outline: none !important;
}
</style>