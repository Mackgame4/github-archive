<template>
    <v-dialog v-model="showing" persistent origin="bottom" scrollable hide-overlay content-class="phoneDialog">
        <v-card v-if="loading">
            <div class="loadContainer">
                <SpinnyLoader :completed="loadingActive" :successState="loadingState" class="actualFuckingLoader" />
            </div>
        </v-card>
        <v-card v-else>
            <v-card-title class="title">Move ${{ amount }} to:</v-card-title>
            <div class="inputs">
                <v-text-field append-icon="mdi-bank" color="red darken-4" label="Account Number" placeholder="###-###-###" v-mask="'###-###-###'"></v-text-field>
            </div>
            <v-card-actions>
                <v-btn color="red darken-4" text @click="closeDeny">Cancel</v-btn>
                <v-spacer></v-spacer>
                <v-btn color="red darken-4" text @click="moveToAccount">Move</v-btn>
            </v-card-actions>
        </v-card>
    </v-dialog>
</template>

<script>

export default {
    name: 'DialogsContactEdit',
    components: {
    },
    data: () => ({
        loading: false,
        loadingActive: false,
        loadingState: true,
        amount: 100000,
    }),
    props: {
        showing: {
            required: true,
            type: Boolean,
        },
    },
    methods: {
        closeDeny() {
            this.$emit('deny');
        }
    }
};

</script>

<style scoped lang="less">
@import '@/arp-theme.less';

.inputs {
    padding: 0 5%;
}

.loadContainer {
    height: 250px;
    .actualFuckingLoader {
        width: 150px; 
        height: 150px;
        display: block;
        margin: 50px auto;
    }
}

.title {
    margin-left: -10px;
}
</style>
