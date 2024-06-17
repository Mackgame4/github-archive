<template>
    <transition name="fade">
        <div class="busy" v-if="show"></div>
    </transition>
</template>

<script>
export default {
    name: 'Busy',
    props: ['busy'],
    data () {
        return {
            show: false,
            lock: false,
            timeout: null
        }
    },
    watch: {
        busy() {
            if (this.busy) {
                this.lock = true;
                this.show = true;
            } else {
                if (this.timeout) {
                    clearTimeout(this.timeout);
                    this.timeout = null;
                }

                this.lock = false;

                this.timeout = setTimeout(() => {
                    this.show = false;
                }, 500);
            }
        }
    }
};
</script>

<style scoped>
    
</style>