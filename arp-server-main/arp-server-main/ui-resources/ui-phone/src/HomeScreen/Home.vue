<template>
    <div class="home">
        <div class="appGrid">
            <!-- eslint-disable vue/no-use-v-if-with-v-for -->
            <AppIcon v-for="app in drawerApplications" v-bind:key="app" v-bind:app="app" />
            <!-- eslint-enable vue/no-use-v-if-with-v-for -->
        </div>
    </div>
</template>

<script>
//import Nui from '../../utils/Nui';
import AppIcon from './AppIcon';
import { AppsList } from '../appConfig';

export default {
    name: 'HomeScreen',
    components: {
        AppIcon,
    },
    data: () => ({
        drawerApplications: AppsList,
        withinAppArea: false,
        mouseX: 0,
        mouseY: 0,
    }),
    props: {},
    methods: {
        
    },
    computed: {
        hoveredAppStyle() {
            return {
                left: `${this.mouseX}px`,
                top: `${this.mouseY}px`,
            }
        }
    },
    created() {
        window.addEventListener('mousemove', (e) => {
            if (this.withinAppArea) {
                this.mouseX = e.clientX;
                this.mouseY = e.clientY;
            }
        });
    },
    mounted() {
        console.log(this.applications)
    }
};

</script>

<style scoped lang="less">
@import '@/arp-theme.less';

.home {
    height: 95.5%;
    width: 100%;
    overflow: hidden;
    .appGrid {
        height: 100%;
        display: grid;
        grid-template-columns: repeat(5, 20%);
        grid-template-rows: repeat(7, 14.28%);
    }
}

</style>
