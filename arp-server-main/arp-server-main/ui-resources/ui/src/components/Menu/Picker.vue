<template>
    <div class="container">
        <v-select
            v-bind:items="getItems"
            v-model="data.value"
            v-bind:label="getLabel"
            item-text="name"
            item-value="id"
            filled
            v-bind:color="getColor"
            v-bind:item-color="getColor"
            v-bind:hint="getHint"
            v-bind:persistent-hint="getHintPersistent"
            v-bind:readonly="getReadOnly"
            v-bind:loading="getLoading"
            v-bind:multiple="getMultiple"
            v-on:input="limiter"
        >
            <template v-slot:selection="{ item, index }" v-if="getMultiple">
                <v-chip v-if="index <= 2">
                    <span>{{ item.name }}</span>
                </v-chip>
                <span v-if="index === 3" class="grey--text caption">
                    (+{{ data.value.length - 3 }} others)
                </span>
            </template>
        </v-select>
    </div>
</template>

<script>
export default {
    name: 'Picker',
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
    computed: {
        getColor() {
            return (this.data.color && (typeof(this.data.color) === 'string')) ? this.data.color : 'red darken-4';
        },
        getItems() {
            return (this.data.items && typeof(this.data.items) === 'object') ? this.data.items : [ { id: 'broken', name: 'Broken' } ];
        },
        getLabel() {
            return (this.data.label && typeof(this.data.label) === 'string') ? this.data.label : '';
        },
        getHint() {
            return (this.data.hint && typeof(this.data.hint) === 'string') ? this.data.hint : '';
        },
        getHintPersistent() {
            return !!this.data.persistentHint;
        },
        getReadOnly() {
            return !!this.data.readonly;
        },
        getLoading() {
            return !!this.data.loading;
        },
        getMultiple() {
            return (this.data.multiple && typeof(this.data.value) === 'object') ? true : false
        },
    },
    methods: {
        limiter(/*e*/) {
            if (this.data.multipleLimiter && typeof(this.data.multipleLimiter) === 'number') {
                if (this.data.value.length > this.data.multipleLimiter) {
                    this.data.value.pop();
                }
            }
        }
    },
    watch: {
        'data.value': function(/*newVal*/) {
            this.$emit('onChange', this.index)
        }
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