import Vue from 'vue'
import Vuex from 'vuex'

Vue.use(Vuex)
import Nui from './utils/Nui';
//import { phoneSizes } from './config'; // ESLint warning "notInUse"
import moment from 'moment';

let notificationUpdateInterval = false;
let phoneCallLengthInterval = false;

let lastNotificationId = 0;

/* eslint-disable no-unused-vars */

export default new Vuex.Store({
    strict: Nui.inDev(),
    state: {
        character: {
            FirstName: 'Nick',
            LastName: 'Riviera',
            _FullName: 'Nick Riviera',
            Twitter: '@NickRiviera',
        },
        gameTime: '23:20',
        phoneSettings: {
            wallpaper: 'wp2',
        },
        phoneData: {
            twitter: '@NickRiviera',
            twitterHistory: [
                { tweeter: '@NickRiviera', content: 'Some tweet', image: 'https://cdn.discordapp.com/attachments/696061923963437146/813469643314429952/153695704_2151595631638093_5642695819719768549_n.jpg', time: 1614091720, me: false },
                { tweeter: '@Cunt', content: 'Some tweet', image: false, time: 1612091720, me: true },
            ],
            contacts: [
                { name: 'Nick Riviera', number: '455-666-7777' },
                { name: 'Abraham Lincolnshire', number: '333-666-7777' },
                { name: 'Abe Lincoln', number: '555-666-7777' },
            ],
            callHistory: [
                { number: '455-666-7777', time: 1613402285, outgoing: false },
                { number: '455-666-6666', time: 1613202284, outgoing: false },
            ],
            messageHistory: {
                '333-666-7777': [
                    { type: 'text', outgoing: true, message: 'Good message', time: 1613655774 },
                    { type: 'image', outgoing: false, message: 'https://i.imgur.com/poEoXAX.png', time: 1613671834 },
                ],
                '333-666-7778': [
                    { type: 'text', outgoing: true, message: 'Good message', time: 1613655774 },
                    { type: 'text', outgoing: false, message: 'Incoming Message bla bla bla bla bla bla', time: 1613746656 },
                ],
            },
            emailHistory: [
                { id: 1, mailer: 'test@samail.com', subject: 'Email subject that is a bit longer than a line bla bla bla', body: 'hi', time: 1613746656 },
            ],
        },
        phoneNotifications: {
            notifications: [],
            reversedNotifications: [],
        },
        phoneCall: false,
        eventLogs: [],
        eventLogsReversed: [],
        dialogStyle: false,
    },
    mutations: {
        characterDataUpdate(state, payload) {
            if (payload) {
                state.character = payload;
            }
        },
        setSettings(state, payload) {
            state.phoneSettings = payload;
        },
        setInitialData(state, payload) {
            state.phoneData.contacts = payload.contacts;
            state.phoneData.messageHistory = payload.messageHistory;
            state.phoneData.emailHistory = payload.emails;

            // Twitter
            const tweets = payload.twitter.map(tweet => {
                tweet.me = tweet.tweeter === state.character.Twitter;
                return tweet
            })
            state.phoneData.twitterHistory = tweets;


        },
        characterLogout(state) {
            state.phoneCall = false;
        },
        loggingAdd(state, payload) {
            const now = new Date(Date.now());
            const time = now.toTimeString().split(' ')[0];

            state.eventLogs.push({
                dir: payload.direction,
                eventName: payload.event,
                data: payload.data,
                time,
                response: payload.direction ? payload.response : {}
            });

            const eventLogsCopy = [ ...state.eventLogs ];
            state.eventLogsReversed = eventLogsCopy.reverse();
        },
        notificationAdd(state, payload) {
            state.phoneNotifications.notifications.push(payload);
        },
        notificationRefresh(state, payload) {
            const now = Date.now();
            state.phoneNotifications.notifications.map(n => {
                n.timeAgo = moment(n.sentTime).fromNow();
                n.t++
                if (n.onTop && now - n.sentTime >= n.timeout) n.onTop = false;

                if (payload && payload.dismiss && payload.dismiss === n.id) n.onTop = false;

                return n;
            });

            state.phoneNotifications.reversedNotifications = Array.from(state.phoneNotifications.notifications).reverse();
        },
        updatePhoneSetting(state, payload) {
            if (payload.key && payload.value) {
                Vue.set(state.phoneSettings, payload.key, payload.value);
            }
        },
        startPhoneCall(state, payload) {
            state.phoneCall = {
                number: payload.number,
                outgoing: payload.outgoing,
                start: Date.now(),
                length: '0:00'
            }
        },
        updatePhoneCall(state) {
            if (state.phoneCall && state.phoneCall.start) {
                const diff = Date.now() - state.phoneCall.start;
                const m = moment.duration(diff);
                const hours = m.hours();
                console.log('h', hours)
                const mins = m.minutes();
                const seconds = m.seconds().toString().padStart(2, '0');
                state.phoneCall.length = `${hours === 0 ? '' : `${hours}:`}${mins}:${seconds}`;
            }
        },
        finishPhoneCall(state) {
            state.phoneCall = false;
        },
        testAddMessage(state) {
            state.phoneData.messageHistory['333-666-7778'].push({ outgoing: false, message: 'Incoming Message bla bla bla bla bla bla', time: 1613746656 });
        },
        addContact(state, payload) {
            if (payload.data && payload.data.name && payload.data.number) {
                state.phoneData.contacts.push(payload.data);
            }
        },
        deleteContact(state, payload) {
            if (payload.number) {
                const toEditIndex = state.phoneData.contacts.findIndex(c => c.number === payload.number);
                if (toEditIndex > -1) {
                    Vue.delete(state.phoneData.contacts, toEditIndex);
                }
            }
        },
        editContact(state, payload) {
            if (payload.data && payload.data.name && payload.data.number && payload.original) {
                const toEditIndex = state.phoneData.contacts.findIndex(c => c.number === payload.original);
                if (toEditIndex > -1) {
                    Vue.set(state.phoneData.contacts, toEditIndex, payload.data);
                }
            }
        },

        addTweet(state, payload) {
            if (payload?.content && payload?.tweeter && payload?.time) {
                let me = payload.tweeter === state.phoneData.twitter;
                state.phoneData.twitterHistory.push({
                    ...payload,
                    me,
                });
            }
        }
    },
    actions: {
        loggedIntoCharacter({ commit }, payload) {
            if (payload && payload.character && payload.messageHistory && payload.contacts && payload.emails && payload.twitter && payload.settings) {
                commit('characterDataUpdate', payload.character);
                commit('setSettings', payload.settings);
                commit('setInitialData', payload);
            }
        },
        loggedOutCharacter({ commit }) {
            commit('characterLogout');
        },
        notification({ commit }, payload) {
            let notificationData = payload;
            if (notificationData.title && notificationData.text) {
                if (typeof(notificationData.icon) !== 'object' || !notificationData.icon.icon) {
                    notificationData.icon = {
                        icon: 'mdi-cog'
                    }
                }

                if (!notificationData.timeout || notificationData.timeout < 5000) {
                    notificationData.timeout = 5000;
                }

                notificationData.sentTime = Date.now();
                notificationData.onTop = true;
                
                lastNotificationId++;
                
                notificationData.id = lastNotificationId;
                notificationData.t = 100 * notificationData.id;
                commit('notificationAdd', notificationData);
                commit('notificationRefresh');

                if (!notificationUpdateInterval) {
                    notificationUpdateInterval = setInterval(() => {
                        commit('notificationRefresh');
                    }, 5000);
                }
            }
        },
        notificationDismiss({ commit }, payload) {
            if (payload) {
                commit('notificationRefresh', { dismiss: payload });
            }
        },
        async setWallpaper({ commit }, payload) {
            const res = await Nui.send('setPhoneSetting', {
                key: 'wallpaper',
                value: payload.wallpaper,
            });

            if (res && res.success) {
                commit('updatePhoneSetting', { key: 'wallpaper', value: payload.wallpaper })
            }
        },
        startPhoneCall({ commit }, payload) {
            if (payload.number) {
                commit('startPhoneCall', payload);

                if (phoneCallLengthInterval) clearInterval(phoneCallLengthInterval);
                phoneCallLengthInterval = setInterval(() => {
                    commit('updatePhoneCall');
                }, 1000);
            }
        },
        async contactEditAdd({ commit }, payload) {
            if (payload.number && payload.name) {
                if (!payload.type && !payload.original) {
                    return false;
                }
                const res = await Nui.send(payload.type ? 'contactAdd' : 'contactEdit', payload);
                if (res?.success) {
                    commit(payload.type ? 'addContact' : 'editContact', {
                        original: payload.original,
                        data: {
                            name: payload.name,
                            number: payload.number,
                        }
                    });
                    return true;
                } else {
                    return false;
                }
            } else return false;
        },
        async contactDelete({ commit }, payload) {
            if (payload) {
                const res = await Nui.send('contactDelete', payload);
                if (res?.success) {
                    commit('deleteContact', { number: payload });
                    return true;
                } else return false;
            } else return false;
        },

        async sendTweet({ commit }, payload) {
            if (payload && payload.content) {
                const res = await Nui.send('sendTweet', {
                    content: payload.content,
                    image: payload.image,
                });

                if (res?.success && res?.data) {
                    commit('addTweet', res.data);
                    return true;
                } else {
                    return false;
                }
            } else return false;
        },

    },
    getters: {
        getWallpaper(state) {
            if (state.phoneSettings && state.phoneSettings.wallpaper) {
                let wpType = 0;
                if (state.phoneSettings.wallpaper.startsWith('https://')) {
                    wpType = 1;
                }

                return {
                    wallpaper: state.phoneSettings.wallpaper,
                    type: wpType,
                }
            } else {
                return {
                    type: 0,
                    wallpaper: 'wp3'
                };
            }
        },
        phoneLoaded(state) {
            return state.loaded && state.character;
        },
        getAllContacts: (state) => (data) => {
            if (state.phoneData && state.phoneData.contacts) {
                let cpArray = [ ...state.phoneData.contacts ];

                let sortedArray = cpArray.sort((a, b) => {
                    return a.name.localeCompare(b.name, 'en', { sensitivity: 'base' });
                });

                if (data && data.type && data.query) {
                    sortedArray = sortedArray.filter(contact => {
                        const nameMatch = contact.name.toLowerCase().includes(data.query.toLowerCase());
                        const numberMatch = contact.number.includes(data.query);
                        if (data.type === 'name' && nameMatch) {
                            return true;
                        } else if (data.type === 'number' && numberMatch) {
                            return true;
                        } else if (data.type === 'both' && (nameMatch || numberMatch)) {
                            return true;
                        }
                        return false;
                    });
                }

                return sortedArray;
            }
            return [];
        },

        getContactByName: (state) => (data) => {
            if (state.phoneData && state.phoneData.contacts && data) {
                let cpArray = [ ...state.phoneData.contacts ];
                const found = cpArray.find(contact => contact.name.toLowerCase() === data.toLowerCase());
                return found;
            }
            return false;
        },
        getContactByNumber: (state) => (data) => {
            if (state.phoneData && state.phoneData.contacts && data) {
                let cpArray = [ ...state.phoneData.contacts ];
                const found = cpArray.find(contact => contact.number === data);
                return found;
            }
            return false;
        },

        getCallHistory(state) {
            if (state.phoneData && state.phoneData.callHistory) {
                let cpArray = [ ...state.phoneData.callHistory ];

                let sortedArray = cpArray.sort((a, b) => {
                    return a.time - b.time;
                });

                return sortedArray;
            }
            return [];
        },

        getNotifications(state) {
            return state.phoneNotifications.reversedNotifications;
        },

        getMessagesFront(state) {
            let results = [];
            for (const number in state.phoneData.messageHistory) {
                const messages = state.phoneData.messageHistory[number];
                const topMessage = messages[messages.length - 1];
                results.push({ ...topMessage, number });
            }
            console.log(results)
            let sortedArray = results.sort((a, b) => {
                return a.time - b.time;
            });

            return sortedArray.reverse();
        },

        getMessagesForNumber: (state) => (data) => {
            if (state.phoneData.messageHistory[data]) {
                const res = Array.from(state.phoneData.messageHistory[data]);
                let sortedArray = res.sort((a, b) => {
                    return a.time - b.time;
                });
    
                return sortedArray;
            } else {
                return [];
            }
        },

        getName(state) {
            return state.character?.fullName;
        },

        getEmails(state) {
            if (state.phoneData.emailHistory) {
                const res = Array.from(state.phoneData.emailHistory);
                let sortedArray = res.sort((a, b) => {
                    return a.time - b.time;
                });
    
                return sortedArray;
            } else return [];
        },
        getEmail: (state) => (id) => {
            if (state.phoneData.emailHistory) {
                return state.phoneData.emailHistory.find(e => e.id === id);
            } else return null;
        },

        getTweets(state) {
            if (state.phoneData && state.phoneData.twitterHistory) {
                let cpArray = [ ...state.phoneData.twitterHistory ];

                let sortedArray = cpArray.sort((a, b) => {
                    return b.time - a.time;
                });

                return sortedArray;
            }
            return [];
        }
    }
})