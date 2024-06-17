<template>
    <div id="app">
        <v-app>
            <v-scroll-x-reverse-transition>
                <v-card v-if="showUI" style="position: absolute; top: 7px; left: 7px; max-height: 890px;" elevation="5" width="374" max-width="374">
                    <v-card-title v-if="selectedVehicle != undefined">{{selectedVehicleName}} - Status: <v-chip class="ma-1" :color="selectedVehicleColor" label>{{selectedVehicleGarage ? "InGarage" : "OutGarage"}}</v-chip></v-card-title>
                    <v-card-title v-else>Public Garage - {{ vehicles.length }} cars</v-card-title>
                    <v-card-subtitle style="margin-bottom: -10px;">{{ garageLocation }}</v-card-subtitle>
                    <v-card-text style="max-height: 670px; overflow-y: auto;">
                        <v-expansion-panels v-model="selectedVehicle">
                            <v-expansion-panel class="my-1" v-for="vehicle, i in vehicles" :key="i" @click="changeSelectedVehicle(i)">
                                <v-expansion-panel-header>
                                    <span><v-icon v-if="vehicle.type == 'car'" color="info darken-3">mdi-car</v-icon><v-icon v-if="vehicle.type == 'motorcycle'" color="info darken-3">mdi-motorbike</v-icon><v-icon v-if="vehicle.type == 'truck'" color="info darken-3">mdi-truck</v-icon><v-icon v-if="vehicle.type == 'boat'" color="info darken-3">mdi-ferry</v-icon><v-icon v-if="vehicle.type == 'heli'" color="info darken-3">mdi-helicopter</v-icon> {{vehicle.label}} [{{vehicle.plate}}]</span>
                                </v-expansion-panel-header>
                                <v-expansion-panel-content>
                                    <v-list>
                                        <v-list-item>
                                        <v-list-item-content>
                                            <v-list-item-title>{{ vehicle.label }}</v-list-item-title>
                                            <v-list-item-subtitle>Karin</v-list-item-subtitle>
                                            <!--div style="position: absolute; top: 7px; right: 7px;">
                                                <v-avatar :color="vehicle.colors[0].primary" size="26"></v-avatar> <v-avatar :color="vehicle.colors[0].secondary" size="26"></v-avatar>
                                            </div-->
                                            <v-img src="https://i.imgur.com/cjyTKhj.png" max-width="250"></v-img>
                                        </v-list-item-content>
                                        </v-list-item>
                                    </v-list>
                                    <v-divider style="margin-bottom: 10px;" class="mx-3"></v-divider>
                                    <!--v-subheader>Vehicle Details</v-subheader-->
                                    <span>Handling</span><v-progress-linear :value="vehicle.data.handling" color="info darken-3" rounded height="6"></v-progress-linear>
                                    <span>Top Speed</span><v-progress-linear :value="vehicle.data.topspeed" color="info darken-3" rounded height="6"></v-progress-linear>
                                    <span>Acceleration</span><v-progress-linear :value="vehicle.data.acceleration" color="info darken-3" rounded height="6"></v-progress-linear>
                                    <span>HP</span><v-progress-linear :value="vehicle.data.hp" color="info darken-3" rounded height="6"></v-progress-linear>
                                    <span>Torque</span><v-progress-linear :value="vehicle.data.torque" color="info darken-3" rounded height="6"></v-progress-linear>
                                    <span>Brake</span><v-progress-linear :value="vehicle.data.brake" color="info darken-3" rounded height="6"></v-progress-linear>
                                    <span>Engine State</span><v-progress-linear :value="vehicle.data.engine" :color="vehicle.menuColors.engine" rounded height="6"></v-progress-linear>
                                    <span>Body State</span><v-progress-linear :value="vehicle.data.body" :color="vehicle.menuColors.body" rounded height="6"></v-progress-linear>
                                    <v-divider class="my-3 mx-3"></v-divider><br>
                                    <v-row style="margin-top: -23px;">
                                        <v-btn class="mx-2" elevation="5" large @click="confirm()"><v-icon>mdi-garage</v-icon>‏‏‎Change Owner</v-btn>
                                        <v-btn style="margin-bottom: 10px;" elevation="5" :color="selectedVehicleColor" large @click="confirm()"><v-icon>mdi-car</v-icon>‏‏‎Drive</v-btn>
                                    </v-row>
                                </v-expansion-panel-content>
                            </v-expansion-panel>
                        </v-expansion-panels>
                    </v-card-text>
                    <v-divider class="mx-3"></v-divider>
                    <v-card-actions>
                        <v-btn v-if="isInVehicle" elevation="5" color="info darken-4" large block @click="storeVehicle()"><v-icon>mdi-content-save</v-icon>‏‏‎Store Vehicle</v-btn>
                    </v-card-actions>
                    <v-card-actions>
                        <v-btn style="margin-top: -10px;" elevation="5" color="error darken-4" large block @click="close()"><v-icon>mdi-close</v-icon>‏‏‎Close</v-btn>
                    </v-card-actions>
                </v-card>
            </v-scroll-x-reverse-transition>
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
        development: false,
        showUI: false,
        selectedVehicle: null,
        selectedVehicleName: null,
        selectedVehicleColor: null,
        selectedVehicleGarage: null,
        garageLocation: "San Andreas Avenue Garage",
        isInVehicle: false,
        vehicles: [
            {name: "sultanrs", type:"car", label: "Sultan RS", plate: "99AA99", colors:{primary:"info darken-4", secondary:"white"}, data: {inGarage: true, handling : 70, topspeed: 100, acceleration: 85, hp: 80, torque: 55, brake: 70, engine: 25, body: 80}, menuColors: {engine: "info darken-3", body: "info darken-3"}},
            {name: "bati", type:"motorcycle", label: "Bati 801", plate: "99AA99", colors:{primary:"red darken-4", secondary:"black"}, data: {inGarage: false, handling : 70, topspeed: 100, acceleration: 85, hp: 80, torque: 55, brake: 70, engine: 30, body: 80}, menuColors: {engine: "info darken-3", body: "info darken-3"}},
            {name: "mule", type:"truck", label: "Mule", plate: "99AA99", colors:{primary:"info darken-4", secondary:"white"}, data: {inGarage: true, handling : 70, topspeed: 100, acceleration: 85, hp: 80, torque: 55, brake: 70, engine: 30, body: 80}, menuColors: {engine: "info darken-3", body: "info darken-3"}},
            {name: "seashark", type:"boat", label: "Seashark", plate: "99AA99", colors:{primary:"info darken-4", secondary:"white"}, data: {inGarage: true, handling : 70, topspeed: 100, acceleration: 85, hp: 80, torque: 55, brake: 70, engine: 30, body: 80}, menuColors: {engine: "info darken-3", body: "info darken-3"}},
            {name: "volatus", type:"heli", label: "Volatus", plate: "99AA99", colors:{primary:"info darken-4", secondary:"white"}, data: {inGarage: true, handling : 70, topspeed: 100, acceleration: 85, hp: 80, torque: 55, brake: 70, engine: 30, body: 80}, menuColors: {engine: "info darken-3", body: "info darken-3"}},
        ],
        vehicleName: null
    }),
    mounted() {
        this.listener = window.addEventListener('message', e => {
            const item = e.data || e.detail;
            const { event, data } = item;
            if (event) {
                this.$root.$emit(event, data)
                this.$root.$emit('addNuiEventLog', false, event, data);
            }

            if (item.action == "show") {
                this.showUI = true;
                this.garageLocation = item.garageName;
                this.isInVehicle = item.isInVehicle;
                this.vehicles = item.vehicles;
                console.log(this.vehicles[1].name);
            } else if (item.action == "hide") {
                this.showUI = false;
            }
        }, false);

        for (let i = 0; i < this.vehicles.length; i++) {
            if (this.vehicles[i].data[0].engine <= 25) {
                this.vehicles[i].menuColors.engine = 'red darken-3';
            } else if (this.vehicles[i].data[0].engine <= 60) {
                this.vehicles[i].menuColors.engine = 'info darken-3';
            } else if (this.vehicles[i].data[0].engine > 60) {
                this.vehicles[i].menuColors.engine = 'green darken-3';
            }
            if (this.vehicles[i].data[0].body <= 25) {
                this.vehicles[i].menuColors.body = 'red darken-3';
            } else if (this.vehicles[i].data[0].body <= 60) {
                this.vehicles[i].menuColors.body = 'info darken-3';
            } else if (this.vehicles[i].data[0].body > 60) {
                this.vehicles[i].menuColors.body = 'green darken-3';
            }
        }

        if (Nui.inDev()) {
            this.development = true;
        }

        console.log(`UI Loaded [${Nui.inDev() ? 'Development Mode' : 'Built'}]`);
    },
    methods: {
        changeSelectedVehicle: function(i) {
            //console.log(i);
            this.selectedVehicleName = this.vehicles[i].label;
            this.selectedVehicleGarage = this.vehicles[i].data.inGarage;
            if (this.selectedVehicleGarage == false) {
                this.selectedVehicleColor = "error darken-4";
            } else {
                this.selectedVehicleColor = "success darken-4";
            }
        },
        close: function() {
            this.showUI = false;
            fetch(`https://ui-garages/close`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json; charset=UTF-8',
                },
                body: JSON.stringify()
            });
            //Nui.send('hideUI');
            this.selectedVehicle = null;
            this.selectedVehicleName = null;
            this.selectedVehicleColor = null;
            this.selectedVehicleGarage = null;
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
    -webkit-font-smoothing: antialiased;
    -moz-osx-font-smoothing: grayscale;
}

::-webkit-scrollbar {
    display: none;
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

.theme--dark.v-expansion-panels .v-expansion-panel:not(:first-child)::after {
    border: none !important;
}
</style>