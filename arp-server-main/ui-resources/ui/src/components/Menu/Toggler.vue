<template>
    <div class="container">
        <div class="inner">
            <v-switch v-if="getType === 'switch'"
                v-model="data.value"
                v-bind:label="getLabel"
                v-bind:color="getColor"
                v-bind:readonly="getReadOnly"
            ></v-switch>
            <v-checkbox v-else
                v-model="data.value"
                v-bind:label="getLabel"
                v-bind:color="getColor"
                v-bind:readonly="getReadOnly"
            ></v-checkbox>
        </div>
    </div>
</template>

<script>
export default {
    name: 'Toggler',
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
        getLabel() {
            return (this.data.label && typeof(this.data.label) === 'string') ? this.data.label : '';
        },
        getReadOnly() {
            return !!this.data.readonly;
        },
        getType() {
            return (this.data.type && typeof(this.data.type) === 'string') ? this.data.type : 'switch';
        }
    },
    watch: {
        'data.value': function(/*newVal*/) {
            this.$emit('onChange', this.index);
        }
    }
};
</script>

<style lang="less" scoped>
@import '@/arp-theme.less';
.container {
    background: @darker;
    border-radius: 0.8vh;
    .inner {
        margin-left: 15%;
        margin-right: 15%;
        width: 70%;
    }
}
</style>