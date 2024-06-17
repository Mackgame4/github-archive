<template>
    <div class="container">
        <v-subheader v-if="getLabel">{{ getLabel }}</v-subheader>
        <v-slider
            v-model="data.value"
            v-bind:label="getSliderLabel"
            v-bind:color="getColor"
            v-bind:thumb-color="getThumbColor"
            v-bind:track-color="getTrackColor"
            v-bind:disabled="getReadOnly"
            v-bind:thumb-label="getThumbLabel"
            v-bind:min="getMin"
            v-bind:max="getMax"
            v-bind:ticks="getTicks"
            v-bind:tick-labels="getTickLabels"
            v-bind:hint="getHint"
            v-bind:persistent-hint="getHintPersistent"
            v-bind:prepend-icon="getIcon"
            v-bind:step="getStep"
        >
            <template v-if="getCustomThumbLabels" v-slot:thumb-label="{ value }">
                {{ data.customThumbLabels[value] || value }}
            </template>
            <template v-slot:append v-if="getShowField">
                <v-text-field
                    v-model="data.value"
                    class="mt-0 pt-0"
                    v-bind:color="getColor"
                    v-bind:step="getStep"
                    v-bind:min="getMin"
                    v-bind:max="getMax"
                    hide-details
                    single-line
                    type="number"
                    style="width: 60px"
                ></v-text-field>
            </template>
        </v-slider>
    </div>
</template>

<script>
export default {
    name: 'SliderField',
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
    mounted() {

    },
    methods: {

    },
    computed: {
        getColor() {
            return (this.data.color && typeof(this.data.color) === 'string') ? this.data.color : 'red darken-4';
        },
        getThumbColor() {
            return (this.data.thumbColor && typeof(this.data.thumbColor) === 'string') ? this.data.thumbColor : this.getColor;
        },
        getTrackColor() {
            return (this.data.trackColor && typeof(this.data.trackColor) === 'string') ? this.data.trackColor : '';
        },
        getLabel() {
            return (this.data.label && typeof(this.data.label) === 'string') ? this.data.label : '';
        },
        getSliderLabel() {
            return (this.data.sliderLabel && typeof(this.data.sliderLabel) === 'string') ? this.data.sliderLabel : '';
        },
        getThumbLabel() {
            return ((typeof(this.data.thumbLabel) === 'string' || typeof(this.data.thumbLabel) === 'boolean')) ? this.data.thumbLabel : true;
        },
        getCustomThumbLabels() {
            return (this.data.customThumbLabels && typeof(this.data.customThumbLabels) === 'object') ? this.data.customThumbLabels : false;
        },
        getReadOnly() {
            return !!this.data.readonly;
        },
        getMin() {
            return (typeof(this.data.min) === 'number') ? this.data.min : 0;
        },
        getMax() {
            return (typeof(this.data.max) === 'number') ? this.data.max : 100;
        },
        getShowField() {
            return !!this.data.showField;
        },
        getTicks() {
            return !!this.data.showTicks;
        },
        getTickLabels() {
            return (this.data.tickLabels && typeof(this.data.tickLabels) === 'object') ? this.data.tickLabels : [];
        },
        getCounter() {
            return !!this.data.counter;
        },
        getHint() {
            return (this.data.hint && typeof(this.data.hint) === 'string') ? this.data.hint : '';
        },
        getHintPersistent() {
            return !!this.data.persistentHint;
        },
        getIcon() {
            return (this.data.icon && typeof(this.data.icon) === 'string') ? this.data.icon : '';
        },
        getStep() {
            return (this.data.step && typeof(this.data.step) === 'number') ? this.data.step : 1; 
        }
    },
    watch: {
        'data.value': function(newVal) {
            if (newVal >= this.getMin && newVal <= this.getMax) {
                this.$emit('onChange', this.index);
            }
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