<template>
    <v-app>
        <v-autocomplete
            style="position: absolute; left: 35%; width: 30%; height: 30px;"
            v-model="value"
            :items="fakePlayer.name"
            color="red darken-4"
            label="Search Person"
            placeholder="Start typing to Search Person on our Databases"
            prepend-icon="mdi-database-search"
            @change="showInfo = true"
        ></v-autocomplete>
        <div class="infoHolder" v-if="showInfo">
            <h3>NAME</h3>
            <v-subheader>{{ fakePlayer.name }}</v-subheader>
            <h3>LICENSES</h3>
            <v-subheader>Driver License: {{ fakePlayer.driversLicense }}</v-subheader>
            <h3>Vehicle Identification Number [VIN]</h3>
            <v-subheader>Vehicles: {{ fakePlayer.vehicle }}</v-subheader>
            <h3>CONVICTIONS</h3>
            <v-subheader>{{ fakePlayer.convictions }}</v-subheader>
            <h3>Date Of Birthday [DOB]</h3>
            <v-subheader>{{ fakePlayer.dob }}</v-subheader>
            <h3>NOTES</h3>
            <v-subheader>Nothing there.</v-subheader>
        </div>
        <div class="mugHolder" v-if="showInfo">
            <v-img
                min-height="374"
                min-width="250"
                :src="fakePlayer.mugShot"
            ></v-img>
            <br>
            <v-btn
            style="margin-left: 8px;"
            text
            color="blue"
            outlined
            @click.stop="dialog = true"
            >
            Edit Profile
            </v-btn>
            <v-btn
            style="margin-left: 20px;"
            text
            color="red darken-4"
            outlined
            >
            New Report
            </v-btn>
        </div>
        <v-dialog v-model="dialog" max-width="590">
            <v-card>
                <v-card-title class="headline">Edit Profile</v-card-title>
                <v-text-field class="editField" label="Convictions"></v-text-field>
                <v-text-field class="editField" label="Notes"></v-text-field>
                <v-card-actions>
                    <v-spacer></v-spacer>
                    <v-btn color="error darken-1" text @click="dialog = false">Cancel</v-btn>
                    <v-btn color="green darken-1" text @click="dialog = false">Confirm</v-btn>
                </v-card-actions>
            </v-card>
        </v-dialog>
    </v-app>
</template>

<script>
//import Nui from './utils/Nui';

export default {
    name: 'MDT-SearchPerson',
    components: {
    },
    data: () => ({
        fakePlayer: {
            name: 'Nick Riviera',
            mugShot: 'https://u.pandabuilds.co.uk/2021/03/g49oif.png',
            driversLicense: 'COUF687578',
            vehicle: 'A5656554',
            convictions: 'Eats 3x hamburgers per day on BurgerShot',
            dob: '20-01-1990'
        },
        value: null,
        dialog: false,
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

.mugHolder {
    position: absolute;
    top: 80px;
    right: 120px;
    width: 310px;
    height: 380px;
    border: 3px @red2 solid;
    border-radius: 3px;
}

.editField {
    margin-left: 7%;
    width: 80%;
}

</style>
