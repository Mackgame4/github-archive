<template>
    <div class="app">
        <div>
            <v-icon class="float-right" style="margin-top: 10px; margin-right: 8px;" icon>mdi-bank</v-icon>
            <v-subheader>Penguin Bank · @NickRiviera · ${{ cash }}</v-subheader>
            <v-divider></v-divider>
        </div>
        <div class="mainTab" v-if="menu === 0">
            <v-subheader>Your accounts:</v-subheader>
            <v-card style="margin-left: 8px; width: 95%; background-color: #455A64;" outlined shaped>
                <v-card-text>
                    <v-img class="float-right" max-height="50" max-width="50" src="https://www.seekpng.com/png/full/212-2128294_visa-logo-png-image-visa-logo-white-png.png"></v-img>
                    <h2 class="white--text" style="font-weight: 300;">Personal Account</h2>
                    <div style="font-weight: 300;">#000-000-000</div>
                    <p class="display-1 primary--text" style="font-weight: 300;">${{ amount }}</p>
                </v-card-text>
                <v-card-actions>
                    <v-btn color="red darken-4 accent-4" style="font-weight: 300;" outlined>Share Account</v-btn>
                    <v-btn color="primary accent-4" style="font-weight: 300;" outlined @click="changeBankAccount()">Move to</v-btn>
                </v-card-actions>
            </v-card>
            <v-card style="margin-top: 8px; margin-left: 8px; width: 95%; background-color: #455A64;" outlined shaped>
                <v-card-text>
                    <v-icon class="float-right" icon>mdi-penguin</v-icon>
                    <h2 class="white--text" style="font-weight: 300;">Business Account</h2>
                    <div style="font-weight: 300;">#000-000-000</div>
                    <p class="display-1 primary--text" style="font-weight: 300;">${{ amount }}</p>
                </v-card-text>
                <v-card-actions>
                    <v-btn color="red darken-4 accent-4" style="font-weight: 300;" outlined>Share Account</v-btn>
                    <v-btn color="primary accent-4" style="font-weight: 300;" outlined @click="changeBankAccount()">Move to</v-btn>
                </v-card-actions>
            </v-card>
            <v-card style="margin-top: 8px; margin-left: 8px; margin-bottom: 8px; width: 95%; background-color: #455A64;" outlined shaped>
                <v-card-text>
                    <v-icon class="float-right" icon>mdi-piggy-bank</v-icon>
                    <h2 class="white--text" style="font-weight: 300;">Save Account</h2>
                    <div style="font-weight: 300;">#000-000-000</div>
                    <p class="display-1 primary--text" style="font-weight: 300;">${{ amount }}</p>
                </v-card-text>
                <v-card-actions>
                    <v-btn color="red darken-4 accent-4" style="font-weight: 300;" outlined>Share Account</v-btn>
                    <v-btn color="primary accent-4" style="font-weight: 300;" outlined @click="changeBankAccount()">Move to</v-btn>
                </v-card-actions>
            </v-card>
        </div>
        <div class="secondTab" v-if="menu === 1">
            <v-subheader>Your transactions:</v-subheader>
            <v-card style="margin-left: 8px; width: 95%; background-color: #455A64;" outlined>
                <v-card-text>
                    <v-icon class="float-right" icon>mdi-bank-transfer-in</v-icon>
                    <h2 class="white--text" style="font-weight: 300;">To: Personal Account</h2>
                    <div style="font-weight: 300;">@Mack sent you</div>
                    <p class="display-1 success--text" style="font-weight: 300;">+${{ amount }}</p>
                </v-card-text>
                <v-card-actions>
                    <v-btn color="red darken-4 accent-4" style="font-weight: 300;" outlined>Send Back</v-btn>
                    <v-btn color="primary accent-4" style="font-weight: 300;" outlined @click="changeBankAccount()">Move to</v-btn>
                </v-card-actions>
            </v-card>
            <v-card style="margin-top: 8px; margin-left: 8px; width: 95%; background-color: #455A64;" outlined>
                <v-card-text>
                    <v-icon class="float-right" icon>mdi-bank-transfer-out</v-icon>
                    <h2 class="white--text" style="font-weight: 300;">From: Personal Account</h2>
                    <div style="font-weight: 300;">You sent to @Mack</div>
                    <p class="display-1 error--text" style="font-weight: 300;">-${{ amount }}</p>
                </v-card-text>
                <v-card-actions>
                    <v-btn color="red darken-4 accent-4" style="font-weight: 300;" outlined>Ask Back</v-btn>
                </v-card-actions>
            </v-card>
        </div>
        <v-divider></v-divider>
        <footer>
            <v-tabs grow height="35" v-model="menu" color="grey">
                <v-tab style="width: 33%">My Accounts</v-tab>
                <v-tab style="width: 33%">Transactions</v-tab>
            </v-tabs>
        </footer>
    </div>
</template>

<script>
//import Nui from '../../utils/Nui';

export default {
    name: 'Bank',
    components: {
    },
    data: () => ({
        dialog: false,
        menu: 0,
        amount: 100000,
        cash: 100000,
    }),
    props: {},
    methods: {
        changeBankAccount() {
            this.$root.$emit('dialogs:show', 'BankAccountEdit', {
                type: true,
            });
        },
        shareBankAccount() {
            this.$root.$emit('dialogs:show', 'BankAccountShare', {
                type: true,
            });
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

    .mainTab {
        width: 100%;
        height: 100%;
        overflow: auto;
    }

    .secondTab {
        width: 100%;
        height: 100%;
    }
}

</style>
