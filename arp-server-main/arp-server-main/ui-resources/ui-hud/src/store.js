import Vue from 'vue'
import Vuex from 'vuex'
import Nui from './utils/Nui';

Vue.use(Vuex)

const allStatTypes = [ 'health', 'hunger', 'thirst', 'oxygen', 'stress', 'armour' ];
const normalStatTypes = [ 'health', 'hunger', 'thirst' ];
const specialStatTypes = [ 'oxygen', 'stress', 'armour' ];

const defaultStats = {
    health: 75,
    hunger: 50,
    thirst: 50,
}

const defaultSStats = {
    stress: false,
    armour: false,
    oxygen: false,
}

export default new Vuex.Store({
    state: {
        stats: {
            health: 100,
            armour: 0,
            hunger: 40,
            thirst: 100,
            stress: 100,
            oxygen: 100,
        },
        ped: {
            swimming: false,
        },
        voiceData: {
            speaking: false,
            range: 1,
            radio: false,
            radioSpeaking: false,
        },
        hudSettings: {
            stats: {
                health: 75,
                hunger: 45,
                thirst: 45,
            },
            hiddenStats: {
                stress: false,
                armour: false,
                oxygen: false,
            },
            hideAnatomy: 2,
            hideLocation: false,
            hideMinimap: false,
            speedoDriver: true,
            speedoPassenger: true,
        }
    },
    mutations: {
        updateHUDSettings(state, payload) {

            // Normal Stat Types
            if (payload.stats && typeof(payload.stats) === 'object') {
                for (const statType in payload.stats) {
                    if (normalStatTypes.includes(statType)) {
                        if (isStatValid(payload.stats[statType])) {
                            state.hudSettings.stats[statType] = payload.stats[statType];
                        } else {
                            state.hudSettings.stats[statType] = defaultStats[statType];
                        }
                    }
                }
            } else {
                state.hudSettings.stats = defaultStats;
            }

            // Special Stat Types

            if (payload.hiddenStats && typeof(payload.hiddenStats) === 'object') {
                for (const statType in payload.hiddenStats) {
                    if (specialStatTypes.includes(statType)) {
                        state.hudSettings.hiddenStats[statType] = payload.hiddenStats[statType];
                    }
                }
            } else {
                state.hudSettings.hiddenStats = defaultSStats;
            }

            // Location

            if (typeof(payload.hideLocation) === 'boolean') {
                state.hudSettings.hideLocation = payload.hideLocation;
            } else {
                state.hudSettings.hideLocation = false;
            }

            if (typeof(payload.hideMinimap) === 'boolean') {
                state.hudSettings.hideMinimap = payload.hideMinimap;
            } else {
                state.hudSettings.hideMinimap = false;
            }

            if (typeof(payload.speedoDriver) === 'boolean') {
                state.hudSettings.speedoDriver = payload.speedoDriver;
            } else {
                state.hudSettings.speedoDriver = true;
            }

            if (typeof(payload.speedoPassenger) === 'boolean') {
                state.hudSettings.speedoPassenger = payload.speedoPassenger;
            } else {
                state.hudSettings.speedoPassenger = true;
            }

            if (typeof(payload.hideAnatomy) === 'number' && payload.hideAnatomy >= 0 && payload.hideAnatomy <= 5) {
                state.hudSettings.hideAnatomy = payload.hideAnatomy;
            } else {
                state.hudSettings.hideAnatomy = 2;
            }
        },
        updateCharacterStats(state, payload) {
            const newStats = payload.stats;
            for (const stat of allStatTypes) {
                if (isStatValid(newStats[stat])) {
                    state.stats[stat] = newStats[stat];
                }
            }
        }
    },
    actions: {
        async saveHUDSettings({ commit }, payload) {
            console.log(payload)
            await Nui.send('saveHUD', payload);
            commit('updateHUDSettings', payload);
            return true;
        }
    },
    getters: {
        getHUDSettings(state) {
            return JSON.parse(JSON.stringify(state.hudSettings));
        },
        getStat: (state) => (data) => {
            if (data && typeof(data) === 'string') {
                const statPercentage = state.stats[data];
                if (typeof(statPercentage) === 'number') {
                    if (normalStatTypes.includes(data)) {
                        const statSetting = state.hudSettings.stats[data];
                        if (statPercentage <= statSetting) {
                            return {
                                showing: true,
                                value: statPercentage,
                            }
                        }
                    } else if (data === 'armour') {
                        if (statPercentage > 0 && !state.hudSettings.hiddenStats.armour) {
                            return {
                                showing: true,
                                value: statPercentage,
                            }
                        }
                    } else if (data === 'stress') {
                        if (statPercentage <= 25 && !state.hudSettings.hiddenStats.stress) {
                            return {
                                showing: true,
                                value: statPercentage,
                            }
                        }
                    } else if (data === 'oxygen') {
                        if (state.ped.swimming && !state.hudSettings.hiddenStats.oxygen) {
                            return {
                                showing: true,
                                value: statPercentage,
                            }
                        }
                    }
                }
            }
            return false;
        },
    }
})


const isStatValid = (stat) => {
    if (typeof(stat) === 'number' && stat >= 0 && stat <= 100) {
        return true;
    } else return false;
}