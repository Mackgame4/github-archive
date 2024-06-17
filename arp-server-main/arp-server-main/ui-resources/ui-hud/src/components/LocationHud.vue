
<template>
    <transition name="fade">
            <div class="locationContainer" v-if="!hide && shouldShow && canShow">
                <div class="direction">
                    <p>{{ compass }}</p>
                </div>
                <v-divider vertical inset></v-divider>
                <div class="street">
                    <p class="main">{{ street }}</p>
                    <p>{{ intersection ? `${intersection}, ` : '' }} {{ zone }}</p>
                </div>
            </div>
    </transition>
</template>



<script>

export default {
    components: { },
    props: {
        hide: {
            required: true
        }
    },
    data: () => ({
        compass: 'N',
        street: 'Hawick Ave',
        intersection: 'Las Lagunas Blvd',
        zone: 'Los Santos',
        canShow: false,
    }),
    mounted() {
        this.$root.$on('dataUpdates', ({ location }) => {
            this.street = location.street;
            this.intersection = location.intersection;
            this.compass = location.compass;
            this.zone = location.zone;
            this.canShow = location.canShow;
        });
    },
    methods: {

    },
    computed: {
        shouldShow() {
            return !this.$store.getters.getHUDSettings.hideLocation;
        }
    }
};

</script>

<style scoped lang="less">
@import '@/arp-theme.less';

.locationContainer {
    position: fixed;
    width: 20vw;
    height: 6vh;
    top: 0.25vh;
    left: 50vw;
    display: flex;
    flex-direction: row;
    //background: @dark;
    font-family: 'Montserrat', sans-serif;
    font-weight: 300;
    text-align: center;
    transform: translateX(-50%);
    //color: #c2c2c2;
    user-select: none;

    text-shadow: 3px 3px 4px rgb(24, 24, 24);

    -webkit-font-smoothing: antialiased;
    -moz-osx-font-smoothing: grayscale;

    .direction {
        height: 100%;
        width: 18%;
        padding: 0.25vh 0;
        p {
            height: 100%;
            margin: 0;
            font-size: 4vh;
        }
    }
    .street {
        text-align: left;
        padding: 0.5vh 0.85vw;
        height: 100%;
        width: 72%;
        p {
            //opacity: 65%;
            color: rgb(206, 206, 206);
            margin: 0;
            font-size: 1.5vh;
            line-height: 3vh;
            word-break: keep-all;
            white-space: nowrap;
            overflow: visible;
            text-overflow: clip;
        }
        .main {
            color: white;
            //opacity: 85%;
            font-size: 2.4vh;
            line-height: 2.5vh;
        }
    }
}

</style>
