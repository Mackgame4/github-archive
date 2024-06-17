<template>
    <div class="app">
        <div class="options" v-if="!getPhoneCall">
            <v-tabs grow style="width: 100%; height: 100%;" height="35" v-model="menu" color="grey">
                <v-tab style="width: 33%">History</v-tab>
                <v-tab style="width: 33%">Keypad</v-tab>
                <v-tab style="width: 33%" @click="openContacts">Contacts</v-tab>
            </v-tabs>
        </div>

        <div class="innerApp" v-if="getPhoneCall">
            <div class="numberCalling">
                <p>{{ getCallContact(getPhoneCall.number) ? getCallContact(getPhoneCall.number).name : getPhoneCall.number }}</p>
            </div>
            <div class="spinnerContainer">
                <v-progress-circular indeterminate size="100" style="width: 100%; height: 100%; margin: auto;"></v-progress-circular>
            </div>
            <div class="callTime">
                <p>{{ getPhoneCall.length }}</p>
            </div>
            <div class="callActions">
                <v-btn tile elevation="0" class="kpButton"><v-icon dark color="red" size="35">mdi-phone-hangup</v-icon></v-btn>
            </div>
        </div>

        <div class="innerApp" v-else-if="menu === 1">
            <div class="contactMatch">
                <ContactsMatch :searchType="'number'" :searchQuery="pNumber" @select="matchContactSelect" />
            </div>
            <div class="numberInput">
                <input v-model="pNumber" type="text" min="0" :style="getNumInputStyle" v-mask="'###-###-####'" placeholder="###-###-####">
            </div>
            <div class="keypad">
                <v-btn tile elevation="0" class="kpButton" @click="keypadNum(1)">1</v-btn>
                <v-btn tile elevation="0" class="kpButton" @click="keypadNum(2)">2</v-btn>
                <v-btn tile elevation="0" class="kpButton" @click="keypadNum(3)">3</v-btn>
                <v-btn tile elevation="0" class="kpButton" @click="keypadNum(4)">4</v-btn>
                <v-btn tile elevation="0" class="kpButton" @click="keypadNum(5)">5</v-btn>
                <v-btn tile elevation="0" class="kpButton" @click="keypadNum(6)">6</v-btn>
                <v-btn tile elevation="0" class="kpButton" @click="keypadNum(7)">7</v-btn>
                <v-btn tile elevation="0" class="kpButton" @click="keypadNum(8)">8</v-btn>
                <v-btn tile elevation="0" class="kpButton" @click="keypadNum(9)">9</v-btn>
                <div></div>
                <v-btn tile elevation="0" class="kpButton" @click="keypadNum(0)">0</v-btn>
                <v-btn tile elevation="0" class="kpButton" @click="keypadNum('-')"><v-icon dark>mdi-keyboard-backspace</v-icon></v-btn>
                <div></div>
                <v-btn tile elevation="0" class="kpButton"><v-icon dark color="green" size="35">mdi-phone</v-icon></v-btn>
            </div>
        </div>

        <div class="innerApp" v-else-if="menu === 0">
            <v-divider></v-divider>
            <v-list subheader flat class="list">
                <v-list-item v-for="(call, idx) in callHistorySorted" v-bind:key="idx">
                    <v-list-item-avatar>
                        <v-avatar color="grey">
                            <v-icon dark v-if="call.outgoing">mdi-phone-outgoing</v-icon>
                            <v-icon dark v-else>mdi-phone-incoming</v-icon>
                        </v-avatar>
                    </v-list-item-avatar>
                    <v-list-item-content>
                        <v-list-item-title v-if="!getCallContact(call.number)">{{ call.number }}</v-list-item-title>
                        <v-list-item-title v-else>{{ getCallContact(call.number).name }}</v-list-item-title>
                        <v-list-item-subtitle>{{ getCallTime(call.time) }}</v-list-item-subtitle>
                    </v-list-item-content>

                    <v-list-item-action v-if="!getCallContact(call.number)">
                        <v-btn icon @click="addNewContact(call.number)">
                            <v-icon color="grey lighten-2">mdi-plus</v-icon>
                        </v-btn>
                    </v-list-item-action>
                    <v-list-item-action>
                        <v-btn icon>
                            <v-icon color="green">mdi-phone</v-icon>
                        </v-btn>
                    </v-list-item-action>
                </v-list-item>
            </v-list>
        </div>
        
        <div class="header">
            <v-subheader>Phone</v-subheader>
        </div>
    </div>
</template>

<script>
//import Nui from '../../utils/Nui';
import moment from 'moment';

import { ContactsMatch } from '../utilComponents';
import { isNumberValid } from '../utils/utils';

export default {
    name: 'PhoneCall',
    components: {
        ContactsMatch
    },
    data: () => ({
        pNumber: '',
        validNum: false,
        menu: 1,
    }),
    props: {
        initData: {
            required: true,
        }
    },
    methods: {
        keypadNum(k) {
            if (k === '-') {
                this.pNumber = this.pNumber.substr(0, this.pNumber.length - 1);
            } else {
                this.pNumber += k;
            }
        },
        matchContactSelect(num) {
            this.pNumber = num;
        },
        openContacts() {
            this.$root.$emit('openApp', { app: 'contacts', data: { fromPhone: true }});
        },
        getCallTime(time) {
            return moment.unix(time).fromNow();
        },
        getCallContact(number) {
            return this.$store.getters.getContactByNumber(number);
        },
        addNewContact(number) {
            this.$root.$emit('dialogs:show', 'ContactEdit', {
                type: true,
                number
            });
        }
    },
    computed: {
        getNumInputStyle() {
            let state = {};
            if (this.validNum) {
                state.color = 'white';
            } else {
                state.color = '#B71C1C';
            }
            return state;
        },
        callHistorySorted() {
            return this.$store.getters.getCallHistory;
        },
        getPhoneCall() {
            return this.$store.state.phoneCall;
        }
    },
    created() {
        
    },
    mounted() {

    },
    watch: {
        pNumber(val) {
            this.validNum = isNumberValid(val);
        }
    }
};

</script>

<style scoped lang="less">
@import '@/arp-theme.less';

.app {
    width: 100%;
    height: 100%;
    display: flex;
    flex-direction: column-reverse;
    .innerApp {
        height: 95%;
        display: flex;
        flex-direction: column;
        .list {
            height: 100%;
            overflow-y: scroll;
        }
        // Keypad
        .contactMatch {
            height: 22%;
        }
        .numberInput {
            height: 12%;
            padding: 0 8%;
            font-family: 'Montserrat', sans-serif;
            input {
                height: 100%;
                width: 100%;
                color: white;
                font-size: 2.2rem;
                text-align: center;
                &:focus {
                    outline: none;
                }
            }
        }
        .keypad {
            height: 65%;
            padding: 0 13%;
            display: grid;
            grid-template-columns: repeat(3, 33.33%);
            grid-template-rows: repeat(5, 20%);
            font-family: 'Montserrat', sans-serif;
            .kpButton {
                height: 100%;
                width: 100%;
                background: transparent;
                font-size: 3rem;
            }
        }
        // Recent Calls

        .callActions {
            height: 15%;
            padding: 0 13%;
            font-family: 'Montserrat', sans-serif;
            .kpButton {
                height: 100%;
                width: 100%;
                background: transparent;
                font-size: 3rem;
            }
        }
        .spinnerContainer {
            height: 50%;
            padding: 25% 0;
        }
        p {
            font-family: 'Montserrat', sans-serif;
            height: 100%;
            width: 90%;
            margin: 0 5%;
            color: white;
            font-size: 2rem;
            text-align: center;
            user-select: none;
        }
        .callTime {
            height: 15%;
        }
        .numberCalling {
            height: 15%;
            p {
                font-size: 1.8rem;
                overflow: hidden;
                display: -webkit-box;
                -webkit-line-clamp: 2; /* number of lines to show */
                -webkit-box-orient: vertical;
            }
        }
    }
    .header {
        height: 6%;
    }
}

</style>
