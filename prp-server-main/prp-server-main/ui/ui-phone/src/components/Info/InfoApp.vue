<template>
    <div id="app">
        <v-app>
            <div class="appBar elevation-4">
                <span class="appName">Information</span>
                <span class="appIcon"><v-icon style="font-size: 72px;" color="rgba(0, 0, 0, 0.45)">mdi-information-variant</v-icon></span>
            </div>
            <div class="appContainer">
                <v-list two-line style="background: none;">
                    <v-list-item>
                        <v-list-item-icon>
                            <v-icon color="info">mdi-phone</v-icon>
                        </v-list-item-icon>
                        <v-list-item-content>
                            <v-list-item-title>{{ getPhoneData.mobileNumber }}</v-list-item-title>
                            <v-list-item-subtitle>Mobile</v-list-item-subtitle>
                        </v-list-item-content>
                        <v-list-item-icon>
                            <v-btn icon @click="alert = true" v-clipboard:copy="getPhoneData.mobileNumber"><v-icon>mdi-clipboard-text</v-icon></v-btn>
                        </v-list-item-icon>
                    </v-list-item>

                    <v-divider inset></v-divider>

                    <v-list-item>
                        <v-list-item-icon>
                            <v-icon color="info">mdi-account</v-icon>
                        </v-list-item-icon>
                        <v-list-item-content>
                            <v-list-item-title>{{ getCharacterName }}</v-list-item-title>
                            <v-list-item-subtitle>Name</v-list-item-subtitle>
                        </v-list-item-content>
                    </v-list-item>

                    <v-list-item>
                        <v-list-item-action></v-list-item-action>
                        <v-list-item-content>
                            <v-list-item-title>{{ getCharacterData.CID }}</v-list-item-title>
                            <v-list-item-subtitle>CID</v-list-item-subtitle>
                        </v-list-item-content>
                    </v-list-item>

                    <v-list-item>
                        <v-list-item-action></v-list-item-action>
                        <v-list-item-content>
                            <v-list-item-title>{{ getCharacterData.JobName }}</v-list-item-title>
                            <v-list-item-subtitle>Job</v-list-item-subtitle>
                        </v-list-item-content>
                    </v-list-item>

                    <v-list-item>
                        <v-list-item-action></v-list-item-action>
                        <v-list-item-content>
                            <v-list-item-title>{{ getCharacterData.DOB }}</v-list-item-title>
                            <v-list-item-subtitle>DOB</v-list-item-subtitle>
                        </v-list-item-content>
                    </v-list-item>
                    
                    <v-divider inset></v-divider>

                    <v-list-item>
                        <v-list-item-icon>
                            <v-icon color="info">mdi-home</v-icon>
                        </v-list-item-icon>
                        <v-list-item-content>
                            <v-list-item-title>1400 Main Street</v-list-item-title>
                            <v-list-item-subtitle>Orlando, FL 79938</v-list-item-subtitle>
                        </v-list-item-content>
                    </v-list-item>

                    <v-list-item>
                        <v-list-item-action></v-list-item-action>
                        <v-list-item-content>
                            <v-list-item-title>1800 Vagos Street</v-list-item-title>
                            <v-list-item-subtitle>Avenue Street, 79938</v-list-item-subtitle>
                        </v-list-item-content>
                    </v-list-item>

                    <v-divider inset></v-divider>

                    <v-list-item>
                        <v-list-item-icon>
                            <v-icon color="info">mdi-car</v-icon>
                        </v-list-item-icon>
                        <v-list-item-content>
                            <v-list-item-title>T20</v-list-item-title>
                            <v-list-item-subtitle>Garage I</v-list-item-subtitle>
                        </v-list-item-content>
                    </v-list-item>

                    <v-list-item>
                        <v-list-item-action></v-list-item-action>
                        <v-list-item-content>
                            <v-list-item-title>Sultan RS</v-list-item-title>
                            <v-list-item-subtitle>Garage II</v-list-item-subtitle>
                        </v-list-item-content>
                    </v-list-item>
                </v-list>
                <v-alert class="notify" type="info" :value="alert" transition="scale-transition">Copied to clipboard</v-alert>
            </div>
        </v-app>
    </div>
</template>

<script>

export default {
    name: 'InfoApp',
    components: {
    },
    data: () => ({
        alert: false
    }),
    mounted() {
    },
    watch: {
        alert(new_val){
            if(new_val == true){ setTimeout(()=>{this.alert = false}, 1200); }
        }  
    },
    computed: {
        getCharacterName() {
            const character = this.$store.state.character;
            if (character) {
                return `${character.FirstName} ${character.LastName}`
            }
            return '';
        },
        getCharacterData() {
            const character = this.$store.state.character;
            if (character) {
                return character
            }
            return '';
        },
        getPhoneData() {
            const phone = this.$store.state.phoneData;
            if (phone) {
                return phone
            }
            return '';
        }
    },
    methods: {
    }
}
</script>

<style lang="less" scoped>
@import '@/theme.less';

#app {
    border-top-left-radius: 32px;
    border-top-right-radius: 32px;
}

.appBar {
    height: 100px;
    background: linear-gradient(to top right, #285DA9, #3181B9);
}

.appName {
    position: absolute;
    top: 28px;
    left: 22px;
    color: rgba(0, 0, 0, 0.5);
    font-family: "San Francisco";
    font-size: 44px;
    font-weight: bold;
}

.appIcon {
    position: absolute;
    top: 23px;
    left: 230px;
    transform: rotate(7deg);
}

.appContainer {
    width: 305px;
    max-width: 305px;
    height: 452px;
    max-height: 452px;
    padding-left: 7px;
    padding-right: 7px;
    font-size: 17px;
    overflow-y: auto;
}

.notify {
    left: 50px;
}

</style>