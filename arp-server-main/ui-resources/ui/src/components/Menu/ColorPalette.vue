<template>
    <div class="container">



        <div class="title" v-if="getLabel.length > 0">
            {{ getLabel }} - {{ data.value }}
        </div>
        <v-swatches class="colorPalette" v-model="data.value" v-bind:swatches="getColorSwatches" :swatch-style="{ width: '2vw', height: '2vw', margin: '0.5vw' }" v-bind:disabled="getReadOnly" background-color="transparent" inline></v-swatches>



    </div>
</template>

<script>
import VSwatches from 'vue-swatches'
import 'vue-swatches/dist/vue-swatches.css'
export default {
    name: 'ColorPalette',
    props: {
        data: {
            required: true,
        },
        index: {
            required: true,
        }
    },
    components: {
        VSwatches
    },
    data: () => ({
        color: '#3D556E'
    }),
    computed: {
        getColorSwatches() {
            return (this.data.swatches && (typeof(this.data.swatches) === 'object')) ? this.data.swatches : [ '#b40000' ];
        },
        getLabel() {
            return (this.data.label && typeof(this.data.label) === 'string') ? this.data.label : '';
        },
        getReadOnly() {
            return !!this.data.readonly;
        },
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
    .title {
        text-align: center;
        height: 5vh;
    }
    background: @darker;
    border-radius: 0.8vh;
    align-content: center;
    display: flex;
    flex-direction: column;
    .colorPalette {
        width: 18vw;
        margin: 0 auto;
    }
}


</style>