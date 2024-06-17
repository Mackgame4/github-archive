<template>
    <div class="container">
    <v-row v-if="getLabel">
        <v-col class="d-flex justify-center title" v-html="getLabel"></v-col>
    </v-row>
    <v-row>
        <v-col class="d-flex justify-center">

            <v-color-picker 
                v-bind:disabled="getReadOnly"
                v-model="color"
            
            >
            </v-color-picker>
        </v-col>
    </v-row>
    <v-row class="d-flex justify-center align-center">
        <v-tooltip right>
            <template v-slot:activator="{ on, attrs }">
                <v-btn
                    class="mx-2"
                    style="transition: 0.5s;"
                    :color="needSync && 'red darken-4' || 'cyan darken-4'"
                    @click="valueSync"
                    v-bind="attrs"
                    v-on="on"
                >
                    <v-icon v-if="needSync">mdi-loading mdi-spin</v-icon>
                    <v-icon v-else>mdi-check-circle</v-icon>
                </v-btn>
            </template>
            <span v-if="needSync">Click to Apply/Save</span>
            <span v-else>Current</span>
        </v-tooltip>

    </v-row>

    </div>
</template>

<script>
export default {
    name: 'Color',
    props: {
        data: {
            required: true,
        },
        index: {
            required: true,
        }
    },
    data: () => ({
        color: '#B40000',
        needSync: false,
    }),
    methods: {
        valueSync() {
            if (this.needSync) {
                console.log('sync?')
                this.data.value = this.color;
                this.$emit('onChange', this.index);
                this.needSync = false;           
            }
        }
    },
    mounted() {
        if (this.data.value) {
            this.color = this.data.value;
        }
    },
    computed: {
        getColorSwatches() {
            return (this.data.swatches && (typeof(this.data.swatches) === 'object')) ? this.data.swatches : [ '#b40000' ];
        },
        getLabel() {
            return (this.data.label && typeof(this.data.label) === 'string') ? this.data.label : false;
        },
        getReadOnly() {
            return !!this.data.readonly;
        },
    },
    watch: {
        'color': function (newVal) {
            if (newVal !== this.data.value) {
                this.needSync = true;
            } else {
                this.needSync = false;
            }
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