<template>
    <v-app>
        <v-autocomplete
            style="position: absolute; left: 35%; width: 30%; height: 30px;"
            v-model="value"
            :items="fakePlayer.vehicle.VIN"
            color="red darken-4"
            label="Search Vehicle"
            placeholder="Start typing to Search Vehicle on our Databases"
            prepend-icon="mdi-database-search"
            @change="showInfo = true"
        ></v-autocomplete>
        <div class="infoHolder" v-if="showInfo">
            <h3>OWNER</h3>
            <v-subheader>{{ fakePlayer.name }}</v-subheader>
            <h3>Vehicle Identification Number [VIN]</h3>
            <v-subheader>Vehicle VIN: {{ fakePlayer.vehicle.VIN }}</v-subheader>
            <h3>PLATE</h3>
            <v-subheader>{{ fakePlayer.vehicle.plate }}</v-subheader>
            <h3>STATE</h3>
            <v-subheader>{{ fakePlayer.vehicle.state }}</v-subheader>
            <h3>NOTES</h3>
            <v-subheader>Nothing there.</v-subheader>
        </div>
        <div class="vehicleHolder" v-if="showInfo">
            <v-img
                min-height="314"
                min-width="250"
                :src="fakePlayer.mugShot"
            ></v-img>
            <div class="plateHolder">
                <v-img
                    max-height="104"
                    min-width="250"
                    :src="fakePlayer.vehicle.plateImg"
                ></v-img>
            </div>
        </div>
    </v-app>
</template>

<script>
//import Nui from './utils/Nui';

export default {
    name: 'MDT-SearchVehicles',
    components: {
    },
    data: () => ({
        fakePlayer: {
            name: 'Nick Riviera',
            mugShot: 'https://u.pandabuilds.co.uk/2021/03/g49oif.png',
            driversLicense: 'COUF687578',
            vehicle: {VIN: 'A5656554', plate: '99KRDICK', plateImg: 'https://images-na.ssl-images-amazon.com/images/I/61fSDjIXdzL._AC_SL1200_.jpg', state: 'Stolen'},
            convictions: 'Eats 3x hamburgers per day on BurgerShot',
            dob: '20-01-1990'
        },
        value: null,
        showInfo: false,
    }),
    mounted() {
    },
    computed: {
        // TODO: Split the array
        getActivePlayers() {
            const activePlayers = this.$store.state.activePlayers;
            if (activePlayers) {
                console.log(activePlayers)
                for (var player in activePlayers) {
                    console.log(activePlayers[player])
                    return `${activePlayers[player]}`
                }
            }
            return '';
        }
    },
    methods: {
    }
}
</script>

<style lang="less">
@import '@/arp-theme.less';

.infoHolder {
    position: absolute;
    top: 60px;
    left: 80px;
    width: 310px;
    height: 380px;
    h3 {
        color: @red2;
        font-weight: bold;
    }
}

.vehicleHolder {
    position: absolute;
    top: 80px;
    right: 120px;
    width: 310px;
    height: 320px;
    border: 3px @red2 solid;
    border-radius: 3px;
}

.plateHolder {
    position: relative;
    top: 17px;
    right: 3px;
    width: 312px;
    height: 110px;
    border: 3px @red2 solid;
    border-radius: 3px;
}

</style>
