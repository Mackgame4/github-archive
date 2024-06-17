<template>
    <div class="app">
        <v-spacer></v-spacer>
        <div class="header">
            <h3 class="headline text-center">{{ getNotifications.length }} Notification{{ noNotifications ? '' : 's' }}</h3>
        </div>
        <v-divider></v-divider>
        <div class="subContainer">
            <Notification v-if="noNotifications" :data="{ icon: { icon: 'mdi-cog' }, title: 'Notifications', text: 'There are no notifications to display here.'}" inApp />
            <Notification v-for="item in getNotifications" v-bind:key="item.t" :data="item" inApp />
        </div>
    </div>
</template>

<script>
//import Nui from '../../utils/Nui';
import Notification from '../components/Notification';

export default {
    name: 'NotificationsApp',
    components: {
        Notification,
    },
    data: () => ({
        timeout: null,
        notifications: [],
    }),
    props: {},
    methods: {
        goBack() {
            this.$root.$emit('forceCloseApps');
        }
    },
    computed: {
        getNotifications() {
            return this.$store.getters.getNotifications;
        },
        noNotifications() {
            return this.$store.getters.getNotifications.length === 0;
        }
    },
    created() {

    },
    mounted() {
        this.$root.$on('goBack', this.goBack);
    },
    beforeDestroy() {
        this.$root.$off('goBack', this.goBack);
    }
};

</script>

<style scoped lang="less">
@import '@/arp-theme.less';

.app {
    width: 100%;
    height: 100%;
    display: flex;
    flex-direction: column;
    backdrop-filter: blur(5px);
    background: #161616a8;

    .header {
        height: 5%;
        width: 100%;
        h3 {
            font-size: 1.5rem !important;
        }
    }

    .subContainer {
        height: 92%;
        width: 100%;
        overflow-y: scroll;

        &::-webkit-scrollbar {
            display: none;
        }
    }
}

</style>
