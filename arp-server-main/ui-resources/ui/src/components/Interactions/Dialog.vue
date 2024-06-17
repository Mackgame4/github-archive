<template>
    <v-dialog v-model="showing" persistent max-width="500px">
        <v-card dark>
            <v-card-title class="justify-center" v-if="cardTitle"><span class="headline">{{ cardTitle }}</span></v-card-title>
            <v-card-text class="justify-center text-center" v-if="cardText" v-html="cardText"></v-card-text>
            <v-card-text v-if="cardLoading" style="height: 25vh;">
                <v-row class="fill-height" align-content="center" justify="center">
                    <spinny-loader :completed="loadingComplete" :successState="loadingState" style="width: 20vh; height: 20vh;" />
                </v-row>
            </v-card-text>
            <!-- eslint-disable vue/no-use-v-if-with-v-for -->
            <v-card-text v-if="cardInputs" v-for="input in cardInputs" v-bind:key="input.id">
                <v-text-field
                    v-bind:type="input.type"
                    v-model="input.value"
                    v-bind:color="input.color"
                    v-bind:label="input.label"
                ></v-text-field>
            </v-card-text>
            <v-card-actions class="justify-center">
                <v-btn v-for="action in cardActions" v-bind:key="action.id" v-bind:color="action.color" v-bind:disabled="action.disabled" text @click="actionClick(action.id)">
                    {{ action.text }}
                </v-btn>
            </v-card-actions>
            <!-- eslint-enable vue/no-use-v-if-with-v-for -->
        </v-card>
    </v-dialog>
</template>

<script>

import Nui from '../../utils/Nui';
import SpinnyLoader from '../Loader';

export default {
    name: 'InteractionDialog',
    components: {
        SpinnyLoader
    },
    props: {

    },
    data() {
        return {
            showing: false,
            input: '',
            cardTitle: false,
            cardSubtitle: false,
            cardText: false,
            cardLoading: false,
            cardActions: false,
            cardInputs: false,

            loadingComplete: true,
            loadingState: true,
            // cardLoading: {
            //     color: 'red darken-4'
            // },
            // cardActions: [
            //     { id: 'test', color: 'red darken-4', text: 'Text', disabled: false },
            // ],
            // cardInput: {
            //     type: 'text',
            //     color: 'red darken-4',
            //     label: 'Text'
            // }
        };
    },
    computed: {
    },
    methods: {
        actionClick(action) {
            if (action) {
                Nui.send('interactionDialogClick', {
                    action,
                    inputs: this.cardInputs,
                })
            }
        }
    },
    mounted() {
        this.$root.$on('interactionDialog', (data) => {
            if (data) {
                this.cardTitle = data.title;
                this.cardSubtitle = data.subtitle;
                this.cardText = data.text;
                this.cardActions = data.actions;
                this.cardInputs = data.inputs;
                this.showing = true;

                this.cardLoading = data.loading;
                this.loadingState = data.loadingState;
                this.loadingComplete = data.loadingComplete;
            } else {
                if (this.showing) {
                    this.showing = false;
                    this.cardTitle = false;
                    this.cardSubtitle = false;
                    this.cardText = false;
                    this.cardLoading = false;
                    this.cardActions = false;
                    this.cardInputs = false;
                }
            }
        })

        /*this.$root.$emit('interactionDialog', {
            title: 'Title',
            subtitle: 'Subtitle',
            text: 'Text',
            loading: false,
            actions: [
                { id: 'test', color: 'red darken-4', text: 'Text', disabled: false },
            ],
            inputs: [
                { id: 'cunt', value: 'test', type: 'text', label: 'test' },
                { id: 'cunt2', value: 'test2', type: 'text2', label: 'test2' }
            ],
        })*/
    },
};

</script>

<style scoped lang="less">
@import '@/arp-theme.less';

</style>
