<template>
    <div class="app">
        <div class="header">
            <v-subheader>{{ dateString }}</v-subheader>
            <v-header>APPSTORE</v-header>
            <span @click="quickOpenApp('settings')"><v-avatar class="avatar" color="red darken-4" size="46">{{ getInitials }}</v-avatar></span>
        </div>
        <div class="container">
            <v-carousel class="carousel" :continuous="true" :cycle="true" :show-arrows="false" hide-delimiter-background delimiter-icon="mdi-minus" height="300">
                <v-carousel-item v-for="(app, i) in topApps" :key="i">
                    <v-sheet class="sheet" v-bind:style="{ 'background-image': 'url(' + app.img + ')' }" height="100%" tile>
                        <v-subheader>{{ app.text }}</v-subheader>
                    </v-sheet>
                </v-carousel-item>
            </v-carousel>
            <v-list>
                <v-subheader>Application List</v-subheader>
                <v-list-item v-for="(app, i) in appList" :key="i">
                    <v-list-item-avatar>
                        <v-avatar color="red darken-4"><v-icon dark v-text="app.icon"></v-icon></v-avatar>
                    </v-list-item-avatar>
                    <v-list-item-content>
                        <v-list-item-title v-text="app.text"></v-list-item-title>
                        <!--v-list-item-subtitle>AppDesc</v-list-item-subtitle-->
                    </v-list-item-content>
                    <v-list-item-action>
                        <v-btn icon>
                            <v-icon>mdi-download</v-icon> <!-- TODO: change to loader on click and addApp / check if owned then change to unistall icon, etc. -->
                        </v-btn>
                    </v-list-item-action>
                </v-list-item>
            </v-list>
        </div>
    </div>
</template>

<script>
//import Nui from '../../utils/Nui';
import moment from 'moment';

export default {
    name: 'Appstore',
    components: {
    },
    data: () => ({
        dateString: moment().format('dddd, Do MMMM'),
        appList: [
            { text: 'Music', icon: 'mdi-ipod' },
            { text: 'Weather', icon: 'mdi-cloud' },
            { text: 'Friend Finder', icon: 'mdi-map-marker-distance' },
            { text: 'Compass', icon: 'mdi-apple-safari' },
        ],
        topApps: [
            { text: 'Music', img: 'https://cdn.jim-nielsen.com/watchos/512/apple-music-2020-09-29.png'},
            { text: 'Weather', img: 'https://i.pinimg.com/originals/06/c4/f7/06c4f70ec5931e2342e703e8a3f0a253.png'},
            { text: 'Friend Finder', img: 'http://static1.squarespace.com/static/5735ef9da3360ce2540895c5/5735f94a2fe131630fbc8d7f/589d5171be65941098d7de22/1497534099175/Podcast+Icon.jpg'},
        ],
    }),
    props: {},
    methods: {
        quickOpenApp(app) {
            if (!this.homeButtonDisabled) {
                this.$root.$emit('openApp', { app });
            }
        },
    },
    computed: {
        getInitials() {
            const character = this.$store.state.character;
            if (character) {
                return `${character.FirstName[0]}${character.LastName[0]}`
            }
            return '';
        }
    },
    created() {
        console.log(this.$store.getters.getName)
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
        font-size: 20px;
        max-height: 5%;
        text-align: left;

        v-header {
            position: absolute;
            top: 30px;
            left: 18px;
            font-weight: bold;
            letter-spacing: 1px;
        }

        .avatar {
            position: absolute;
            top: 15px;
            right: 18px;
        }
    }

    .container {
        position: absolute;
        top: 70px;

        .carousel {
            border-radius: 17px;
        }

        .sheet {
            background-position: center;
            background-size: cover;
            background-repeat: no-repeat;
        }
    }
}

</style>
