<template>
    <v-dialog v-model="showing" persistent origin="bottom" scrollable hide-overlay content-class="phoneDialog">
        <v-card v-if="loading">
            <div class="loadContainer">
                <spinny-loader :completed="loadingActive" :successState="loadingState" class="actualFuckingLoader" />
            </div>
        </v-card>
        <v-card v-else>
            <v-card-title>Create Advert</v-card-title>
            <v-card-text>This will override any current advertisements you have posted on the board. Posting an advertisement will also post your full name and phone number alongside it.</v-card-text>
            <div class="inputs">
                <v-textarea v-model="advert" auto-grow color="deep-purple lighten-1" counter="255" rows="1" maxlength="255"></v-textarea>  
            </div>
            <v-card-actions>
                <v-btn color="red darken-4" text @click="closeDeny">Cancel</v-btn>
                <v-spacer></v-spacer>
                <v-btn color="deep-purple lighten-1" text @click="closeConfirm">Add</v-btn>
            </v-card-actions>
        </v-card>
    </v-dialog>
</template>

<script>

import SpinnyLoader from '../../components/Loader';
import Nui from '../../utils/Nui';

export default {
    name: 'DialogsAdvertCreate',
    components: {
        SpinnyLoader,
    },
    data: () => ({
        loading: false,
        loadingActive: false,
        loadingState: true,
        advert: '',
    }),
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
    mounted() {

    },
    methods: {
        startLoading() {
            this.loadingActive = false;
            this.loading = true;
        },
        async finishLoading(state) {
            this.loadingState = state;
            this.loadingActive = true;
            await Nui.doDelay(900);
            this.loading = false;
        },
        async closeConfirm() {

            if (!this.advert || this.advert.length < 2) {
                return;
            }
            
            this.startLoading();
            await Nui.doDelay(500);
            const res = await Nui.send('postAdvert', { advert: this.advert });
            const success = res && res.success;
            this.finishLoading(success);
            await Nui.doDelay(650);
            this.$emit('confirm');
        },
        closeDeny() {
            this.$emit('deny');
        }
    },
    watch: {
        
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
</style>
