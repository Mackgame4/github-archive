<template>
    <div class="app">
        <div class="header simpleAppHeader">
            <v-subheader class="text">Adverts</v-subheader>
            <v-spacer></v-spacer>
            <div class="headerButton">
                <v-btn class="innerButton" :disabled="disabledRefresh" icon medium @click="requestRefresh">
                    <v-icon size="24">mdi-refresh</v-icon>
                </v-btn>
            </div>
            <div class="headerButton">
                <v-btn class="innerButton" icon medium @click="postAd">
                    <v-icon size="24">mdi-playlist-plus</v-icon>
                </v-btn>
            </div>
        </div>
        <div class="searchArea">
            <v-text-field v-model="searchQuery" class="inputSearch" label="Search" color="deep-purple lighten-1"></v-text-field>
        </div>
        <div class="subContainer"> 
            <div class="advert" v-for="(ad, ind) in filteredAds" v-bind:key="ind">
                <div class="content">
                    <p v-text="ad.advert">This is an ad</p>
                </div>
                <div class="footer">
                    <div class="side" v-clipboard="'Nick'" v-clipboard:success="clipboardSuccessHandler">
                        <p v-text="ad.name">Nick Riviera</p>
                    </div>
                    <div class="side right" v-clipboard="'555-555-5555'" v-clipboard:success="clipboardSuccessHandler">
                        <p v-text="ad.number">555-555-5555</p>
                    </div>
                </div>
            </div>
        </div>
    </div>
</template>

<script>
import Nui from '../utils/Nui';
import moment from 'moment';

export default {
    name: 'YPages',
    components: {
    },
    data: () => ({
        searchQuery: '',
        advertisments: [],
        filteredAds: [],
        disabledRefresh: false,
        refreshTimeout: null,
    }),
    props: {},
    methods: {
        async fetchAds() {
            const res = await Nui.send('getAdverts')
            if (res && res.success && res.data) {
                let test = [ ...res.data]
                let sorted = test.sort((a, b) => {
                    return b.time - a.time;
                });
                this.advertisments = sorted;
                this.refreshFilter();
                return true;
            } else return false;
        },
        refreshFilter() {
            if (this.searchQuery && this.searchQuery.length > 0) {
                const searchQ = this.searchQuery.toLowerCase();
                this.filteredAds = this.advertisments.filter(s => {
                    const adMatch = s.advert.toLowerCase().includes(searchQ);
                    return adMatch;
                });
            } else {
                this.filteredAds = this.advertisments;
            }
        },
        async requestRefresh() {
            if (!this.disabledRefresh) {
                this.disabledRefresh = true;
                this.$root.$emit('toggleLoading', true);
                await this.fetchAds();
                this.$root.$emit('doSBar', 'Refreshed');
                this.$root.$emit('toggleLoading', false);
                clearTimeout(this.refreshTimeout);
                this.refreshTimeout = setTimeout(() => {
                    this.disabledRefresh = false;
                }, 10000);
            }
        },
        getHumanFormattedTime(time) {
            return moment.unix(time).fromNow();
        },
        postAd() {
            this.$root.$emit('dialogs:show', 'Advert', {
            }, async (yes) => {
                if (yes) {
                    this.$root.$emit('toggleLoading', true);
                    await this.fetchAds();
                    this.$root.$emit('toggleLoading', false);
                }
            });
        },
        clipboardSuccessHandler() {
            this.$root.$emit('doSBar', 'Copied to Clipboard');
        }
    },
    computed: {

    },
    async mounted() {
        this.$root.$emit('toggleLoading', true);
        await this.fetchAds();
        this.$root.$emit('toggleLoading', false);
    },
    watch: {
        searchQuery() {
            this.refreshFilter();
        }
    },
    beforeDestroy() {
        this.$root.$emit('toggleLoading', false);
        clearTimeout(this.refreshTimeout);
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

    .searchArea {
        height: 5%;
        padding: 0 5%;
        .inputSearch {
            height: 100%;
            padding: 0;
            margin: 0;
        }
    }

    .subContainer {
        height: 89%;
        width: 100%;
        display: flex;
        flex-direction: column;
        overflow-y: scroll;
        .advert {
            background: #5b2f7c;
            margin: 2% 2.5%;
            //min-height: 50%;
            width: 95%;
            border: 2px @darker solid;
            //color: black;
            p {
                width: 100%;
                margin: 0;
                text-align: center;
                word-break: break-all;
            }
            .content {
                p {
                    padding: 2%;
                    font-size: calc(1rem * var(--resize-percentage));
                }
                border-bottom: 2px @darker solid;
            }
            .footer {
                display: flex;
                flex-direction: row;
                line-height: 50px;
                .side {
                    display: table-cell;
                    vertical-align: middle;
                    width: 50%;
                    border-right: 1px @darker solid;
                    user-select: none;
                    transition: .5s;
                    &:hover {
                        background: #3d1e55;
                    }
                    &.right {
                        border-right: none;
                        border-left: 1px @darker solid; 
                    }
                }
                p {
                    display: inline-block;
                    vertical-align: middle;
                    line-height: normal;
                    font-size: calc(0.9rem * var(--resize-percentage));
                }
            }
        }
    }
}

</style>