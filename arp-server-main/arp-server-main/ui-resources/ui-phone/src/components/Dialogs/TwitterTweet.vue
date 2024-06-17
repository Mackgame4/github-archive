<template>
    <v-dialog v-model="showing" persistent origin="bottom" scrollable hide-overlay content-class="phoneDialog">
        <v-card v-if="loading">
            <div class="loadContainer">
                <spinny-loader :completed="loadingActive" :successState="loadingState" class="actualFuckingLoader" />
            </div>
        </v-card>
        <v-card v-else>
            <v-card-title>Tweet</v-card-title>
            <div class="inputs">
                <v-textarea :disabled="data.rt" v-model="tweet" auto-grow color="blue darken-2" counter="144" rows="1" maxlength="144"></v-textarea>  
                <v-text-field :disabled="data.rt" v-model="image" color="blue darken-2" label="Attach Image" hint="This is optional" persistent-hint :error="imageError" :error-messages="imageError ? 'Invalid URL (Must be HTTPS and end in a valid file extension)' : ''" maxlength="50"></v-text-field>
            </div>
            <v-card-actions>
                <v-btn color="red darken-4" text @click="closeDeny">Dismiss</v-btn>
                <v-spacer></v-spacer>
                <v-btn color="blue darken-2" text @click="closeConfirm" v-if="data.rt">Retweet</v-btn>
                <v-btn color="blue darken-2" text @click="closeConfirm" v-else>Tweet</v-btn>
            </v-card-actions>
        </v-card>
    </v-dialog>
</template>

<script>

import SpinnyLoader from '../../components/Loader';
import { isImageUrlValid } from '../../utils/utils';
import Nui from '../../utils/Nui';

export default {
    name: 'DialogsTwitterTweet',
    components: {
        SpinnyLoader,
    },
    data: () => ({
        loading: false,
        loadingActive: false,
        loadingState: true,
        tweet: '',
        image: '',
        imageError: false,
        timeout: null,
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
        console.log(this.data.rt)
        if (this.data.rt) {
            this.tweet = `RT via ${this.data.rt.tweeter}: ${this.data.rt.content}`;
            this.image = this.data.rt.image;
        } else if (this.data.reply) {
            this.tweet = `${this.data.reply} `
        }
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

            if (this.imageError || this.tweet.length < 1) {
                return;
            }

            this.startLoading();
            await Nui.doDelay(500);

            const success = await this.$store.dispatch('sendTweet', { content: this.tweet, image: this.image.length > 0 ? this.image : false });

            this.finishLoading(success);
            await Nui.doDelay(650);
            this.$emit('confirm');
        },
        closeDeny() {
            this.$emit('deny');
        }
    },
    watch: {
        image(val) {
            if (val.length >= 1) {
                this.imageError = !isImageUrlValid(val);
            } else {
                this.imageError = false;
            }
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
</style>
