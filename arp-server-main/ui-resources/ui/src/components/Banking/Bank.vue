<template>
<div>
<bank-dialog :cash="cash" :limit="atmLimit" :atm="isATM" />
<transition name="bank">
    <div class="bankContainer" v-if="show">
        <div class="bankHeader noSelect">
            <h5>Available Cash In Hand: {{ cash | money }}</h5>
            <v-spacer></v-spacer>
            <h5>Hello, {{ name }}</h5>
        </div>
        <v-divider></v-divider>

        <div class="accountList" ref="accountList" @wheel="handleScroll">
            <div class="accountBox" :class="{ current: viewingAccount.account === account.account }" v-for="account in availableAccounts" v-bind:key="account.account" @click="switchToAccount(account)">
                <h2>{{ account.account }} - {{ accountTypes[account.type] }}</h2>
                <h1>{{ account.balance | money }}</h1>
                <h5>Current Balance</h5>
                <div class="actions">
                    <v-btn outlined color="red darken-4" @click.stop="startBankAction(account, 'withdraw')" :disabled="!account.permissions.withdraw">Withdraw</v-btn>
                    <v-btn outlined color="green darken-2" @click.stop="startBankAction(account, 'deposit')" :disabled="isATM || !account.permissions.deposit">Deposit</v-btn>
                </div>
            </div>
            <div class="accountBoxSpacer"></div>
        </div>

        <v-divider></v-divider>
        <div class="currentContent">
            <div class="bankData" v-if="viewingAccount">
                <h3 class="noSelect">{{ accountTypes[viewingAccount.type] }}</h3><br>
                <h1 class="accountNum">{{ viewingAccount.account }}</h1>
                <h5 class="noSelect">Account Number</h5><br>
                <h1 class="balance">{{ viewingAccount.balance | money }}</h1>
                <h5 class="noSelect">Current Account Balance</h5>
                <v-spacer></v-spacer>
                <div class="bankActions">
                    <v-btn class="mb-2" :disabled="!viewingAccount.permissions.withdraw" color="red darken-4" @click.stop="startBankAction(viewingAccount, 'withdraw')">Withdraw Cash</v-btn>
                    <v-btn class="mb-2" :disabled="isATM || !viewingAccount.permissions.deposit" v-if="!isATM" color="green darken-2" @click.stop="startBankAction(viewingAccount, 'deposit')">Deposit Cash</v-btn>
                    <v-btn class="mb-2" :disabled="!viewingAccount.permissions.withdraw" color="light-blue darken-4" @click.stop="startBankAction(viewingAccount, 'transfer')">Bank Transfer</v-btn>
                </div>
                <v-spacer></v-spacer>
            </div>
            <v-divider vertical></v-divider>
            <div class="bankTransactions" v-if="viewingAccount">
                <h3 class="noSelect">Recent Transaction History</h3>
                <div class="transactionList" v-if="accountTransactions && !failedTransactionFetch">
                    <div class="transaction" v-for="transaction in accountTransactions" v-bind:key="transaction._id">
                        <h3>{{ transaction.value > 0 ? 'Incoming Payment' : 'Outgoing Payment' }} {{ transaction.fromAccount ? transaction.value > 0 ? `from account` : `to account` : '' }} <b>{{ transaction.fromAccount || '' }}</b></h3>
                        <div class="transactionInner">
                            <div class="money">
                                <h1 :class="transaction.value > 0 ? 'incoming' : 'outgoing'">{{ transaction.value | money }}</h1>
                            </div>
                            <div>
                                <p v-text="transaction.description"></p>
                            </div>
                            <div class="iconOuter">
                                <v-icon class="icon" right>{{ transaction.value > 0 ? 'mdi-bank-transfer-in' : 'mdi-bank-transfer-out' }}</v-icon>
                            </div>
                        </div>
                        <div class="footer">
                            <h3>{{ getHumanFormattedTime(transaction.time) }}</h3>
                            <v-spacer></v-spacer>
                            <h5>{{ transaction._id }}</h5>
                        </div>
                    </div>
                </div>
                <div class="transactionList" v-else>
                    <div style="width: 100%; height: 100%; display: flex; flex-direction: row;">
                        <v-spacer></v-spacer>
                        <spinny-loader :completed="failedTransactionFetch" :successState="false" style="margin-top: 10%; width: 20vh; height: 20vh;" />
                        <v-spacer></v-spacer>
                    </div>
                </div>
            </div>
        </div>
        <v-divider></v-divider>
        <div class="bankHeader noSelect">
            <v-icon class="icon">mdi-bank</v-icon>
            <h3>Penguin Bank</h3>
            <v-spacer></v-spacer>
            <v-btn small icon @click="startCloseBanking"><v-icon class="icon">mdi-close</v-icon></v-btn>
        </div>
    </div>
</transition>
</div>
</template>

<script>
import Nui from '../../utils/Nui';
import SpinnyLoader from '../Loader';
import BankDialog from './BankDialog';
import { accountTypes } from './accountTypes';
import moment from 'moment';

export default {
    name: 'Bank',
    components: {
        SpinnyLoader,
        BankDialog,
    },
    data: () => ({
        name: '',
        isATM: false,
        atmLimit: 25000,
        show: false,
        cash: 1000,
        accountTypes: accountTypes,
        availableAccounts: [],
        viewingAccount: false,
        accountTransactions: false,
        failedTransactionFetch: false,
    }),
    mounted() {
        this.$root.$on('bankUpdate', ({ availableAccounts, cash, charName, atmLimit }) => {
            if (availableAccounts) {
                let hadIndex = -1;
                if (this.show) {
                    const currentlyViewingAccountNum = this.viewingAccount.account;
                    hadIndex = availableAccounts.findIndex(x => x.account = currentlyViewingAccountNum);
                }
                this.availableAccounts = availableAccounts;

                if (hadIndex >= 0) {
                    this.switchToAccount(this.availableAccounts[hadIndex], true);
                }
            }
            if (typeof(atmLimit) === 'number') {
                console.log(atmLimit)
                this.atmLimit = atmLimit;
            }
            if (typeof(cash) === 'number') {
                this.cash = cash;
            }
            if (typeof(charName) === 'string') {
                this.name = charName;
            }
        });

        this.$root.$on('bankUpdateSpecificBalance', ({ accountNum, newBalance, newCash }) => {
            if (typeof(newCash) === 'number') {
                this.cash = newCash;
            }

            const accountPosition = this.availableAccounts.findIndex(x => x.account = accountNum);
            if (accountPosition >= 0) {
                this.availableAccounts[accountPosition].balance = newBalance;
                if (this.viewingAccount && this.viewingAccount.account == accountNum) {
                    this.switchToAccount(this.availableAccounts[accountPosition], true);
                }
            }
        });

        this.$root.$on('openBanking', ({ isATM }) => {
            this.isATM = isATM;
            this.switchToAccount(this.availableAccounts[0], true);
            this.show = true;
        });

        this.$root.$on('closeBanking', () => {
            this.finishCloseBanking();
        });

        if (Nui.inDev()) {
            setTimeout(() => {
                this.$root.$emit('bankUpdate', {
                    availableAccounts: [
                        { type: 1, account: 123456789, balance: 5000, permissions: { deposit: true, withdraw: true } },
                        { type: 2, account: 123456788, balance: 50000, permissions: { deposit: true, withdraw: false } },
                    ],
                });
    
                this.$root.$emit('openBanking', {
                    isATM: true,
                });
            }, 1000);
            Nui.addEmulatedResponse('bankingGetTransactions', { 
                success: true, 
                data: [
                    { _id: 'as12313314sdf', fromAccount: 12123123, time: 1615731923, value: -1000, description: 'This is nice' },
                    { _id: 'as12313314sdfs', fromAccount: 12123123, time: 1615731023, value: 100000000, description: 'This is nice' },
                    { _id: 'as12313314sdfg', fromAccount: 12123123, time: 1615731923, value: -1000, description: 'This is nice' },
                    { _id: 'as12313314sdfa', fromAccount: 12123123, time: 1615731923, value: -1000, description: 'This is nice' },
                ]
            });

            Nui.addEmulatedResponse('bankDoWithdrawal', { success: true });
            Nui.addEmulatedResponse('bankDoDeposit', { success: true });
            Nui.addEmulatedResponse('bankDoTransfer', { success: true });
            Nui.addEmulatedResponse('bankStartClose', { success: true });
        }


    },
    methods: {
        async finishCloseBanking() {
            this.$root.$emit('bankForceDialogClose');
            this.show = false;
        },
        startCloseBanking() {
            Nui.send('bankStartClose', {});
        },
        handleScroll(e) {
            this.$refs.accountList.scrollLeft += e.deltaY / 2;
        },
        async switchToAccount(accountData, forced) {
            if (!this.viewingAccount || this.viewingAccount?.account !== accountData.account || forced) {
                this.accountTransactions = null;
                this.failedTransactionFetch = false;
                this.viewingAccount = false;
                this.viewingAccount = accountData;
                const res = await Nui.send('bankingGetTransactions', accountData.account);
                await Nui.doDelay(500);
                if (res?.success) {
                    this.accountTransactions = res.data.sort((a, b) => b.time - a.time);
                } else {
                    this.failedTransactionFetch = true;
                }
            }
        },
        startBankAction(account, action) {
            if (action === 'withdraw') {
                this.$root.$emit('bankStartActionWithdrawal', account);
            } else if (action === 'deposit') {
                this.$root.$emit('bankStartActionDeposit', account);
            } else if (action === 'transfer') {
                this.$root.$emit('bankStartActionTransfer', account);
            }
        },
        getHumanFormattedTime(time) {
            return moment.unix(time).fromNow();
        },
    },
}
</script>

<style lang="less" scoped>
@import '@/arp-theme.less';

@bankBackground: #424242dc;

.noSelect {
    user-select: none;
}

.bankContainer {
    display: flex;
    flex-direction: column-reverse;
    background: @bankBackground;
    position: fixed;
    height: 75vh;
    width: 120vh;
    top: 10vh;
    left: 50%;
    transform: translateX(-50%);
    box-shadow: 4px 4px 12px 4px rgba(0, 0, 0, 0.392);
    padding: 1.5vh 2vh;
    .bankHeader {
        display: flex;
        flex-direction: row;
        width: 100%;
        height: 5%;
        .icon {
            font-size: 2.8vh;
        }
        h3 {
            position: absolute;
            left: 50%;
            transform: translateX(-50%);
            font-weight: 500;
            margin-bottom: .5%;
            font-size: 1.8vh;
        }
        h5 {
            font-weight: 300;
            margin-top: .5%;
            font-size: 1.5vh;
        }
    }
    .currentContent {
        width: 100%;
        height: 65%;
        //padding-top: 1vh;
        display: flex;
        flex-direction: row;
        h3 {
            font-size: 2vh;
            font-weight: 300;
            text-align: center;
            height: 8%;
        }
        .bankData {
            width: 35%;
            height: 100%;
            text-align: center;
            display: flex;
            flex-direction: column;
            padding: 1vh 2vh;
            .balance {
                font-size: 4vh;
                line-height: 4vh;
                font-weight: 300;
            }
            .accountNum {
                font-size: 3vh;
                line-height: 3vh;
                font-weight: 300;
            }
            .bankActions {
                padding: 0 10%;
                display: flex;
                flex-direction: column;
            }
        }
        .bankTransactions {
            width: 65%;
            height: 100%;
            padding: 1vh 2vh;
            .transactionList {
                display: flex;
                flex-direction: column;
                height: 92%;
                overflow-y: auto;
                .transaction {
                    display: flex;
                    flex-direction: column;
                    width: 99%;
                    //min-height: 30%;
                    margin-bottom: 0.75vh;
                    background: #455A64;
                    border-radius: .5vh;
                    border: 1.5px solid @medium;
                    padding: .75vh 1.2vh;
                    h3 {
                        font-size: 1.5vh;
                        text-align: left;
                        height: 25%;
                        margin-bottom: 1vh;
                        b {
                            font-weight: 500;
                        }
                    }
                    .transactionInner {
                        display: flex;
                        flex-direction: row;
                        width: 100%;
                        h1 {
                            font-weight: 300;
                            line-height: 3.2vh;
                            font-size: 3vh;
                            margin-top: 2%;
                            &.incoming {
                                color: #43A047;
                            }
                            &.outgoing {
                                color: #D50000;
                            }
                        }
                        p {
                            font-weight: 300;
                            font-size: 1.3vh;
                        }
                        div {
                            width: 50%;
                        }
                        .money {
                            width: 40%;
                        }
                        .iconOuter {
                            width: 10%;
                            height: 100%;
                            .icon {
                                font-size: 5.5vh;
                                width: 90%;
                                height: 80%;
                            }
                        }
                    }
                    .footer {
                        display: flex;
                        flex-direction: row;
                        //height: 50%;
                        width: 100%;
                        h3 {
                            font-size: 1.5vh;
                            text-align: left;
                        }
                        h5 {
                            font-size: 1.25vh;
                            font-weight: 300;
                            text-align: right;
                            color: rgba(223, 223, 223, 0.686);
                        }
                    }
                }
            }
        }
    }
    .accountList {
        display: flex;
        flex-direction: row;
        width: 100%;
        height: 25%;
        padding: 1.5vh 2vh;
        overflow-x: auto;
        .accountBox {
            background:#455A64; // blue-grey darken-2
            min-width: 25%;
            margin-right: 10px;
            padding: .75vh;
            border-radius: .5vh;
            transition: .25s;
            text-align: center;
            border: 1.5px solid @medium;
            .splitContainer {
                display: flex;
                flex-direction: row;
            }
            h1 {
                font-weight: 300;
                line-height: 3.2vh;
                font-size: 3vh;
                user-select: none;
            }
            h5 {
                font-weight: 400;
                font-size: 1.2vh;
                user-select: none;
            }
            h2 {
                font-weight: 400;
                font-size: 1.5vh;
                line-height: 2.5vh;
                user-select: none;
            }
            .actions {
                display: flex;
                flex-direction: row;
                margin-top: 1vh;
                width: 100%;
                justify-content: space-around;
            }
            &.current {
                background: #37474F; // blue-grey darken-3
                border: 1.5px solid @light;
            }
            &:hover {
                border: 1.5px solid @light;
            }
        }
        .accountBoxSpacer {
            min-width: 10%;
        }
    }
}

&::-webkit-scrollbar {
    height: 5px;
    width: 5px;
    border-radius: 5px;
}
&::-webkit-scrollbar-track {
    background: transparent; 
}
&::-webkit-scrollbar-thumb {
    background: @dark;
    border-radius: 5px; 
}


.bank-enter-active {
    animation: bank-transition .5s;
}
.bank-leave-active {
    animation: bank-transition .5s reverse;
}

@keyframes bank-transition {
    0% {
        transform: translateX(-50%) translateY(130%);
    }
    100% {
        transform: translateX(-50%) translateY(0);
    }
}

</style>