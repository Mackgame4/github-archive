<template>
    <div id="app">
        <v-app>
            <div class="appBar elevation-4">
                <span class="appIcon"><v-icon style="font-size: 82px;" color="rgba(0, 0, 0, 0.45)">mdi-bank</v-icon></span>
                <v-subheader>Welcome back, {{userName}}!</v-subheader>
                <p>${{personalAccountMoney}}</p>
                <v-btn class="mainBtn" color="indigo darken-2">Create Account</v-btn>
            </div>
            <div class="appContainer">
                <v-card class="accountCard" shaped dark>
                    <v-card-title>Personal Account</v-card-title>
                    <v-card-subtitle>${{personalAccountMoney}}</v-card-subtitle>
                    <v-card-actions>
                        <v-btn class="btn" text outlined color="indigo accent-1">More Details</v-btn>
                    </v-card-actions>
                    <span class="cardIcon"><v-icon style="font-size: 54px;" color="rgba(0, 0, 0, 0.45)">mdi-cash</v-icon></span>
                </v-card>
                <v-card class="accountCard" shaped dark>
                    <v-card-title>Shared Account</v-card-title>
                    <v-card-subtitle>${{personalAccountMoney}}</v-card-subtitle>
                    <v-card-actions>
                        <v-btn class="btn" text outlined color="indigo accent-1">More Details</v-btn>
                    </v-card-actions>
                    <span class="cardIcon"><v-icon style="font-size: 54px;" color="rgba(0, 0, 0, 0.45)">mdi-cash-multiple</v-icon></span>
                </v-card>
                <v-card class="accountCard" shaped dark>
                    <v-card-title>Business Account</v-card-title>
                    <v-card-subtitle>${{personalAccountMoney}}</v-card-subtitle>
                    <v-card-actions>
                        <v-btn class="btn" text outlined color="indigo accent-1">More Details</v-btn>
                    </v-card-actions>
                    <span class="cardIcon"><v-icon style="font-size: 54px;" color="rgba(0, 0, 0, 0.45)">mdi-currency-usd</v-icon></span>
                </v-card>
            </div>
        </v-app>
    </div>
</template>

<script>

export default {
    name: 'BankApp',
    components: {
    },
    data: () => ({
        userName: "Mack",
        personalAccountMoney: 1000000,
        lastestPersonalAccountTransaction: +1000000
    }),
    mounted() {
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
    padding-top: 20px;
    height: 120px;
    background: linear-gradient(to top right, #6A7DE3, #4c59a0, #42488a);
}

.appBar p {
    position: absolute;
    top: 53px;
    left: 15px;
    font-size: 25px;
}

.appIcon {
    position: absolute;
    top: 28px;
    left: 196px;
    font-size: 27px;
    transform: rotate(7deg);
}

.mainBtn {
    position: absolute;
    width: fit-content !important;
    height: 35px !important;
    top: 93px;
    left: 14px;
    z-index: 1;
}

.appContainer {
    width: 305px;
    max-width: 305px;
    height: 432px;
    max-height: 432px;
    padding-left: 7px;
    padding-right: 7px;
    font-size: 17px;
    overflow-y: auto;
}

.accountCard {
    margin-top: 18px;
}

.cardIcon {
    position: absolute;
    right: 18px;
    bottom: 10px;
}

</style>