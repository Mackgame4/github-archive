<template>
    <div>
        <transition name="fade">
            <div class="vehicleAlt" v-if="!hide && shouldShowSpeedo && engine && flying">
                <span class="speed"><span v-if="getAltLeadingZeros"></span>{{ altitude }}</span>
                <span class="measure">ALT</span>
            </div>
        </transition>

        <transition name="fade">
            <div class="vehicleSpeed" v-if="!hide && shouldShowSpeedo">
                <span class="speed" v-if="engine"><span v-if="getLeadingZeros">{{ getLeadingZeros }}</span>{{ speed > 0 ? speed : ''}}</span>
                <span class="speed" v-else><span>OFF</span></span>
                <span class="measure" v-if="engine">MPH</span>
            </div>
        </transition>

        <transition name="fade">
            <div class="vehicleIconContainer" v-if="!hide && shouldShowSpeedo">
                <div class="vehicleIconCol">
                    <vehicle-icon :show="indicators === 1 || indicators === 3" icon="mdi-arrow-left-bold" :percentage="10" colorOverride="#00b003" :indicator="true" />
                    <vehicle-icon :show="engine && !seatbelt" icon="mdi-seatbelt" :percentage="10" />
                    <vehicle-icon :show="emergencyVehicle" icon="mdi-car-emergency" :percentage="100" colorOverride="#ffffff" :emergency="emergencyLights" />
                </div>
                <v-spacer></v-spacer>
                <div class="vehicleIconCol">
                    <vehicle-icon :show="indicators === 2 || indicators === 3" icon="mdi-arrow-right-bold" :percentage="10" colorOverride="#00b003" :indicator="true" />
                    <vehicle-icon :showExact="showExact" :show="engine" icon="mdi-gas-station" :percentage="fuel" />
                    <vehicle-icon :show="driver && engine && cruise" icon="mdi-car-cruise-control" :percentage="100" />
                </div>
            </div>
        </transition>
    </div>
</template>



<script>
import VehicleIcon from './VehicleIcon';

export default {
    components: { VehicleIcon },
    props: {
        hide: {
            required: true
        }
    },
    data: () => ({
        inside: false,
        driver: true,
        engine: true,
        indicators: 0,
        seatbelt: false,
        cruise: true,
        speed: 0,
        fuel: 50,
        flying: false,
        altitude: 1,
        emergencyVehicle: false,
        emergencyLights: false,

        showExact: false,
    }),
    mounted() {
        this.$root.$on('dataUpdates', ({ vehicle }) => {
            this.inside = vehicle.inside;
            this.driver = vehicle.driver;
            this.engine = vehicle.engine;
            this.indicators = vehicle.indicators;
            this.seatbelt = vehicle.seatbelt;
            this.cruise = vehicle.cruise;
            this.fuel = vehicle.fuel;
            this.flying = vehicle.flying;
            this.emergencyVehicle = vehicle.ems;
            this.emergencyLights = vehicle.emsLights;
        });

        this.$root.$on('updateVehicleSpeed', ({ speed, altitude }) => {
            this.speed = speed;
            this.altitude = altitude;
        });

        this.$root.$on('toggleDetailState', (state) => {
            this.showExact = state;
        });
    },
    computed: {
        getLeadingZeros() {
            if (this.speed === 0) {
                return '000';
            } else if (this.speed < 10) {
                return '00';
            } else if (this.speed < 100) {
                return '0';
            } else {
                return false;
            }
        },
        shouldShowSpeedo() {
            if (this.inside) {
                if (this.driver && this.getShouldShowWhenDriver) {
                    return true;
                } else if (!this.driver && this.getShouldShowWhenPassenger) {
                    return true;
                }
            }
            return false;
        },
        getShouldShowWhenDriver() {
            return this.$store.getters.getHUDSettings.speedoDriver;
        },
        getShouldShowWhenPassenger() {
            return this.$store.getters.getHUDSettings.speedoPassenger;
        }
    }
};

</script>

<style scoped lang="less">
@import '@/arp-theme.less';
@import url('https://fonts.googleapis.com/css2?family=Montserrat:wght@300&display=swap');
.vehicleSpeed {
    //font-family: 'Oswald', sans-serif;
    font-family: 'Montserrat', sans-serif;
    text-shadow: 4px 4px 6px rgb(24, 24, 24);
    font-weight: 500;
    position: fixed;
    width: 8vw;
    height: 10vh;
    left: 46vw;
    bottom: 0.5vh;
    display: flex;
    flex-direction: column;
    text-align: center;
    user-select: none;
    .speed {
        font-size: 5vh;
        line-height: 5.2vh;
        color: @lighter;
        span {
            //opacity: 80%;
            color: rgb(80, 80, 80);
        }
    }
    .measure {
        font-size: 1.8vh;
        font-weight: 300;
    }
}

.vehicleAlt {
    font-family: 'Montserrat', sans-serif;
    text-shadow: 4px 4px 6px rgb(24, 24, 24);
    font-weight: 500;
    position: fixed;
    width: 8vw;
    height: 10vh;
    left: 46vw;
    bottom: 5vh;
    display: flex;
    flex-direction: column;
    text-align: center;
    user-select: none;
    .speed {
        font-size: 2.5vh;
        line-height: 2.5vh;
        color: @lighter;
        span {
            //opacity: 80%;
            color: rgb(80, 80, 80);
        }
    }
    .measure {
        font-size: 1.2vh;
        font-weight: 300;
    }
}

.vehicleIconContainer {
    position: fixed;
    bottom: 0.5vh;
    left: 42vw;
    width: 16vw;
    height: 11vh;
    display: flex;
    flex-direction: row;
}

.vehicleIcons {
    width: 4vw;
    display: flex;
    flex-direction: column;
    text-align: center;
}
</style>
