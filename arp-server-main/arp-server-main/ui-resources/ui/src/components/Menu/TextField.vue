<template>
    <div class="container">
        <v-textarea
            v-model="realInput"
            filled
            auto-grow
            rows="1"
            v-bind:persistent-hint="getHintPersistent"
            v-bind:hint="getHint"
            v-bind:counter="getCounter"
            v-bind:label="getLabel"
            v-bind:color="getColor"
            v-bind:loading="needSync"
            v-bind:readonly="getReadOnly"
            v-bind:prepend-icon="getIcon"
        >
            <template v-slot:append-outer v-if="!getReadOnly">
                <v-tooltip right>
                    <template v-slot:activator="{ on, attrs }">
                        <v-btn
                            class="mx-2"
                            :color="needSync && 'red darken-4' || 'cyan darken-4'"
                            style="transition: 0.5s;"
                            
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
            </template>
        </v-textarea>
    </div>
</template>

<script>
export default {
    name: 'TextField',
    props: {
        data: {
            required: true,
        },
        index: {
            required: true,
        }
    },
    data: () => ({
        realInput: '',
        needSync: false,
    }),
    mounted() {
        if (this.data.value) {
            this.realInput = this.data.value;
        }
    },
    methods: {
        valueSync() {
            if (this.needSync) {
                console.log('sync?')
                this.data.value = this.realInput;
                this.$emit('onChange', this.index);
                this.needSync = false;          
            }
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
        }

    },
    watch: {
        'realInput': function (newVal) {
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