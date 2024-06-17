<template>
    <div id="app">
        <v-app>
            <div class="appBar">
                <v-tabs v-model="tab" fixed-tabs dark :color="getPhoneData.mainColor">
                    <v-tab href="#tab-1"><v-icon>mdi-phone</v-icon></v-tab> <!-- Dial -->
                    <v-tab href="#tab-2"><v-icon>mdi-history</v-icon></v-tab> <!-- Recent Calls -->
                    <v-tab href="#tab-3"><v-icon>mdi-account-box</v-icon></v-tab> <!-- Contacts (opens ContactsApp?) -->
                </v-tabs>
            </div>
            <div class="appContainer">
                <div v-if="tab == 'tab-1'">
                    <div class="latestCalls">
                        <v-card v-for="(call, id) in latestCalls" :key="id" class="latestCall" dark> <!-- Latest Call -->
                            <v-card-title style="padding-top: 7px; font-size: 17px;"><v-icon v-if="call.status == 'received'" style="font-size: 20px;" color="error">mdi-phone-missed</v-icon><v-icon v-if="call.status == 'sent'" style="font-size: 20px;" color="success">mdi-phone-outgoing</v-icon>‏‏‎ ‎{{ call.callerName }}<span v-if="call.callerName == null">Unknown</span></v-card-title>
                            <v-card-subtitle><text-highlight :queries="dialInput"># {{ call.callerNumber }}</text-highlight></v-card-subtitle>
                            <v-card-actions class="cardActions">
                                <v-card-subtitle>{{ currentTime() }}</v-card-subtitle>
                                <v-btn text fab :color="getPhoneData.mainColor"><v-icon>mdi-phone</v-icon></v-btn>
                            </v-card-actions>
                        </v-card>
                    </div>
                    <v-text-field v-model="dialInput" class="dialInput" style="font-size: 20px;" dense outlined append-icon="mdi-close" @click:append="clearDial" :color="getPhoneData.mainColor"></v-text-field>
                    <div class="dial">
                        <v-btn class="dialBtn" @click="addDial('1')" elevation="4" fab>1</v-btn>
                        <v-btn class="dialBtn" @click="addDial('2')" elevation="4" fab>2<span>ABC</span></v-btn>
                        <v-btn class="dialBtn" @click="addDial('3')" elevation="4" fab>3<span>DEF</span></v-btn><br>
                        <v-btn class="dialBtn" @click="addDial('4')" elevation="4" fab>4<span>GHI</span></v-btn>
                        <v-btn class="dialBtn" @click="addDial('5')" elevation="4" fab>5<span>JKL</span></v-btn>
                        <v-btn class="dialBtn" @click="addDial('6')" elevation="4" fab>6<span>MNO</span></v-btn><br>
                        <v-btn class="dialBtn" @click="addDial('7')" elevation="4" fab>7<span>PQRS</span></v-btn>
                        <v-btn class="dialBtn" @click="addDial('8')" elevation="4" fab>8<span>TUV</span></v-btn>
                        <v-btn class="dialBtn" @click="addDial('9')" elevation="4" fab>9<span>WXYZ</span></v-btn><br>
                        <v-btn class="dialBtn" @click="addDial('*')" elevation="4" fab>*</v-btn>
                        <v-btn class="dialBtn" @click="addDial('0')" elevation="4" fab>0<span>+</span></v-btn>
                        <v-btn class="dialBtn" @click="addDial('#')" elevation="4" fab>#</v-btn>
                    </div>
                    <v-btn class="callBtn" fab color="success"><v-icon>mdi-phone</v-icon></v-btn>
                </div>
                <div v-if="tab == 'tab-2'">
                    <v-card v-for="(call, id) in latestCalls" :key="id" class="latestCall" dark> <!-- Latest Call -->
                        <v-card-title style="padding-top: 7px; font-size: 17px;"><v-icon v-if="call.status == 'received'" style="font-size: 20px;" color="error">mdi-phone-missed</v-icon><v-icon v-if="call.status == 'sent'" style="font-size: 20px;" color="success">mdi-phone-outgoing</v-icon>‏‏‎ ‎{{ call.callerName }}<span v-if="call.callerName == null">Unknown</span></v-card-title>
                        <v-card-subtitle># {{ call.callerNumber }}</v-card-subtitle>
                        <v-card-actions class="cardActions">
                            <span>{{ currentTime() }}</span>
                            <v-btn text fab :color="getPhoneData.mainColor"><v-icon>mdi-phone</v-icon></v-btn>
                        </v-card-actions>
                    </v-card>
                </div>
                <div v-if="tab == 'tab-3'">
                    <v-card v-for="(contact, id) in getPhoneData.contacts" :key="id" class="latestCall" dark> <!-- Latest Call -->
                        <v-card-title style="padding-top: 7px; font-size: 17px;"><v-icon style="font-size: 20px;" :color="getPhoneData.mainColor">mdi-account</v-icon>‏‏‎ ‎{{ contact.name }}</v-card-title>
                        <v-card-subtitle># {{ contact.number }}</v-card-subtitle>
                        <v-card-actions class="cardActions">
                            <div v-if="editMode"><v-btn text fab color="error"><v-icon>mdi-close</v-icon></v-btn></div>
                            <v-btn text fab :color="getPhoneData.mainColor"><v-icon>mdi-phone</v-icon></v-btn>
                        </v-card-actions>
                    </v-card>
                    <v-btn class="editBtn" fab light :color="getPhoneData.mainColor" @click="editMode = !editMode"><v-icon v-if="!editMode">mdi-pencil</v-icon><v-icon v-if="editMode">mdi-close</v-icon></v-btn>
                    <v-btn v-if="editMode" class="addBtn" fab light :color="getPhoneData.mainColor" @click="addContact = true"><v-icon>mdi-plus</v-icon></v-btn>
                </div>
                <v-slide-y-transition>
                    <v-card class="popupCard" v-if="addContact" dark>
                        <v-card-title>Create New Contact</v-card-title>
                        <v-card-subtitle>Add Contact</v-card-subtitle>
                        <v-card-actions style="margin-top: -20px;">
                            <v-col>
                                <v-text-field outlined dense label="Name" placeholder="Clean Boy" :color="getPhoneData.mainColor"></v-text-field>
                                <v-text-field outlined dense label="Number" placeholder="64554645" :color="getPhoneData.mainColor"></v-text-field>
                                <v-btn outlined block color="success" @click="addContact = false, alert = true">Confirm</v-btn>
                            </v-col>
                        </v-card-actions>
                        <v-icon class="backBtn">mdi-account-box</v-icon>
                        <!--v-btn class="backBtn" icon color="error" @click="addContact = false"><v-icon>mdi-close</v-icon></v-btn-->
                    </v-card>
                    <v-card class="popupCard" v-if="alert" dark>
                        <sweetalert-icon icon="success"></sweetalert-icon>
                    </v-card>
                </v-slide-y-transition>
                <div v-if="addContact || alert" @click="addContact = false" class="bgBlur"></div>
            </div>
        </v-app>
    </div>
</template>

<script>
import moment from 'moment';
import TextHighlight from 'vue-text-highlight';
import SweetalertIcon from 'vue-sweetalert-icons';

export default {
    name: 'CallApp',
    components: {
        TextHighlight,
        SweetalertIcon
    },
    data: () => ({
        tab: null,
        dialInput: "",
        editMode: false,
        addContact: false,
        alert: false,
        latestCalls: [
            {
                callerName: "Mack",
                callerNumber: "5466456546",
                date: 546546454, // Timeago data
                status: "received"
            },
            {
                callerName: "Disc",
                callerNumber: "5466456546",
                date: 546546454,
                status: "sent"
            },
            {
                callerName: null,
                callerNumber: "5466456546",
                date: 546546454,
                status: "received"
            },
            {
                callerName: "Your Mom",
                callerNumber: "5466456546",
                date: 546546454,
                status: "sent"
            }
        ]
    }),
    mounted() {
    },
    watch: {
        alert(new_val){
            if(new_val == true){ setTimeout(()=>{this.alert = false}, 1200); }
        }  
    },
    computed: {
        getPhoneData() {
            const phone = this.$store.state.phoneData;
            if (phone) {
                return phone
            }
            return '';
        }
    },
    methods: {
        currentTime() {
            return moment("20120620", "YYYYMMDD").fromNow(); // TODO: pick message/notification date and calc time from now
        },
        clearDial() {
            this.dialInput = ''
        },
        addDial(value) {
            if (this.dialInput != null) {
                this.dialInput = this.dialInput + value
            } else {
                this.dialInput = '' + value
            }
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
    width: 305px;
    max-width: 305px;
    padding-top: 20px;
}

.appContainer {
    width: 305px;
    max-width: 305px;
    height: 485px;
    max-height: 485px;
    padding-top: 7px;
    padding-left: 7px;
    padding-right: 7px;
    font-size: 17px;
    overflow-y: auto;
}

.latestCalls {
    height: 71px;
    max-height: 71px;
    overflow: auto;
}

.latestCall {
    position: relative;
    top: -7px;
    margin-top: 9px;
    height: 70px !important;

    .cardActions {
        position: absolute;
        top: -1px;
        right: 0px;
    }
}

.dial {
    position: absolute;
    top: 210px;
    left: 55px;
    user-select: none;
}

.dialInput {
    position: relative;
    bottom: -15px;
}

.callBtn {
    position: absolute;
    top: 480px;
    left: 125px;
}

.dialBtn {
    margin: 4px 4px;
    font-size: 23px !important;

    span {
        position: absolute;
        top: 24px;
        font-size: 8px;
    }
}

.editBtn {
    position: absolute;
    top: 490px;
    left: 240px;
}

.addBtn {
    position: absolute;
    top: 490px;
    left: 7px;
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