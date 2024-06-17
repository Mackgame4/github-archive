<template>
   <v-dialog v-model="showingDialog" :persistent="loadingShow" max-width="500px">
       <v-card dark v-if="loadingShow">
            <br>
            <v-card-text>
                <v-container style="height: 25vh;">
                <v-row class="fill-height" align-content="center" justify="center">
                    <spinny-loader :completed="!loadingActive" :successState="loadingSuccess" style="width: 20vh; height: 20vh;" />
                </v-row>
                </v-container>
            </v-card-text>
        </v-card>
        <v-card dark v-else-if="!loadingShow && actionType === 1">
            <br>
            <div class="accountBox">
                <h2>{{ actionAccount.account }} - {{ accountTypes[actionAccount.type] }}</h2>
                <h1>{{ actionAccount.balance | money }}</h1>
                <h5>Current Balance</h5>
            </div>
            <v-card-title class="justify-center">
                <span class="bankCardTitle">Cash Withdrawal</span>
            </v-card-title>
            <v-card-text>
                <v-container>
                    <v-col>
                        <v-row>
                            <v-text-field
                                label="Withdrawal Amount"
                                :hint="`${atm ? `ATM Withdrawal Limit: $${limit}` : `Max Withdrawal: $${actionAccount.balance}`}`"
                                ref="withdraw"
                                v-model="withdrawalAmount"
                                v-currency="currencyOptions"
                                color="grey"
                            ></v-text-field>
                        </v-row>
                        <v-row>
                            <v-textarea
                                label="Withdrawal Description"
                                hint="This is not required."
                                persistent-hint
                                v-model="description"
                                color="grey"
                                :rows="2" no-resize auto-grow
                            ></v-textarea>
                        </v-row>
                    </v-col>
                </v-container>
            </v-card-text>
            <v-card-actions class="justify-center">
                <v-btn color="grey lighten-5" text @click="showingDialog = false">
                    Cancel
                </v-btn>
                <v-btn color="red darken-4" text @click="withdraw">
                    Withdraw
                </v-btn>
            </v-card-actions>
        </v-card>
        <v-card dark v-else-if="!loadingShow && actionType === 2">
            <br>
            <div class="accountBox">
                <h2>{{ actionAccount.account }} - {{ accountTypes[actionAccount.type] }}</h2>
                <h1>{{ actionAccount.balance | money }}</h1>
                <h5>Current Balance</h5>
            </div>
            <v-card-title class="justify-center">
                <span class="bankCardTitle">Cash Deposit</span>
            </v-card-title>
            <v-card-text>
                <v-container>
                    <v-col>
                        <v-row>
                            <v-text-field
                                label="Deposit Amount"
                                :hint="`Max Deposit Cash: $${cash}`"
                                ref="deposit"
                                v-model="depositAmount"
                                v-currency="currencyOptions2"
                                color="grey"
                            ></v-text-field>
                        </v-row>
                        <v-row>
                            <v-textarea
                                label="Deposit Description"
                                hint="This is not required."
                                persistent-hint
                                v-model="description"
                                color="grey"
                                :rows="2" no-resize auto-grow
                            ></v-textarea>
                        </v-row>
                    </v-col>
                </v-container>
            </v-card-text>
            <v-card-actions class="justify-center">
                <v-btn color="grey lighten-5" text @click="showingDialog = false">
                    Cancel
                </v-btn>
                <v-btn color="green darken-2" text @click="deposit">
                    Deposit
                </v-btn>
            </v-card-actions>
        </v-card>
        <v-card dark v-else-if="!loadingShow && actionType === 3">
            <br>
            <div class="accountBox">
                <h2>{{ actionAccount.account }} - {{ accountTypes[actionAccount.type] }}</h2>
                <h1>{{ actionAccount.balance | money }}</h1>
                <h5>Current Balance</h5>
            </div>
            <v-card-title class="justify-center">
                <span class="bankCardTitle">Bank Transfer</span>
            </v-card-title>
            <v-card-text>
                <v-container>
                    <v-col>
                        <v-row>
                            <v-text-field
                                label="Transfer Amount"
                                :hint="`Max Available Money For Transfer: $${actionAccount.balance}`"
                                v-model="transferAmount"
                                ref="transfer"
                                v-currency="currencyOptions3"
                                color="grey"
                            ></v-text-field>
                        </v-row>
                        <v-row>
                            <v-text-field
                                label="Transfer to CID"
                                hint="Either transfer to an account by CID or Account Number."
                                v-model="transferCID"
                                v-mask="'#####'"
                                :disabled="transferAccount.length > 0"
                                color="grey"
                            ></v-text-field>
                        </v-row>
                        <v-row>
                            <v-text-field
                                label="Transfer to Account Number"
                                hint="Either transfer to an account by CID or Account Number."
                                v-model="transferAccount"
                                v-mask="'#########'"
                                :disabled="transferCID.length > 0"
                                color="grey"
                            ></v-text-field>
                        </v-row>
                        <v-row>
                            <v-textarea
                                label="Transfer Description"
                                hint="This is not required."
                                persistent-hint
                                v-model="description"
                                color="grey"
                                :rows="2" no-resize auto-grow
                            ></v-textarea>
                        </v-row>
                    </v-col>
                </v-container>
            </v-card-text>
            <v-card-actions class="justify-center">
                <v-btn color="grey lighten-5" text @click="showingDialog = false">
                    Cancel
                </v-btn>
                <v-btn color="light-blue darken-4" text @click="transfer">
                    Transfer
                </v-btn>
            </v-card-actions>
        </v-card>
    </v-dialog>
</template>

<script>
//import Nui from '../../utils/Nui';
import SpinnyLoader from '../Loader';
import { parse } from "vue-currency-input";
import Nui from '../../utils/Nui';
import { accountTypes } from './accountTypes';
export default {
    components: {
        SpinnyLoader,
    },
    props: {
        cash: {
            required: true,
        },
        limit: {
            required: true,
        },
        atm: {
            required: true,
        }
    },
    data: () => ({
        showingDialog: false,
        accountTypes: accountTypes,
        actionType: false,
        loadingShow: true,
        loadingActive: false,
        loadingSuccess: true,
        actionAccount: false,
        withdrawalAmount: '$500.00',
        depositAmount: '$500.00',
        transferAmount: '$500.00',
        description: '',
        transferAccount: '',
        transferCID: '',
        currencyOptions: {
            currency: 'USD',
            locale: 'en',
            allowNegative: false,
            distractionFree: true,
            valueRange: { min: 1, max: 1000 },
        },
        currencyOptions2: {
            currency: 'USD',
            locale: 'en',
            allowNegative: false,
            distractionFree: true,
            valueRange: { min: 1, max: 1000 },
        },
        currencyOptions3: {
            currency: 'USD',
            locale: 'en',
            allowNegative: false,
            distractionFree: true,
            valueRange: { min: 1, max: 1000 },
        }
    }),
    mounted() {
        this.$root.$on('bankForceDialogClose', () => {
            this.showingDialog = false;
            this.loadingShow = false;
        });

        this.$root.$on('bankStartActionWithdrawal', (accountData) => {
            if (accountData.permissions?.withdraw) {
                this.loadingShow = false;
                this.actionAccount = accountData;
                if (this.atm) {
                    console.log('nodders')
                    if (accountData.balance > this.limit) {
                        this.currencyOptions.valueRange.max = this.limit;
                    } else {
                        this.currencyOptions.valueRange.max = accountData.balance;
                    }
                } else {
                    console.log('nopers')
                    this.currencyOptions.valueRange.max = accountData.balance;
                }
                this.description = '';
                this.actionType = 1;
                this.showingDialog = true;
            }
        });

        this.$root.$on('bankStartActionDeposit', (accountData) => {
            if (accountData.permissions?.deposit) {
                this.loadingShow = false;
                this.actionAccount = accountData;
                this.currencyOptions2.valueRange.max = this.cash;
                this.description = '';
                this.actionType = 2;
                this.showingDialog = true;
            }
        });

        this.$root.$on('bankStartActionTransfer', (accountData) => {
            if (accountData.permissions?.withdraw) {
                this.loadingShow = false;
                this.actionAccount = accountData;
                this.transferAccount = '';
                this.transferCID = '';
                this.currencyOptions3.valueRange.max = accountData.balance;
                this.description = '';
                this.actionType = 3;
                this.showingDialog = true;
            }
        });
    },
    methods: {
        startLoading() {
            this.loadingActive = true;
            this.loadingShow = true;
        },
        async finishLoading(success = false) {
            this.loadingSuccess = success;
            this.loadingActive = false;
            await Nui.doDelay(600);
            this.showingDialog = false;
            await Nui.doDelay(300)
            this.loadingShow = false;
        },
        async withdraw() {
            const amount = Math.round(parse(this.withdrawalAmount, this.currencyOptions));
            if (amount && amount > 0 && this.actionAccount.balance >= amount) {
                const description = this.description;
                this.startLoading();
                console.log(amount);
                const res = await Nui.send('bankDoWithdrawal', {
                    account: this.actionAccount?.account,
                    amount,
                    description,
                });
                await Nui.doDelay(500);
                if (res?.success) {
                    this.finishLoading(true);
                } else {
                    this.finishLoading();
                }
            }
        },
        async deposit() {
            const amount = Math.round(parse(this.depositAmount, this.currencyOptions2));
            if (amount && amount > 0 && this.cash >= amount) {
                const description = this.description;
                this.startLoading();
                console.log(amount);
                const res = await Nui.send('bankDoDeposit', {
                    account: this.actionAccount?.account,
                    amount,
                    description,
                });
                await Nui.doDelay(500);
                if (res?.success) {
                    this.finishLoading(true);
                } else {
                    this.finishLoading();
                }
            }
        },
        async transfer() {
            const amount = Math.round(parse(this.transferAmount, this.currencyOptions3));
            if (amount && amount > 0 && this.actionAccount.balance >= amount) {
                console.log(amount);
                const description = this.description;
                let target = false;
                let withCID = false;
                if (this.transferAccount.length === 9) {
                    target = parseInt(this.transferAccount);
                    withCID = false;
                } else if (this.transferCID.length === 5) {
                    target = parseInt(this.transferCID);
                    withCID = true;
                }
                if (target) {
                    this.startLoading();
                    const res = await Nui.send('bankDoTransfer', {
                        account: this.actionAccount?.account,
                        sendTo: target,
                        sendWithCID: withCID,
                        amount,
                        description,
                    });
                    await Nui.doDelay(500);
                    if (res?.success) {
                        this.finishLoading(true);
                    } else {
                        this.finishLoading();
                    }
                }
            }
        }
    },
    watch: {
        transferAccount(val) {
            if (val.length > 0) {
                this.transferCID = '';
            }
        },
        transferCID(val) {
            if (val.length > 0) {
                this.transferAccount = '';
            }
        } 
    }
}
</script>

<style lang="less" scoped>
@import '@/arp-theme.less';

@bankBackground: #263238;

.bankCardTitle {
    font-size: 2vh;
    font-weight: 400;
}

.accountBox {
    width: 60%;
    margin: 0 20%;
    padding: 1.25vh .75vh;
    border-radius: .5vh;
    transition: .25s;
    text-align: center;
    border: 1.5px solid @light;
    background: #37474F; // blue-grey darken-3
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
}

</style>