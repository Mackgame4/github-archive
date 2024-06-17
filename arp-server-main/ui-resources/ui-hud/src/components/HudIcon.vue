<template>
    <div class="hudIcon" :class="{ 'flashing': percentage <= 10 }">
        <v-icon class="innerIcon" :class="getIconClass" :style="getStyling" v-text="icon"></v-icon>
        <transition name="fade">
            <p v-if="showLabel">{{ labelOverride ? labelOverride : `${percentage}%` }}</p>
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
        icon: {
            required: true,
            type: String,
        },
        iconSize: {
            required: false,
            default: 6,
            type: Number,
        },
        colorOverride: {
            required: false,
            default: false,
        },
        showLabel: {
            required: true,
            type: Boolean,
        },
        labelOverride: {
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
    padding: 0 0.5vw;
    height: 6vh;


    text-align: center;
    font-family: 'Montserrat', sans-serif;
    font-weight: 300;
    text-shadow: 4px 4px 6px rgb(24, 24, 24);
    .innerIcon {
        font-size: 3.5vh;
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
    }

    p {
        margin: 0;
        margin-top: 0.25vh;
        font-size: 1.5vh;
        overflow: show;
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

</style>
