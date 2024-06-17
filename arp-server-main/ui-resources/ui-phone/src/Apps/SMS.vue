<template>
    <div class="app">
        <div class="header simpleAppHeader">
            <v-subheader class="oneLine text" v-if="openedMessages">{{ openedMessages }} - {{ getCallContact(openedMessages) ? getCallContact(openedMessages).name : 'No Contact' }}</v-subheader>
            <v-subheader class="text" v-else>Messaging · Conversations: {{ messagesFrontPage.length }}</v-subheader>
            <v-spacer></v-spacer>
            <div class="headerButton" v-if="openedMessages && !getCallContact(openedMessages)" @click="addNumberAsContact">
                <v-btn class="innerButton" icon small>
                    <v-icon size="18">mdi-plus</v-icon>
                </v-btn>
            </div>
            <div class="headerButton" v-if="openedMessages">
                <v-btn class="innerButton" icon small>
                    <v-icon size="18">mdi-file-image-outline</v-icon>
                </v-btn>
            </div>
            <div class="headerButton" v-if="openedMessages">
                <v-btn class="innerButton" color="green" icon small>
                    <v-icon size="18">mdi-phone</v-icon>
                </v-btn>
            </div>
        </div>
        <v-divider></v-divider>
        <transition name="smenu-transition" mode="out-in">
            <div class="subContainer" v-if="openedMessages" key="open">
                <div class="messageList">
                    <div class="messageContainer" v-for="(message, index) in messagesForCurrent" v-bind:key="index">
                        <v-spacer v-if="message.outgoing"></v-spacer>
                        <div class="messageSubContainer">
                            <div class="messageBubble" :class="{ messageBubbleOutgoing: message.outgoing }">
                                <div class="mContainer">
                                    <p v-if="message.type === 'text'" v-text="message.message"></p>
                                    <image-preview v-else :src="message.message" :autoReveal="message.outgoing" />
                                </div>
                            </div>
                            <p class="infoStamp">{{ message.outgoing ? 'You': 'Them' }}, {{ getHumanFormattedTime(message.time) }}</p>
                        </div>
                    </div>
                </div>
                <div class="messageControls">
                    <div class="messageInput">
                        <v-textarea class="messageArea" rows="2" no-resize color="red darken-4"></v-textarea>
                    </div>
                    <div class="messageButton">
                        <v-btn class="innerButton" icon medium>
                            <v-icon size="18">mdi-send</v-icon>
                        </v-btn>
                    </div>
                </div>
            </div>
            <div class="subContainer" v-else key="viewing">
                <v-list subheader flat class="list">
                    <v-list-item v-if="messagesFrontPage.length === 0">
                        <v-list-item-avatar>
                            <v-avatar color="grey"><v-icon dark>mdi-message</v-icon></v-avatar>
                        </v-list-item-avatar>
                        <v-list-item-content>
                            <v-list-item-title>No message history</v-list-item-title>
                        </v-list-item-content>
                    </v-list-item>

                    <v-list-item link v-for="messageHistory in messagesFrontPage" v-bind:key="messageHistory.number" @click="openMessage(messageHistory.number)">
                        <v-list-item-avatar>
                            <v-avatar color="grey"><v-icon size="18" dark>mdi-message-text</v-icon></v-avatar>
                        </v-list-item-avatar>
                        <v-list-item-content>
                            <v-list-item-title v-if="getCallContact(messageHistory.number)">{{ getCallContact(messageHistory.number).name || messageHistory.number }}</v-list-item-title>
                            <v-list-item-title v-else>{{ messageHistory.number }}</v-list-item-title>
                            <v-list-item-subtitle><strong>{{ messageHistory.outgoing ? 'You: ' : 'Them: ' }}</strong>{{ messageHistory.type === 'text' ? messageHistory.message : 'Image Attached' }}</v-list-item-subtitle>
                        </v-list-item-content>
                    </v-list-item>
                </v-list>
            </div>
        </transition>
    </div>
</template>

<script>
//import Nui from '../../utils/Nui';
import moment from 'moment';
import { ImagePreview } from '../utilComponents';

export default {
    name: 'SMS',
    components: {
        ImagePreview
    },
    data: () => ({
        openedMessages: false,
        refreshInterval: null,
    }),
    props: {
        initData: {
            required: true,
        }
    },
    methods: {
        openMessage(num) {
            this.openedMessages = num;
            this.refreshInterval = setInterval(() => {
                console.log('rr')
                this.$forceUpdate();
            }, 20000);
        },
        goBack() {
            if (this.openedMessages) {
                this.openedMessages = false;
                clearInterval(this.refreshInterval);
            }
        },
        getCallContact(number) {
            return this.$store.getters.getContactByNumber(number);
        },
        getHumanFormattedTime(time) {
            return moment.unix(time).fromNow();
        },
        addNumberAsContact() {
            this.$root.$emit('dialogs:show', 'ContactEdit', {
                type: true,
                number: this.openedMessages
            });
        }
    },
    computed: {
        messagesFrontPage() {
            return this.$store.getters.getMessagesFront;
        },
        messagesForCurrent() {
            return this.$store.getters.getMessagesForNumber(this.openedMessages).reverse(); // reverse so it also scrolls to bttom on new
        }
    },
    created() {
        
    },
    mounted() {
        this.$root.$on('goBack', this.goBack);
    },
    beforeDestroy() {
        this.$root.$off('goBack', this.goBack);
        clearInterval(this.refreshInterval);
    }
};

</script>

<style scoped lang="less">
@import '@/arp-theme.less';

@incomingMessage: #3a3a3a;
@outgoingMessage: #1e78cc;

.app {
    width: 100%;
    height: 100%;
    display: flex;
    flex-direction: column;
    .header {
        height: 6%;
    }
    overflow: hidden;

    .subContainer {
        height: 94%;
        display: flex;
        flex-direction: column;
        .list {
            height: 100%;
            overflow-y: scroll;
        }
        .messageList {
            width: 100%;
            height: 90%;
            overflow-y: scroll;
            display: flex;
            flex-direction: column-reverse;

            .messageContainer {
                width: 100%;
                display: flex;
                flex-direction: row;
                .messageSubContainer {
                    max-width: 85%;
                    height: 100%;
                    padding: 2.5% 4%;
                    display: flex;
                    flex-direction: column;
                    .messageBubble {
                        height: 100%;
                        background: @incomingMessage;
                        border-radius: 8px;
                        .mContainer {
                            height: 100%;
                            margin: 5px 10px;
                        }
                        p {
                            margin: 0;
                            width: 100%;
                            font-size: calc(1rem * var(--resize-percentage));
                            word-break: break-word;
                        }
                    }
                    .messageBubbleOutgoing {
                        background: @outgoingMessage;
                    }
                    .infoStamp {
                        margin: 0;
                        margin-right: 5px;
                        font-size: calc(0.7rem * var(--resize-percentage));
                        text-align: right;
                        opacity: 80%;
                        user-select: none;
                    }
                }
            }

        }
        .messageControls {
            height: 10%;
            width: 100%;
            display: flex;
            flex-direction: row;
            .messageInput {
                padding: 0 2.5%;
                width: 85%;
    
                .messageArea {
                    margin: 0;
                    padding: 0;
                    height: 100%;
                }
            }
            .messageButton {
                width: 15%;
                .innerButton {
                    display: block;
                    margin: auto;
                    margin-top: 25%;
                }
            }
        }
    }
}


.message-transition-enter-active {
    animation: message-transition .2s;
}

@keyframes message-transition {
    0% {
        transform: scale(0);
    }
    100% {
        transform: scale(1);
    }
}

</style>
