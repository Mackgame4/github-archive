<template>
    <div class="hudIcon" :class="{ 'flashing': percentage <= 10 }">
        <transition name="fade">
            <v-icon v-if="show" class="innerIcon" :class="getIconClass" :style="getStyling" v-text="icon"></v-icon>
        </transition>
        <transition name="fade">
            <p v-if="showExact && show">{{ percentage }}%</p>
        </transition>
    </div>
</template>



<script>

export default {
    props: {
        percentage: {
            required: true,
            type: Number,
        },
        show: {
            required: false,
            default: true
        },
        icon: {
            required: true,
            type: String,
        },
        colorOverride: {
            required: false,
            default: false,
        },
        emergency: {
            required: false,
            default: false,
        },
        indicator: {
            required: false,
            default: false,
        },
        showExact: {
            required: false,
            default: false,
        }
    },
    data: () => ({
    }),
    mounted() {

    },
    computed: {
        getIconClass() {
            if (this.indicator) {
                return 'indicator';
            }

            if (this.emergency) {
                return 'emergency';
            }

            if (this.colorOverride) {
                return '';
            }

            if (this.percentage >= 75) {
                return 'full';
            } else if (this.percentage >= 45) {
                return 'nearlyfull';
            } else if (this.percentage > 25) {
                return 'nearlylow';
            } else {
                if (this.percentage <= 10) {
                    return 'low flashing';
                } else {
                    return 'low';
                }
            }
        },
        getStyling() {
            let State = {}

            if (this.colorOverride && typeof(this.colorOverride) === 'string') {
                State.color = this.colorOverride;
            }

            return State;
        }
    }
};

</script>

<style scoped lang="less">
@import '@/arp-theme.less';

.hudIcon {
    padding: 0 0.8vw;
    height: 3vh;
    text-align: center;
    font-family: 'Montserrat', sans-serif;
    font-weight: 300;
    text-shadow: 4px 4px 6px rgb(24, 24, 24);
    .innerIcon {
        font-size: 2.5vh;
        transition: .5s;
        &.full {
            color: @full;
        }
        &.nearlyfull {
            color: @nearlyfull;
        }
        &.nearlylow {
            color: @nearlylow;
        }
        &.low {
            color: @low;
        }
        &.flashing {
            animation: flashing linear 1.2s infinite;
        }

        &.indicator {
            animation: indicator linear 1s infinite;
        }
        
        &.emergency {
            animation: ems step-start 1s infinite;
        }
    }

    p {
        left: 110%;
        bottom: 75%;
        position: relative;
        font-size: 1.5vh;
        z-index: 5;
    }
}

@keyframes ems {
    0% {
        color: red,
    }
    50% {
        color: blue,
    }
    100% {
        color: red,
    }
}

@keyframes flashing {
    0% {
        opacity: 1,
    }
    50% {
        opacity: 0.25,
    }
    100% {
        opacity: 1,
    }
}

@keyframes indicator {
    0% {
        opacity: 1,
    }
    50% {
        opacity: 0.1,
    }
    100% {
        opacity: 1,
    }
}

</style>
