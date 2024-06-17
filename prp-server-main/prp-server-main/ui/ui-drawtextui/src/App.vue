<template>
    <div id="app">
        <v-app>
            <v-scroll-x-reverse-transition>
                <v-alert v-if="showText" id="text" :type="type">{{ text }}</v-alert>
            </v-scroll-x-reverse-transition>
        </v-app>
    </div>
</template>

<script>
export default {
    name: 'ui-drawtextui',
    components: {
    },
    data: () => ({
        text: "Press E to open garage.",
        type: "info",
        showText: false
    }),
    mounted() {
        this.listener = window.addEventListener('message', e => {
            const item = e.data || e.detail;
            const { event, data } = item;

            if (event) {
                this.$root.$emit(event, data)
                this.$root.$emit('addNuiEventLog', false, event, data);
            }

            if(item.action == "show"){
                this.text = item.text;
                this.type = "info";
                this.showText = true;
            } else if(item.action == "hide"){
                this.showText = false;
            } else if(item.action == "notify"){
                this.text = item.text;
                this.type = item.type;
                this.showText = true;
                setTimeout(() => (this.showText = false), item.timeout);
            }
        }, false);
    },
    methods: {
    }
}
</script>

<style lang="less">
@import '@/theme.less';

body, html, #app {
    width: 100vw;
    height: 100vh;
    overflow: hidden;
    padding: 0;
    margin: 0;
    background: none;
    -webkit-font-smoothing: antialiased;
    -moz-osx-font-smoothing: grayscale;
}

#text {
    position: absolute;
    top: 50%;
    right: 7px;
    white-space: nowrap;
}
</style>