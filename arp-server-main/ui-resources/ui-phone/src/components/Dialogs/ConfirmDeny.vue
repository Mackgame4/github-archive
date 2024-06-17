<template>
    <v-dialog v-model="showing" @click:outside="closeDeny" origin="bottom" scrollable hide-overlay content-class="phoneDialog">
        <v-card>
            <v-card-title v-if="data.title" v-html="data.title"></v-card-title>
            <v-card-text v-if="data.text" v-html="data.text"></v-card-text>

            <v-card-actions>
                <v-spacer></v-spacer>
                <v-btn :color="data.denyButton.color" text @click="closeDeny" v-text="data.denyButton.text"></v-btn>
                <v-btn :color="data.confirmButton.color" text @click="closeConfirm" v-text="data.confirmButton.text"></v-btn>
            </v-card-actions>
        </v-card>
    </v-dialog>
</template>

<script>
export default {
    name: 'DialogsConfirmDeny',
    components: {

    },
    props: {
        showing: {
            required: true,
            type: Boolean,
        },
        data: {
            required: true,
            type: Object,
        },
    },
    methods: {
        closeConfirm() {
            this.$emit('confirm');
        },
        closeDeny() {
            this.$emit('deny');
        }
    },
    computed: {
        
    },
};

</script>

<style scoped lang="less">
@import '@/arp-theme.less';
</style>
