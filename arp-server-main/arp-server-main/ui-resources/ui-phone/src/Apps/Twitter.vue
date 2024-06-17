<template>
    <div class="app">
        <div class="header simpleAppHeader">
            <v-subheader class="text">Twitter · {{ getTwitterHandle }}</v-subheader>
            <v-spacer></v-spacer>
            <div class="headerButton">
                <v-btn class="innerButton" icon medium @click="postTweet" color="blue darken-2">
                    <v-icon size="24">mdi-twitter</v-icon>
                </v-btn>
            </div>
        </div>
        <div class="subContainer">
            <div class="tweetContainer" :class="{ myTweet: tweet.me }" v-for="(tweet, index) in getTweets" v-bind:key="index">
                <p class="tweeter" v-if="tweet.me">You ({{ tweet.tweeter }})</p>
                <p class="tweeter"  v-else>{{ tweet.tweeter }}</p>
                <div class="content">
                    <p v-text="tweet.content"></p>
                    <div v-if="tweet.image">
                        <image-preview :src="tweet.image" :autoReveal="tweet.me" />
                    </div>
                </div>
                <div class="footer">
                    <v-btn icon small :disabled="tweet.me" @click="reply(tweet.tweeter)">
                        <v-icon size="18">mdi-reply</v-icon>
                    </v-btn>
                    <v-btn icon small :disabled="tweet.me" @click="retweet(tweet)">
                        <v-icon size="18">mdi-twitter-retweet</v-icon>
                    </v-btn>
                    <v-spacer></v-spacer>
                    <div class="timeContainer">
                        <p class="grey--text text--lighten-1">{{ getHumanFormattedTime(tweet.time) }}</p>
                    </div>
                </div>
            </div>
        </div>
    </div>
</template>

<script>
//import Nui from '../../utils/Nui';
import moment from 'moment';
import ImagePreview from '../components/ImagePreview';

export default {
    name: 'Twitter',
    components: {
        ImagePreview,
    },
    data: () => ({

    }),
    props: {},
    methods: {
        getHumanFormattedTime(time) {
            return moment.unix(time).fromNow();
        },
        postTweet() {
            this.$root.$emit('dialogs:show', 'Twitter', {
            });
        },
        retweet(tweet) {
            this.$root.$emit('dialogs:show', 'Twitter', {
                rt: tweet,
            });
        },
        reply(tweeter) {
            this.$root.$emit('dialogs:show', 'Twitter', {
                reply: tweeter,
            });
        }
    },
    computed: {
        getTwitterHandle() {
            return this.$store.state.phoneData.twitter;
        },
        getTweets() {
            return this.$store.getters.getTweets;
        },
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

    .subContainer {
        height: 94%;
        width: 100%;
        display: flex;
        flex-direction: column;
        overflow-y: scroll;
        .tweetContainer {
            width: 95%;
            margin: 2% 2.5%;
            background: #1976D2;

            &.myTweet {
                background: #1f1f1f;
            }

            padding: 2%;
            border-radius: 8px;
            p {
                margin: 0;
                font-size: calc(1.2rem * var(--resize-percentage));
            }
            .tweeter {
                font-weight: 600;
            }
            .content {
                width: 100%;
                padding: 2%;
                justify-content: center;
                display:flex;
                flex-direction: column;
                div {
                    padding: 2.5% 5%;
                }
                p {
                    font-size: calc(1rem * var(--resize-percentage));
                }
            }
            .footer {
                display: flex;
                flex-direction: row;
                .timeContainer {
                    display: flex;
                    align-items: flex-end; 
                    p {
                        //position: absolute;
                        font-size: calc(0.75rem * var(--resize-percentage));
                        //line-height: 25px;
                        top: 50%;
                    }
                }
            }
        }
    }
}

</style>