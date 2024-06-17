<template>
    <div class="container">
        <v-text-field
            v-model="data.value"
            filled
            auto-grow
            rows="1"
            type="number" 
            v-bind:step="getStep"
            v-bind:min="getMin"
            v-bind:max="getMax"
            v-bind:persistent-hint="getHintPersistent"
            v-bind:hint="getHint"
            v-bind:label="getLabel"
            v-bind:color="getColor"
            v-bind:readonly="getReadOnly"
            v-bind:prefix="getPrefix"
        >
        </v-text-field>
    </div>
</template>

<script>
export default {
    name: 'NumberField',
    props: {
        data: {
            required: true,
        },
        index: {
            required: true,
        }
    },
    mounted() {
        if (this.data.value > this.data.max) {
            this.data.value = this.data.max     
        } else if (this.data.value < this.data.min) {
            this.data.value = this.data.min
        }
    },
    computed: {
        getColor() {
            return (this.data.color && typeof(this.data.color) === 'string') ? this.data.color : 'red darken-4';
        },
        getLabel() {
            return (this.data.label && typeof(this.data.label) === 'string') ? this.data.label : '';
        },
        getReadOnly() {
            return !!this.data.readonly;
        },
        getHint() {
            return (this.data.hint && typeof(this.data.hint) === 'string') ? this.data.hint : '';
        },
        getHintPersistent() {
            return !!this.data.persistentHint;
        },
        getPrefix() {
            return (this.data.prefix && typeof(this.data.prefix) === 'string') ? this.data.prefix : '';
        },
        getMin() {
            return (typeof(this.data.min) === 'number') ? this.data.min : 0;
        },  
        getMax() {
            return (typeof(this.data.max) === 'number') ? this.data.max : 100;
        },
        getStep() {
            return (this.data.step && typeof(this.data.step) === 'string') ? this.data.step : 1
        }
    },
    watch: {
        'data.value': function (/*newVal*/) {
            this.$emit('onChange', this.index);
        },
    }
};
</script>

<style lang="less" scoped>
@import '@/arp-theme.less';
.container {
    background: @darker;
    border-radius: 0.8vh;
}
</style>