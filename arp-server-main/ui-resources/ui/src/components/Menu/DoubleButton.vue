<template>
    <v-row>
        <v-col>
            <SimpleButton v-bind:data="getButtonOne" v-bind:index="0" @onChange="buttonClick" />
        </v-col>
        <v-col>
            <SimpleButton v-bind:data="getButtonTwo" v-bind:index="1" @onChange="buttonClick" />
        </v-col>
    </v-row>
</template>

<script>
import SimpleButton from './SimpleButton';
export default {
    name: 'DoubleButton',
    components: {
        SimpleButton
    },
    props: {
        data: {
            required: true,
        },
        index: {
            required: true,
        }
    },
    data: () => ({
        
    }),
    methods: {
        buttonClick(buttonIndex) {
            this.$emit('onChange', this.index, buttonIndex);
        }
    },
    computed: {
        getButtonOne() {
            return this.data.buttons[0];
        },
        getButtonTwo() {
            return this.data.buttons[1];
        }
    }
};
</script>