<template>
    <div>
        <component v-bind:is="dialogType" :showing="showingADialog" :data="data" @confirm="closeConfirm" @deny="closeDeny" />
    </div>
</template>

<script>

import DialogsConfirmDeny from './ConfirmDeny';
import DialogsContactEdit from './ContactEdit';
import DialogsBankAccountEdit from './BankAccountEdit';
import DialogsTwitterTweet from './TwitterTweet';
import DialogsAdvertCreate from './AdvertCreate';

const DialogData = {
    ConfirmDeny: {
        component: 'DialogsConfirmDeny',
        closeWithApp: false,
    },
    ContactEdit: {
        component: 'DialogsContactEdit',
        closeWithApp: true,
    },
    BankAccountEdit: {
        component: 'DialogsBankAccountEdit',
        closeWithApp: true,
    },
    Twitter: {
        component: 'DialogsTwitterTweet',
        closeWithApp: true,
    },
    Advert: {
        component: 'DialogsAdvertCreate',
        closeWithApp: true,
    }
}

export default {
    name: 'Dialogs',
    components: {
        DialogsConfirmDeny,
        DialogsContactEdit,
        DialogsBankAccountEdit,
        DialogsTwitterTweet,
        DialogsAdvertCreate,
    },
    data: () => ({
        showingADialog: false,
        dialogType: false,
        dialogData: {},
        data: {},
        cb: null,
    }),
    props: {

    },
    methods: {
        closeConfirm() {
            this.showingADialog = false;
            setTimeout(() => {
                this.dialogType = false;
            }, 200);
            this.$emit('overlay', false);
            if (this.cb) {
                this.cb(false, {});
            }
        },
        closeDeny() {
            this.showingADialog = false;
            setTimeout(() => {
                this.dialogType = false;
            }, 200);
            if (this.cb) {
                this.cb(false, {});
            }
        },

        showDialog(type, data, cb) {
            if (!this.showingADialog && DialogData[type] && data) {
                this.dialogType = false;
                this.dialogType = DialogData[type].component;
                this.dialogData = DialogData[type];
                this.data = data;
                this.showingADialog = true;
                this.cb = cb;
            } else {
                if (cb) {
                    cb(false);
                }
            }
        },
        forceHide() {
            this.showingADialog = false;
            setTimeout(() => {
                this.dialogType = false;
            }, 400);
        },

        handleAppClosing() {
            if (this.dialogData.closeWithApp) {
                this.forceHide();
            }
        }
    },
    computed: {
    },
    mounted() {
        this.$root.$on('dialogs:show', this.showDialog);
        this.$root.$on('dialogs:forceHide', this.forceHide);
        this.$root.$on('appJustClosed', this.handleAppClosing);
    },
    beforeDestroy() {
        this.$root.$off('dialogs:show', this.showDialog);
        this.$root.$off('dialogs:forceHide', this.forceHide);
        this.$root.$off('appJustClosed', this.handleAppClosing);
    },
    watch: {
        showingADialog(val) {
            this.$emit('overlay', val);
        }
    }
};

/*

* DialogsConfirmDeny
{
    title: String,
    text: String,
    confirmButton: {
        text: String,
        color: String,
    },
    denyButton: {
        text: String,
        color: String,
    }
}

* ContactEdit
{
    type: boolean - true is Add or Edit
    name: string,
    number string,
}

*/

</script>

<style lang="less">
@import '@/arp-theme.less';

.phoneDialog {
    position: fixed;
    right: calc(21.5px + (var(--inner-padding-width) / 2));
    max-width: calc(var(--outer-width) - var(--inner-padding-width) - 20px);
    max-height: calc(var(--outer-height) - var(--inner-padding-height) - (150px * var(--resize-percentage)));
    bottom: calc(90px * var(--resize-percentage));
    margin: 0 !important;
}
</style>
