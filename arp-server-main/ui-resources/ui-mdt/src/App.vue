<template>
    <div id="app">
        <v-app>
            <div class="tablet">
                <div class="mdt grey darken-4" dark>
                    <header>
                        <v-img class="logo" max-height="120" max-width="120" :src="require('../public/assets/lspdLogo.png')" contain></v-img>
                        <v-subheader class="username">Welcome back, @Nick Rivera</v-subheader>
                        <v-btn class="logoutBtn" elevation="4" color="red darken-4" outlined>LOGOUT</v-btn>
                        <v-avatar class="avatar" color="red darken-4" size="49">NR</v-avatar>
                    </header>
                    <v-divider></v-divider>
                    <nav>
                        <v-tabs grow height="30" v-model="menu" color="red darken-4">
                            <v-tab>Home</v-tab>
                            <v-tab>Search Person</v-tab>
                            <v-tab>Search Vehicle</v-tab>
                            <v-tab>Create Report</v-tab>
                            <v-tab><v-badge
                                :content="messages"
                                :value="messages"
                                color="red darken-4"
                                overlap
                            >Warrants</v-badge></v-tab>
                            <v-tab>Search Reports</v-tab>
                        </v-tabs>
                    </nav>
                    <main>
                        <br><br><br>
                        <div v-if="menu === 0">
                            {{ menu }}
                        </div>
                        <div v-if="menu === 1">
                            <SearchPerson />
                        </div>
                        <div v-if="menu === 2">
                            <SearchVehicle />
                        </div>
                        <div v-if="menu === 3">
                            {{ menu }}
                        </div>
                        <div v-if="menu === 4">
                            {{ menu }}
                        </div>
                        <div v-if="menu === 5">
                            {{ menu }}
                        </div>
                    </main>
                    <v-divider></v-divider>
                    <footer>
                        <v-btn class="createLogBtn" color="red darken-4" dark absolute bottom right fab>
                            <v-icon>mdi-plus</v-icon>
                        </v-btn>
                        <v-subheader style="margin-top: -9px; margin-left: -8px;"><v-btn style="margin-top: 11px; margin-left: -5px;" text icon color="yellow lighten-2" @click.stop="dialog = true"><v-icon>mdi-white-balance-sunny</v-icon></v-btn>{{ dateString }}</v-subheader>
                        <v-subheader style="margin-top: -35px; margin-left: 24px; font-size: 12px;">{{ timeString }}</v-subheader>
                    </footer>
                </div>
                <v-dialog v-model="dialog" max-width="590">
                    <v-card>
                        <v-card-title class="headline">Dev Console</v-card-title>
                        <v-divider></v-divider>
                        <v-subheader>Warrants Notifications</v-subheader>
                        <v-btn
                        class="mx-1"
                        color="primary"
                        @click="messages++"
                        >
                        Send Message
                        </v-btn>

                        <v-btn
                        class="mx-1"
                        color="error"
                        @click="messages = 0"
                        >
                        Clear Notifications
                        </v-btn>
                        <v-card-actions>
                            <v-spacer></v-spacer>
                            <v-btn color="error darken-1" text @click="dialog = false">Close</v-btn>
                        </v-card-actions>
                    </v-card>
                </v-dialog>
            </div>
        </v-app>
    </div>
</template>

<script>
import Nui from './utils/Nui';
import SearchPerson from './components/SearchPerson';
import SearchVehicle from './components/SearchVehicle';
import moment from 'moment';

export default {
    name: 'MDT',
    components: {
        SearchPerson,
        SearchVehicle,
    },
    data: () => ({
        development: true,
        menu: 0,
        dialog: false,
        messages: 0,
        show: false,
        dateString: moment().format('dddd, Do MMMM'),
        timeString: moment().format('h:mm:ss a')
    }),
    mounted() {
        this.listener = window.addEventListener('message', e => {
            const item = e.data || e.detail;
            const { event, data } = item;
            if (event) {
                this.$root.$emit(event, data)
                this.$root.$emit('addNuiEwdtventLog', false, event, data);
            }
        }, false);


        if (Nui.inDev()) {
            this.development = true;
        }

        console.log(`UI Loaded [${Nui.inDev() ? 'Development Mode' : 'Built'}]`);

    },
    methods: {

    }
}
</script>

<style lang="less">
@import '@/arp-theme.less';

body, html, #app {
    width: 100%;
    height: 100%;
    overflow: hidden;
    padding: 0;
    margin: 0;
    -webkit-font-smoothing: antialiased;
    -moz-osx-font-smoothing: grayscale;
}

.v-application {
    background: transparent !important;
}

.tablet {
    position: fixed;
    top: 50%;
    left: 50%;
    width: 85%;
    height: 85%;
    border: black 30px solid;
    border-radius: 25px;
    -webkit-transform: translate(-50%, -50%);
    transform: translate(-50%, -50%);
}

.mdt {
    width: 100%;
    height: 100%;
    margin: 0;
}

header {
    width: 100%;
    height: 9%;
    display: flex;
    .logo {
        position: absolute;
        top: 15px;
        left: 20px;
        z-index: 9999;
    }
    .username {
        position: absolute;
        top: 35px;
        left: 125px;
        font-size: 16px;
    }
    .logoutBtn {
        position: absolute;
        top: 17px;
        left: 89%;
    }
    .avatar {
        position: absolute;
        top: 10px;
        left: 96%;
    }
}

nav {
    position: absolute;
    width: 92%;
    left: 8%;
    z-index: 0;
}

main {
    width: 100%;
    height: 86%;
}

footer {
    width: 100%;
    height: 5%;
    .createLogBtn {
        margin-bottom: 50px;
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

</style>
