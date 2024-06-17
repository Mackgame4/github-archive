<template>
    <div>
        <v-btn
            elevation="5"
            x-large
            block
            dark

            v-bind:loading="data.loading"
            v-bind:disabled="getDisabled"
            v-bind:color="getColor"
            @click="handleClick"
        >
            <v-icon v-bind:left="hasText" v-if="data.icon">
                {{ data.icon }}
            </v-icon>
            {{ data.text }}
        </v-btn>
    </div>
</template>

<script>
export default {
    name: 'SimpleButton',
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
        handleClick() {
            this.$emit('onChange', this.index);
        }
    },
    computed: {
        hasText() {
            return !!this.data.text;
        },
        getColor() {
            return (this.data.color && (typeof(this.data.color) === 'string')) ? this.data.color : '';
        },
        getDisabled() {
            return !!this.data.disabled;
        }
    }
};
</script>