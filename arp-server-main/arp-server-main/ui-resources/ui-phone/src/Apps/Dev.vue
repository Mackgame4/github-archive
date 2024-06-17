<template>
    <div class="app">
        <div class="header">
            <v-subheader>Hello, you found the secret menu.</v-subheader>
        </div>
        <div class="container">
            <div class="event" v-for="(event, index) in getEvents" v-bind:key="index"> 
                <div class="titleThings" :class="isIncoming(event.dir)">
                    <h4>"{{ event.eventName }}"</h4>
                </div>
                <div class="other cunt"><p>Request</p></div>
                <!-- eslint-disable vue/no-textarea-mustache -->
                <textarea disabled ref="textarea"> {{ JSON.stringify(event.data, null, '\t') }} </textarea>
                <div class="other cunt" v-if="event.dir"><p>Response</p></div>
                <textarea v-if="event.dir" disabled ref="textarea"> {{ JSON.stringify(event.response, null, '\t')}}</textarea>
                <!-- eslint-enable vue/no-textarea-mustache -->
                <div class="other">
                    <p>{{ event.time }}</p>
                    <p>{{ event.dir ? 'Outgoing' : 'Incoming' }}</p>
                </div>
            </div>
        </div>
    </div>
</template>

<script>
//import Nui from '../../utils/Nui';

export default {
    name: 'Dev',
    components: {

    },
    data: () => ({

    }),
    props: {},
    methods: {
        isIncoming(data) {
            if (data) {
                return { active: false };
            }
            return { active: true };
        },
    },
    computed: {
        getEvents() {
            return this.$store.state.eventLogsReversed;
        }
    },
    created() {
        console.log(this.$store.state.eventLogsReversed)
    },
    mounted() {
    },
};

</script>

<style scoped lang="less">
@import '@/arp-theme.less';

.app {
    width: 100%;
    height: 100%;
    display: flex;
    flex-direction: column;

    .header {
        max-height: 5%;
        text-align: center;
    }


    .container {
        height: 95%;
        overflow-y: scroll;
        .event {
            margin: 2.5%;
            background: @light;
            width: 95%;
            min-height: 6vh;
            max-height: auto;
            border-radius: 1vh;
            display: flex;
            flex-direction: column;
            .titleThings {
                width: 100%;
                height: 3.5vh;
                background: @midnight;
                justify-content: center;
                h4 {
                    text-align: center;
                    margin: 0;
                    color: @light;
    
                    text-decoration: none;
                    white-space: nowrap;
                    overflow: hidden;
                    text-overflow: ellipsis;
                }
            }
            .active {
                background: @red2;
            }
            textarea {
                min-width: 100%;
                max-width: 100%;
                min-height: 160px;
                max-height: 320px;
                background: rgba(0, 0, 0, 0.85);
                border: 2px solid rgba(0, 0, 0, 0.75);
                color: rgba(255, 255, 255, 0.9);
            }
            .other {
                width: 100%;
                background: @dark;
                height: auto;
                text-align: center;
                color: @light;
                p {
                    margin-top: 0.2vh;
                    margin-bottom: 0.2vh;
                }
            }
            .cunt {
                border-radius: 0;
                color: @dark;
                background: @lighter;
            }
        }
        &::-webkit-scrollbar {
            display: none;
        }
    }

}

</style>
