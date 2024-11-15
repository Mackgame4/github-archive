<template>
    <div>
        <v-app id="appScreen">
        <v-toolbar style="max-height: 62px;">
            <v-app-bar-nav-icon></v-app-bar-nav-icon>
            <v-toolbar-title>Settings</v-toolbar-title>
            <v-spacer></v-spacer>
            <v-btn icon>
                <v-icon color="error accent-4" @click="$store.commit('setHomePage', true);">mdi-close</v-icon>
            </v-btn>
        </v-toolbar>
        <v-list nav>
            <v-list-item>
                <v-list-item-icon>
                    <v-icon>mdi-image-area</v-icon>
                </v-list-item-icon>
                <v-list-item-content>
                    <v-list-item-title>Background</v-list-item-title>
                    <v-list-item-subtitle>Change your device background</v-list-item-subtitle>
                    <v-text-field v-model="background" style="margin-top: 7px; margin-bottom: -27px;" label="Link" filled @change="$store.commit('changeBackground', background);"></v-text-field>
                </v-list-item-content>
            </v-list-item>
            <v-list-item>
                <v-list-item-icon>
                    <v-icon>mdi-volume-off</v-icon>
                </v-list-item-icon>
                <v-list-item-content>
                    <v-list-item-title>Silent</v-list-item-title>
                    <v-list-item-subtitle>Put your device in silent mode and receive no more notifications</v-list-item-subtitle>
                </v-list-item-content>
                <v-list-item-action>
                    <v-checkbox color="primary" v-model="inSilence"></v-checkbox>
                </v-list-item-action>
            </v-list-item>
            <v-list-item>
                <v-list-item-icon>
                    <v-icon>mdi-briefcase</v-icon>
                </v-list-item-icon>
                <v-list-item-content>
                    <v-list-item-title>In Service</v-list-item-title>
                    <v-list-item-subtitle class="error--text">This option is only used to get you out of service in extreme situations, else go to your work place and ask your boss first</v-list-item-subtitle>
                </v-list-item-content>
                <v-list-item-action>
                    <v-switch color="primary" v-model="inService"></v-switch>
                </v-list-item-action>
            </v-list-item>
        </v-list>
        </v-app>
    </div>
</template>

<script>

export default {
    name: 'App',
    components: {
    },
    data: () => ({
        background: '',
        inSilence: false,
        inService: true
    }),
    mounted() {
    },
    watch: {
    },
    methods: {
    }
}
</script>

<style lang="less" scoped>
@import '@/theme.less';

#appScreen {
    width: 55.6vw !important;
    height: 31.5vw !important;
}

</style>