<template>
    <v-dialog v-model="showing" persistent origin="bottom" scrollable hide-overlay content-class="phoneDialog">
        <v-card v-if="loading">
            <div class="loadContainer">
                <SpinnyLoader :completed="loadingActive" :successState="loadingState" class="actualFuckingLoader" />
            </div>
        </v-card>
        <v-card v-else>
            <v-card-title>{{ actionType }} Contact</v-card-title>
            <div class="inputs">
                <v-text-field append-icon="mdi-account" :error="hasError" :error-messages="getErrorMessage" v-model="name" color="red darken-4" label="Name"></v-text-field>
                <v-text-field :disabled="getIsNumberFieldDisabled" append-icon="mdi-pound" :error="hasError" :error-messages="getErrorMessage" v-model="number" color="red darken-4" label="Number" placeholder="###-###-####" v-mask="'###-###-####'"></v-text-field>
            </div>
            <v-card-actions>
                <v-btn color="red darken-4" text @click="closeDeny">Cancel</v-btn>
                <v-spacer></v-spacer>
                <v-btn color="red darken-4" v-if="!data.type" text @click="deleteContact">Delete</v-btn>
                <v-btn color="green darken-1" text @click="closeConfirm">{{ actionType }}</v-btn>
            </v-card-actions>
        </v-card>
    </v-dialog>
</template>

<script>

const isNameValid = (name) => {
    return name.length > 0;
}

import SpinnyLoader from '../../components/Loader';
import Nui from '../../utils/Nui';
import { isNumberValid } from '../../utils/utils';

export default {
    name: 'DialogsContactEdit',
    components: {
        SpinnyLoader,
    },
    data: () => ({
        loading: false,
        loadingActive: false,
        loadingState: true,
        originalName: false,
        originalNumber: false,
        name: '',
        number: '',
        error: false,
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
        if (this.data.name) {
            this.name = this.data.name;
            if (!this.data.type) {
                this.originalName = this.data.name;
            }
        }
        if (this.data.number) {
            this.number = this.data.number;
            if (!this.data.type) {
                this.originalNumber = this.data.number;
            }
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

            if (!isNumberValid(this.number)) {
                this.error = 'Invalid phone number';
                return;
            } else if (!isNameValid(this.name)) {
                this.error = 'A name is required';
                return;
            } else if (this.$store.getters.getContactByName(this.name) && this.name !== this.originalName) {
                this.error = 'That name is already saved';
                return;
            } else if (this.$store.getters.getContactByNumber(this.number) && this.number !== this.originalNumber) {
                this.error = 'That number is already saved';
                return;
            }

            this.startLoading();

            await Nui.doDelay(500);

            const success = await this.$store.dispatch('contactEditAdd', { type: this.data.type, name: this.name, number: this.number, original: this.originalNumber });

            this.finishLoading(success);
            await Nui.doDelay(650);
            this.$emit('confirm');
        },
        async deleteContact() {
            if (!this.data.type) {
                this.startLoading();
                await Nui.doDelay(500);
                const success = await this.$store.dispatch('contactDelete', this.originalNumber);
                this.finishLoading(success);
                await Nui.doDelay(650);
                this.$emit('confirm');
            }
        },
        closeDeny() {
            this.$emit('deny');
        }
    },
    computed: {
        actionType() {
            if (this.data.type) {
                return 'Add';
            } else {
                return 'Edit';
            }
        },
        getIsNumberFieldDisabled() {
            if (this.data.type && this.data.number) {
                return true;
            } else return false;
        },
        getErrorMessage() {
            if (this.error && typeof(this.error) === 'string' && this.error.length > 0) {
                return this.error;
            } else return '';
        },
        hasError() {
            if (this.error && typeof(this.error) === 'string' && this.error.length > 0) {
                return true;
            } else return false;
        }
    },
    beforeDestroy() {
        clearTimeout(this.timeout);
    },
    watch: {
        error(val) {
            if (val && typeof(val) === 'string' && val.length > 0) {
                clearTimeout(this.timeout);
                this.timeout = setTimeout(() => {
                    this.error = false;
                }, 2500);
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
