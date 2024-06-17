<template>

        <transition name="fade">
            <v-card v-if="showing" class="hoverCard" :style="getPosition" elevation="5">
                    <v-card-title v-if="cardTitle" v-text="cardTitle"></v-card-title>
                    <v-card-subtitle v-if="cardSubtitle" v-html="cardSubtitle"></v-card-subtitle>
                    <v-card-text v-if="cardText" v-html="cardText"></v-card-text>
            </v-card>
        </transition>

</template>

<script>

//import Nui from '../../utils/Nui';


export default {
    name: 'InteractHover',
    data() {
        return {
            showing: false,
            x: 1500,
            y: 500,

            cardTitle: false,
            cardSubtitle: false,
            cardText: false,
            listener: false,
        };
    },
    computed: {
        getPosition() {
            return { position: `fixed !important`, left: `${this.x}px`, top: `${this.y}px`, transform: 'translate(-50%, -50%)' }
        }
    },
    methods: {

    },
    mounted() {
        
        this.$root.$on('hoverInteraction', (data) => {
            if (data) {
                this.cardTitle = data.title;
                this.x = data.x;
                this.y = data.y;
                if (data.subtitle) { this.cardSubtitle = data.subtitle }
                this.cardText = data.text;
                this.showing = true;
            } else {
                if (this.showing) {
                    this.showing = false;
                    this.cardTitle = false;
                    this.cardSubtitle = false;
                    this.cardText = false;
                }
            }
        })

        //this.$root.$emit('hoverInteraction', {
        //    x: 781.5,
        //    y: 500,
        //    title: 'cunt'
        //})
    },
};

</script>

<style scoped lang="less">
@import '@/arp-theme.less';
</style>
