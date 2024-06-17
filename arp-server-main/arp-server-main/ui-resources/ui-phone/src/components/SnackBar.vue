<template>
    <transition name="snackFade">
        <div class="snackBar" v-if="showing">
            <div class="inner"><p v-html="content"></p></div>
        </div>
    </transition>
</template>

<script>

import Nui from '../utils/Nui';

export default {
    name: 'SnackBar',
    components: {},
    data: () => ({
        showing: false,
        content: '😎',
        timeout: null,
    }),
    props: {},
    methods: {
        closeSnack() {
            this.showing = false;
        },
        changeSnack(newContent) {
            clearTimeout(this.timeout);
            this.showing = true;
            this.content = newContent;

            this.timeout = setTimeout(() => {
                this.closeSnack();
            }, 3500);
        },
        async showSnack(content) {
            if (this.showing) {
                this.closeSnack();
                await Nui.doDelay(300);
                this.changeSnack(content);
            } else {
                this.changeSnack(content);
            }
        }
    },
    mounted() {
        this.$root.$on('doSBar', (content) => {
            this.showSnack(content);
        });
    }
};

</script>

<style lang="less">
@import '@/arp-theme.less';

.snackBar {
    position: fixed;
    display: flex;
    flex-direction: row;
    justify-content: center;
    opacity: 80%;
    z-index: 9999;

    width: calc(var(--outer-width) * 0.75);
    right: calc(11.5px + (var(--outer-width) * 0.25 / 2));
    bottom: 175px;
    .inner {
        max-width: 100%;
        padding: 10px 20px;
        text-align: center;
        background: #000000ab;
        border-radius: 20px;
        overflow: hidden;
        p {
            display: -webkit-box;
            -webkit-line-clamp: 2;
            -webkit-box-orient: vertical;
            user-select: none;
            color: white;
            margin: 0;
        }
    }
}

.snackFade-enter-active, .snackFade-leave-active {
    transition: opacity .3s;
}

.snackFade-enter, .snackFade-leave-to {
    opacity: 0;
}

</style>
