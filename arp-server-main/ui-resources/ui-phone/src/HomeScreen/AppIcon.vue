<template>
    <div class="app">
        <p v-if="showName">{{ currentApp.name }}</p>
        <div class="iconOuter">
            <div class="icon" :style="iconStyle" @click="openApp">
                <v-icon class="iconInner" :color="iconColour">{{ currentApp.icon.icon }}</v-icon>
            </div>
        </div>
    </div>
</template>

<script>
//import Nui from '../../utils/Nui';
import { Apps } from '../appConfig';

export default {
    name: 'AppIcon',
    components: {

    },
    data: () => ({

    }),
    props: {
        app: {
            required: false,
            default: false,
        },
        custom: {
            required: false,
            default: false,
        },
        showName: {
            required: false,
            default: true,
            type: Boolean,
        },
        noAction: {
            required: false,
            default: false,
            type: Boolean,
        }
    },
    methods: {
        openApp() {
            if (!this.noAction) {
                this.$root.$emit('openApp', { app: this.app });
            }
        }
    },
    computed: {
        iconStyle() {
            return {
                background: `${this.currentApp.icon.colour}`
            }
        },
        iconColour() {
            if (this.currentApp.icon.iconColour) {
                return this.currentApp.icon.iconColour;
            }
            return '';
        },
        iconSize() {
            if (this.currentApp.icon.iconSize) {
                return this.currentApp.icon.iconSize;
            }
            return 26;
        },
        currentApp() {
            if (this.app) {
                return Apps[this.app];
            } else {
                return this.custom;
            }
        }
    },
    mounted() {
        console.log(this.app)
    }
};

</script>

<style scoped lang="less">
@import '@/arp-theme.less';



.app {
    display: flex;
    flex-direction: column-reverse;
    .iconOuter {
        height: 65%;
        margin: 0;
        padding: 10% 14%;
        .icon {
            width: 100%;
            height: 100%;
            box-shadow: 1.5px 1.5px 5px 1.5px rgba(0, 0, 0, 0.392);
            //clip-path: url(#squircleClip);
            border-radius: 15px;
            background: @darker;
            transition: .25s;
            text-align: center;
            &:hover {
                filter: brightness(75%);
            }
            .iconInner {
                width: 100%; 
                height: 100%;
                font-size: calc(30px * var(--resize-percentage));
            }
        } 
    }
    p {
        height: 35%;
        margin: 0;
        text-align: center;
        font-size: calc(0.75rem * var(--resize-percentage));
        user-select: none;
        //overflow: hidden;
        //text-overflow: ellipsis;
        -webkit-hyphens: auto;
        hyphens: auto;
    }
}


</style>