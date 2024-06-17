<template>
    <transition name="fade">
        <div v-if="!hide">
            <transition-group class="coolGrid" name="app-transition" :style="bottom > 0 ? `left: ${left}px; bottom: ${bottom}px;` : `left: ${left}px;`">
                <hud-icon key="voice" :percentage="100" :icon="getVoiceIcon" :showLabel="getShouldShowVoiceRange" :labelOverride="getVoiceRange" />
                <!-- eslint-disable -->
                <hud-icon v-for="stat in statIcons" v-if="getStat(stat)" v-bind:key="stat" :percentage="getStat(stat) ? getStat(stat).value : 0" :icon="getStatIcon(stat)" :showLabel="showExact" />
                 <!-- eslint-enable -->
            </transition-group>
        </div>
    </transition>
</template>



<script>

import HudIcon from './HudIcon';

const statIcons = {
    health: 'mdi-heart',
    armour: 'mdi-shield-half-full',
    hunger: 'mdi-food-drumstick',
    thirst: 'mdi-water',
    stress: 'mdi-brain',
    oxygen: 'mdi-chart-bubble',
}

const voiceRanges = [
    'Low',
    'Mid',
    'Loud',
]

export default {
    components: { HudIcon },
    props: {
        hide: {
            required: true
        }
    },
    data: () => ({
        showExact: false,
        showVoiceRange: false,
        statIcons: [
            'health',
            'armour',
            'hunger',
            'thirst',
            'stress',
            'oxygen',
        ],
        bottom: 0,
        left: 0,
    }),
    mounted() {
        setTimeout(() => {
            //this.$root.$emit('showCurrentVoiceRange')
        }, 5000)

        this.$root.$on('dataUpdates', ({ stats }) => {
            //this.$store.commit('updateCharacterStats', stats);
            this.$store.commit('updateCharacterStats', {
                stats,
            });
        });

        this.$root.$on('showCurrentVoiceRange', () => {
            this.showVoiceRange = true;
            setTimeout(() => {
                if (!this.showExact) {
                    this.showVoiceRange = false;
                }
            }, 3500);
        });

        this.$root.$on('updateStatLocation', ({ left, bottom}) => {
            this.left = left;
            this.bottom = bottom;
        });

        this.$root.$on('toggleDetailState', (state) => {
            this.showExact = state;
            this.showVoiceRange = state;
        });
    },
    methods: {
        getStat(stat) {
            return this.$store.getters.getStat(stat);
        },
        getStatIcon(stat) {
            return statIcons[stat];
        }
    },
    computed: {
        getVoiceIcon() {
            if (this.$store.state.voice?.radio) {
                return 'mdi-radio-handheld';
            } else {
                return 'mdi-microphone';
            }
        },
        getShouldShowVoiceRange() {
            if (this.showExact) {
                return true;
            } else if (this.showVoiceRange) {
                return true;
            } else {
                return false;
            }
        },
        getVoiceRange() {
            const voiceRange = this.$store.state.voice?.range;
            return voiceRanges[voiceRange] || 'Mid';
        }
    }
};

</script>

<style scoped lang="less">
@import '@/arp-theme.less';


.coolGrid {
    position: fixed;
    display: flex;
    flex-direction: row;
    //grid-template-columns: repeat(8);
    //left: 0.5vw;
    bottom: 0.75vh;
    width: auto;
    flex-direction: row;
    //transform: translate(-5%, 15%);
}


.app-transition-enter-active {
    animation: app-transition .3s;
}
.app-transition-leave-active {
    animation: app-transition .3s reverse;
}

@keyframes app-transition {
    0% {
        transform: scale(0);
    }
    100% {
        transform: scale(1);
    }
}

</style>
