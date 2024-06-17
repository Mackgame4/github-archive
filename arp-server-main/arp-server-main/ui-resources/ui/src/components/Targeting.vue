<template>
    <transition name="fade">
        <div v-if="show">
            <div class="targetIcon main" v-bind:class="icon && 'colored'"><i class="far fa-circle"></i></div>
            <div class="targetIcon second">
                <v-icon v-if="iconType" class="arpmdi">{{ icon }}</v-icon>
                <i v-else v-bind:class="icon"></i>
            </div>
        </div>
    </transition>
</template>

<script>

export default {
    name: 'Targeting',
    data: () => ({
        show: false,
        icon: false
    }),
    mounted() {
        this.$root.$on('targetingShow', () => {
            this.show = true;
            this.icon = false;
        })
        this.$root.$on('targetingHide', () => {
            this.show = false;
            this.icon = false;
        })
        this.$root.$on('targetingHit', (icon) => {
            this.icon = icon;
        })
        this.$root.$on('targetingUnHit', () => {
            this.icon = false;
        })
    },
    computed: {
        iconType() {
            if (this.icon && typeof(this.icon) == 'string' && this.icon.startsWith('mdi')) {
                return true;
            } else return false;
        }
    }
};

</script>

<style scoped lang="less">
@import '@/arp-theme.less';

.targetIcon {
    position: fixed;
    left: 25vw;
    top: 25vh;
    width: 50vw;
    height: 50vh;
    display: flex;
    justify-content: center;
    align-items: center;
    transition: all .1s ease-in-out; 
    font-size: 3vh;
    -webkit-font-smoothing: antialiased;
    -moz-osx-font-smoothing: grayscale;
}

.colored {
    color: @red2;
    transform: scale(1.4);
}

.second {
    font-size: 1.3vh;
}

.arpmdi {
    font-size: 1.8vh;
}

</style>
