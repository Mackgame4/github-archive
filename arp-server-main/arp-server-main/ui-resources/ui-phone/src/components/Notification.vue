<template>
    <div class="notification" v-if="data" @click="notificationClick">
        <div class="header">
            <v-icon class="minIcon" :color="data.icon.color" size="20" v-text="data.icon.icon">mdi-twitter</v-icon>
            <p class="notifTitle" v-html="data.title"></p>
            <p class="notifTime" v-if="inApp && data.timeAgo">{{ data.timeAgo }}</p>
            <p class="notifTime" v-if="!inApp && data.sentTime">{{ getFormattedTime }}</p>
        </div>
        <div class="content">
            <p v-html="data.text"></p>
        </div>
    </div>
</template>

<script>

import moment from 'moment';


export default {
    name: 'Notification',
    components: {},
    data: () => ({
    }),
    props: {
        data: {
            required: true,
        },
        inApp: {
            default: false,
            required: false,
            type: Boolean,
        }
    },
    methods: {
        notificationClick() {
            if (!this.inApp) {
                this.$emit('dismiss');
            }
        }
    },
    computed: {
        getFormattedTime() {
            return moment(this.data.sentTime).format('H:mm:ss');
        }
    },
    mounted() {

    }
};

</script>

<style scoped lang="less">
@import '@/arp-theme.less';

.notification {
    display: flex;
    flex-direction: column;
    margin-top: 7.5px;
    margin-left: 10px;
    background: #1a1a1af1;
    border-radius: 20px;
    user-select: none;
    transition: 1s ease all;

    width: calc(var(--outer-width) - var(--inner-padding-width) - 20px);
    max-height: calc(((var(--outer-height) - var(--inner-padding-height)) / 100) * 25 - 15);
    //border: @lighter solid 2px;

    .header {
        height: 20%;
        width: 100%;
        display: flex;
        flex-direction: row;
        padding: 2.5% 3% 0 3%;

        .minIcon {
            width: 10%;
            height: 100%;
        }

        p {
            margin: 0;
            margin-left: 2.5%;
            max-height: 100%;
        }

        .notifTime {
            width: 37.5%;
            text-align: right;
            font-size: 0.7rem;
            opacity: 75%;
        }

        .notifTitle {
            font-size: 0.9rem;
            //text-align: center;
            width: 50%;
            overflow: hidden;
            display: -webkit-box;
            -webkit-line-clamp: 1;
            -webkit-box-orient: vertical;
        }
    }
    .content {
        height: 80%;
        width: 100%;
        padding: 0 5%;
        p {
            margin: 4px 0 5px 0;
            display: -webkit-box;
            -webkit-line-clamp: 3; /* number of lines to show */
            -webkit-box-orient: vertical;
            overflow: hidden;
            font-size: 0.8rem;
            opacity: 80%;
        }
    }
}

</style>
