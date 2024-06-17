
<template>
<transition name="fade">
    <v-card class="settingsContainer" v-if="open">
        <v-tabs 
            fixed-tabs 
            show-arrows 
            dark 
            v-model="menu" 
            class="tabs" 
            color="red darken-4"
            next-icon="mdi-arrow-right-bold-box-outline"
            prev-icon="mdi-arrow-left-bold-box-outline"
        >
            <v-tab>
                Recent Disconnects
            </v-tab>
            <v-tab>
                General Settings
            </v-tab>
            <v-tab>
                HUD Settings
            </v-tab>
            <v-tab v-if="isStaff">
                Staff - Players
            </v-tab>
        </v-tabs>
        <v-tabs-items v-model="menu">
            <v-tab-item>
                <div class="content pl">
                    <h2>Recent Disconnects</h2>
                    <div class="playerListingContainer">
                        <div class="playerList">
                            <div class="player" v-if="recentDisconnects.length === 0">
                                No Recent Disconnects
                            </div>
                            <div class="player" v-for="p in recentDisconnects" :key="p.source">
                                [<b>{{ p.SID }}</b>] {{ p.name }} - 
                                Server ID: <b>{{ p.source }}</b><br>
                            </div>
                        </div>
                        <!-- <div class="playerAction">

                        </div> -->
                    </div>
                </div>
            </v-tab-item>
            <v-tab-item>
                <div class="content">
                    <h2>Voice Settings</h2>
                </div>
            </v-tab-item>
            <v-tab-item>
                <div class="content">
                    <h2>Display Modes</h2>
                    <div class="statSetting">
                        <v-checkbox v-model="getCinematicMode" :disabled="hideHUD && !cinematic" color="red darken-4" label="Cinematic Mode (Black Bars)"></v-checkbox>
                        <v-spacer></v-spacer>
                        <v-checkbox v-model="getHiddenMode" :disabled="cinematic" color="red darken-4" label="Hide All Hud Elements"></v-checkbox>
                        <v-spacer></v-spacer>
                    </div>
                    <v-divider></v-divider><br>
                    <h2>Character Stats</h2>
                    <h5>Settings Regarding the Character Stat Icons.</h5>
                    <div class="statSetting">
                        <v-checkbox v-model="getHUDHealthCheckbox" class="statCheckBox" color="red darken-4" label="Show Health"></v-checkbox>
                        <v-spacer></v-spacer>
                        <v-slider v-model.number="hud.stats.health" :disabled="hud.stats.health === 0" min="0" step="5" thumb-label color="red darken-4" :label="hud.stats.health > 0 ? `Reveal Below ${hud.stats.health}%` : 'Never Reveal'" class="statSlider" :hint="statHideMessage" persistent-hint></v-slider>
                    </div>
                    <div class="statSetting stats">
                        <v-checkbox v-model="getHUDHungerCheckbox" class="statCheckBox" color="red darken-4" label="Show Hunger"></v-checkbox>
                        <v-spacer></v-spacer>
                        <v-slider v-model.number="hud.stats.hunger" :disabled="hud.stats.hunger === 0" min="0" step="5" thumb-label color="red darken-4" :label="hud.stats.hunger > 0 ? `Reveal Below ${hud.stats.hunger}%` : 'Never Reveal'" class="statSlider" :hint="statHideMessage" persistent-hint></v-slider>
                    </div>
                    <div class="statSetting stats">
                        <v-checkbox v-model="getHUDThirstCheckbox" class="statCheckBox" color="red darken-4" label="Show Thirst"></v-checkbox>
                        <v-spacer></v-spacer>
                        <v-slider v-model.number="hud.stats.thirst" :disabled="hud.stats.thirst === 0" min="0" step="5" thumb-label color="red darken-4" :label="hud.stats.thirst > 0 ? `Reveal Below ${hud.stats.thirst}%` : 'Never Reveal'" class="statSlider" :hint="statHideMessage" persistent-hint></v-slider>
                    </div>
                    <div class="statSetting stats">
                        <v-checkbox v-model="hud.hiddenStats.armour" color="red darken-4" label="Never Show Armour"></v-checkbox>
                        <v-spacer></v-spacer>
                        <v-checkbox v-model="hud.hiddenStats.stress" color="red darken-4" label="Never Show Stress"></v-checkbox>
                        <v-spacer></v-spacer>
                    </div>
                    <v-checkbox v-model="hud.hiddenStats.oxygen" color="red darken-4" label="Never Show Oxygen"></v-checkbox>
                    
                    <v-divider></v-divider><br>
                    <h2>Character Damage Skeleton / Anatomy Indicator</h2>
                    <!-- <div class="statSetting">
                        <v-checkbox v-model="hud.speedoDriver" color="red darken-4" label="Show As Driver"></v-checkbox>
                        <v-spacer></v-spacer>
                        <v-checkbox v-model="hud.speedoPassenger" color="red darken-4" label="Show As Passenger" persistent-hint hint="Will improve performance when hidden"></v-checkbox>
                        <v-spacer></v-spacer>
                    </div> -->
                    <div class="statSetting stats">
                        <v-slider v-model.number="hud.hideAnatomy" min="0" max="5" step="1" thumb-label color="red darken-4" :label="getAnatomyLabel" class="statSlider" hint="The level at which a limbs damage must be at before showing the diagram." persistent-hint></v-slider>
                    </div>
                    <br><v-divider></v-divider><br>
                    <h2>Vehicle</h2>
                    <div class="statSetting">
                        <v-checkbox v-model="hud.speedoDriver" color="red darken-4" label="Show As Driver"></v-checkbox>
                        <v-spacer></v-spacer>
                        <v-checkbox v-model="hud.speedoPassenger" color="red darken-4" label="Show As Passenger" persistent-hint hint="Will improve performance when hidden"></v-checkbox>
                        <v-spacer></v-spacer>
                    </div>
                    <br><v-divider></v-divider><br>
                    <h2>Location, Map & Direction</h2>
                    <v-checkbox v-model="hud.hideLocation" color="red darken-4" label="Always Hide Location Display" persistent-hint hint="Will improve performance when hidden"></v-checkbox>
                    <v-checkbox v-model="hud.hideMinimap" color="red darken-4" label="Always Hide Minimap"></v-checkbox>
                </div>
            </v-tab-item>
            <v-tab-item>
                <div class="content pl" v-if="staffPlayerData && staffPlayerData.players">
                    <h2>Staff - Player Actions</h2>
                    <div class="statSetting">
                        <div>
                            <h4>Total Players: <b>{{staffPlayerData.total}}</b></h4>
                            <h4>Total Staff: <b>{{staffPlayerData.totalStaff}}</b></h4>
                        </div>
                        <v-spacer></v-spacer>
                        <div>
                            <h4>PD: <b>0</b></h4>
                            <h4>EMS: <b>0</b></h4>
                            <h4>DOC: <b>0</b></h4>
                        </div>
                        <v-spacer></v-spacer>
                        <div>
                            <h4>Doctors: <b>0</b></h4>
                            <h4>DOJ: <b>0</b></h4>
                            <h4>DA: <b>0</b></h4>
                        </div>
                        <v-spacer></v-spacer>
                    </div>
                    <div class="playerListingContainer">
                        <div class="playerList staff">
                            <div class="player" :class="{ selected: staffPlayerSelected === 0 }" @click="staffPlayerSelected = 0">
                                Everyone
                            </div>
                            <div class="player" v-for="p in staffPlayerData.players" :key="p.source" :class="{ selected: staffPlayerSelected === p.source }" @click="staffPlayerSelected = p.source">
                                <span v-if="p.staff">[<b>Staff</b>]</span>
                                [<b>{{ p.SID }}</b>] {{ p.name }} - 
                                Server ID: <b>{{ p.source }}</b><br>
                            </div>
                        </div>
                        <div class="playerAction" v-if="staffPlayerSelected === 0">
                            <h2 class="text-center">Global Actions</h2>
                            <div class="buttonGrid">
                                <v-btn color="ma-1 red darken-4" @click="executeCommand('kill *')">Kill All</v-btn>
                                <v-btn color="ma-1 green darken-2" @click="executeCommand('revive *')">Revive All</v-btn>
                            </div>
                        </div>
                        <div class="playerAction" v-if="staffPlayerSelected > 0 && staffCurrentGetPlayerDataForSource">
                            <div class="statSetting sticky">
                                <div style="width: 30%;">
                                    <img class="pfp" v-if="staffCurrentGetPlayerDataForSource.avatar" :src="staffCurrentGetPlayerDataForSource.avatar">
                                </div>
                                <v-spacer></v-spacer>
                                <div>
                                    <h2 class="text-center">{{staffCurrentGetPlayerDataForSource.name}} [{{ staffCurrentGetPlayerDataForSource.SID }}]</h2>
                                    <h5 class="text-center">{{ staffCurrentGetPlayerDataForSource.url }}</h5>
                                </div>
                                <v-spacer></v-spacer>
                            </div>
                            
                            <div class="buttonGrid">
                                <v-btn color="ma-1 grey darken-1" @click="clipboardCopy(staffCurrentGetPlayerDataForSource.steam)">Copy Steam</v-btn>
                                <v-btn color="ma-1 grey darken-1" @click="clipboardCopy(staffCurrentGetPlayerDataForSource.url)">Copy URL</v-btn>
                                <v-btn color="ma-1 red darken-4" @click="executeCommand(`kick ${staffCurrentGetPlayerDataForSource.source}`)">Kick</v-btn>
                            </div>

                            <div class="statSetting">
                                <div>
                                    <h4>Name: <b>{{staffCurrentGetPlayerDataForSource.name}}</b></h4>
                                    <h4>Steam: <b>{{staffCurrentGetPlayerDataForSource.steam}}</b></h4>
                                    <h4>Staff: <b>{{ staffCurrentGetPlayerDataForSource.staff ? 'Yes' : 'No' }}</b></h4>
                                    <h4>Session: <b>{{ getSecondsToReadable(staffCurrentGetPlayerDataForSource.sessionTime) }}</b></h4>
                                </div>
                                <v-spacer></v-spacer>
                                <div>
                                    <h4>SID: <b>{{staffCurrentGetPlayerDataForSource.SID}}</b></h4>
                                    <h4>Server ID/Source: <b>{{staffCurrentGetPlayerDataForSource.source}}</b></h4>
                                    <h4>Staff Level: <b>{{ staffCurrentGetPlayerDataForSource.staffLevel }}</b></h4>
                                    <h4>Total Playtime: <b>{{ getSecondsToReadable(staffCurrentGetPlayerDataForSource.totalTime) }}</b></h4>
                                </div>
                            </div>
                            <br>

                            <h2 v-if="staffCurrentGetPlayerDataForSource.character">Character: {{ staffCurrentGetPlayerDataForSource.character.name }}</h2>
                            <h2 v-else>Character: Not Selected</h2>

                            <div class="statSetting" v-if="staffCurrentGetPlayerDataForSource.character">
                                <div>
                                    <h4>Name: <b>{{ staffCurrentGetPlayerDataForSource.character.name }}</b></h4>
                                    <h4>Dead: <b>{{ staffCurrentGetPlayerDataForSource.character.dead ? 'Yes' : 'No' }}</b></h4>
                                </div>
                                <v-spacer></v-spacer>
                                <div>
                                    <h4>CID: <b>{{ staffCurrentGetPlayerDataForSource.character.CID }}</b></h4>
                                    <h4>Health: <b>{{ staffCurrentGetPlayerDataForSource.character.health }}%</b></h4>
                                </div>
                                <v-spacer></v-spacer>
                            </div>
                            <div class="buttonGrid" v-if="staffCurrentGetPlayerDataForSource.character">
                                <v-btn color="ma-1 grey darken-1" @click="executeCommand(`goto ${staffCurrentGetPlayerDataForSource.source}`)">Goto</v-btn>
                                <v-btn color="ma-1 grey darken-1" @click="executeCommand(`bring ${staffCurrentGetPlayerDataForSource.source}`)">Bring</v-btn>
                                <v-btn color="ma-1 grey darken-1" @click="executeCommand(`attach ${staffCurrentGetPlayerDataForSource.source}`)">Attach To</v-btn>
                                <v-btn color="ma-1 green darken-2" @click="executeCommand(`revive ${staffCurrentGetPlayerDataForSource.source}`)">Revive</v-btn>
                                <v-btn color="ma-1 red darken-4" @click="executeCommand(`kill ${staffCurrentGetPlayerDataForSource.source}`)">Kill</v-btn>
                            </div>
                            <br>
                            <h2 v-if="staffCurrentGetPlayerDataForSource.vehicle && staffCurrentGetPlayerDataForSource.vehicle.inside">Inside Vehicle: {{ staffCurrentGetPlayerDataForSource.vehicle.VIN }}</h2>
                            <h2 v-else-if="staffCurrentGetPlayerDataForSource.vehicle && !staffCurrentGetPlayerDataForSource.vehicle.inside">Last Vehicle: {{ staffCurrentGetPlayerDataForSource.vehicle.VIN }}</h2>
                            <h2 v-else>Vehicle: N/A</h2>
                            <div class="statSetting" v-if="staffCurrentGetPlayerDataForSource.vehicle">
                                <div>
                                    <h4>Vehicle ID: <b>{{ staffCurrentGetPlayerDataForSource.vehicle.id }}</b></h4>
                                    <h4>VIN: <b>{{ staffCurrentGetPlayerDataForSource.vehicle.VIN }}</b></h4>
                                </div>
                                <v-spacer></v-spacer>
                                <div>
                                    <h4>Inside: <b>{{ staffCurrentGetPlayerDataForSource.vehicle.inside ? 'Yes' : 'No' }}</b></h4>
                                    <h4>Plate: <b>{{ staffCurrentGetPlayerDataForSource.vehicle.plate }}</b></h4>
                                </div>
                                <v-spacer></v-spacer>
                            </div>
                            <div class="buttonGrid" v-if="staffCurrentGetPlayerDataForSource.vehicle && staffCurrentGetPlayerDataForSource.vehicle.inside">
                                <v-btn color="ma-1 green darken-2" @click="executeCommand(`playerrepairveh ${staffCurrentGetPlayerDataForSource.source}`)">Repair</v-btn>
                                <v-btn color="ma-1 red darken-4" @click="executeCommand(`playerbreakveh ${staffCurrentGetPlayerDataForSource.source}`)">Break</v-btn>
                                <!-- <v-btn color="ma-1 red darken-4" @click="executeCommand(`playerexplodeveh ${staffCurrentGetPlayerDataForSource.source}`)">Explode</v-btn> -->
                                <v-btn color="ma-1 green darken-2" @click="executeCommand(`playergrantveh ${staffCurrentGetPlayerDataForSource.source}`)">Grant Keys</v-btn>
                                <v-btn color="ma-1 red darken-4" @click="executeCommand(`playerejectveh ${staffCurrentGetPlayerDataForSource.source}`)">Force Out</v-btn>
                            </div>
                        </div>
                    </div>
                </div>
            </v-tab-item>
        </v-tabs-items>
        <div class="footer">
            <v-btn color="grey" @click="closeSettings">Close</v-btn>
            <v-spacer></v-spacer>
            <v-btn color="green" v-if="menu === 2" @click="saveHUD">Save HUD Settings</v-btn>
            <v-btn color="green" v-if="menu === 3" @click="refreshPlayerData">Refresh Data</v-btn>
        </div>
    </v-card>
</transition>
</template>



<script>
import Nui from '../utils/Nui';
import moment from 'moment';

const painLevels = {
    1: 'Uncomfortable',
    2: 'Quite Painful',
    3: 'Really Painful',
    4: 'Unbearably Painful',
}

export default {
    components: { },
    props: {
        open: {
            required: true,
        },
        cinematic: {
            required: true,
        },
        hideHUD: {
            required: true,
        }
    },
    data: () => ({
        settingsOpen: false,
        menu: 0,
        checkbox: false,
        statHideMessage: 'The icon will only show below this %, putting 100% will never hide the icon.',
        hud: {
            stats: {
                health: 0,
                hunger: 75,
                thirst: 75,
            },
            hiddenStats: {
                stress: false,
                armour: false,
                oxygen: false,
            },
            hideLocation: false,
            hideMinimap: false,
            speedoDriver: true,
            speedoPassenger: true,
        },
        isStaff: true,
        recentDisconnects: [],
        staffPlayerSelected: 0,
        staffPlayerData: {
            total: 0,
            totalStaff: 0,
            players: []
        }
    }),
    methods: {
        getStatCheckboxState(stat) {
            return this.hud[stat] === 0;
        },
        refreshHUDSettings() {
            const settings = this.$store.getters.getHUDSettings;
            this.hud = settings;
        },
        closeSettings() {
            Nui.send('startClosingSettings');
        },
        async saveHUD() {
            await this.$store.dispatch('saveHUDSettings', this.hud);
            this.refreshHUDSettings();
        },
        getSecondsToReadable(seconds) {
            return moment.duration(seconds, 'seconds').humanize();
        },
        executeCommand(commandString) {
            Nui.send('staffExecuteCommand', commandString);
        },
        clipboardCopy(copyString) {
            Nui.send('clipboardCopy', copyString);
        },
        refreshPlayerData() {
            Nui.send('requestPlayerDataUpdate', {});
        }
    },
    mounted() {
        this.refreshHUDSettings();

        this.$root.$on('updatePlayerData', ({ recentDisconnects, isStaff, staffPlayerData }) => {
            this.isStaff = isStaff;
            this.recentDisconnects = recentDisconnects;
            this.staffPlayerData = staffPlayerData;
        });
    },
    computed: {
        getHUDHealthCheckbox: {
            get() {
                return this.hud.stats.health > 0;
            },
            set(val) {
                if (val) {
                    this.hud.stats.health = 75;
                } else {
                    this.hud.stats.health = 0;
                }
            } 
        },
        getHUDHungerCheckbox: {
            get() {
                return this.hud.stats.hunger > 0;
            },
            set(val) {
                if (val) {
                    this.hud.stats.hunger = 75;
                } else {
                    this.hud.stats.hunger = 0;
                }
            } 
        },
        getHUDThirstCheckbox: {
            get() {
                return this.hud.stats.thirst > 0;
            },
            set(val) {
                if (val) {
                    this.hud.stats.thirst = 75;
                } else {
                    this.hud.stats.thirst = 0;
                }
            } 
        },
        getCinematicMode: {
            get() {
                return this.cinematic;
            },
            set(val) {
                Nui.send('toggleCinematic', val)
            }
        },
        getHiddenMode: {
            get() {
                return this.hideHUD;
            },
            set(val) {
                Nui.send('toggleHidden', val)
            }
        },
        getAnatomyLabel() {
            if (this.hud.hideAnatomy === 0) {
                return 'Always Show Damage';
            } else if (this.hud.hideAnatomy === 5) {
                return 'Never Show Damage';
            } else {
                return `Show When ${painLevels[this.hud.hideAnatomy]}`;
            }
        },
        staffCurrentGetPlayerDataForSource() {
            return this.staffPlayerData?.players?.find(p => p.source === this.staffPlayerSelected);
        }
    },
    watch: {
        menu(newVal) {
            if (newVal === 2) {
                this.refreshHUDSettings();
            }
            this.staffPlayerSelected = 0;
        }
    }
};

</script>

<style scoped lang="less">
@import '@/arp-theme.less';
.settingsContainer {
    position: fixed;
    font-family: 'Roboto', sans-serif;
    width: 70vw;
    left: 15vw;
    top: 10vh;
    .content {
        display: block;
        min-height: 30vh;
        max-height: 65vh;
        padding: 1vh 1.5vw;
        overflow-y: auto;
        h1 {
            font-weight: 400;
        }
        h2 {
            font-size: 1.5rem;
            font-weight: 300;
            color: rgb(235, 235, 235);
        }
        h4 {
            font-weight: 400;
        }
        h5 {
            color: rgb(175, 175, 175);
            font-weight: 400;
        }

        //&.pl {
        //    overflow-y: hidden;
        //}

        .playerListingContainer {
            width: 100%;
            display: flex;
            flex-direction: row;
        }

        .playerList {
            height: 50vh;
            width: 100%;
            padding: .75vh;
            overflow-y: auto;
            display: flex;
            flex-direction: column;
            .player {
                background: #455A64;
                padding: .75vh;
                border-radius: .5vh;
                border: 1.5px solid @medium;
                margin: .5vh 0;
                user-select: none;
                cursor: pointer;
                &.selected {
                    border: 1.5px solid @light;
                    background: #37474F; // blue-grey darken-3
                }
                &:hover {
                    border: 1.5px solid @light;
                }
            }
            &.staff {
                height: 45vh;
            }
        }
        .playerAction {
            width: 100%;
            height: 45vh;
            padding: 1vh 1vw;
            overflow-y: auto;
            .pfp {
                display: block;
                margin-left: auto;
                margin-right: auto;
                height: 8vh;
                border-radius: 0.5vh;
            }
            .buttonGrid {
                display: grid;
                grid-template-columns: repeat(3, 33.3%);
                padding: 1vh 0;
            }
        }
    }
    .statSetting {
        display: flex;
        flex-direction: row;
        width: 100%;
        .statCheckBox {
            margin: 0;
            width: 20%;
        }
        .statInput {
            align-self: flex-end;
        }
        margin-top: 0.8vh;
        &.outer {
            margin-top: 0;
            padding: 1vh 2vw;
        }

        &.stats {
            margin-top: 1.3vh;
        }
    }
    .footer {
        display: flex;
        flex-direction: row;
        width: 100%;
        padding: 1vh 1vw;
    }
}


</style>
