
<template>
    <div>
        <transition name="bbars">
            <div class="bar" v-if="enabled"></div>
        </transition>
        <transition name="bbars2">
            <div class="bar bottom" v-if="enabled"></div>
        </transition>
    </div>
</template>



<script>

export default {
    components: { },
    props: {
        enabled: {
            required: true
        }
    },
    mounted() {
        
    },
    data: () => ({
        show: false,
    }),
    methods: {

    },
    computed: {

    }
};

</script>

<style scoped lang="less">


.bar {
    position: fixed;
    top: 0;
    right: 0;
    background: black;
    height: 12vh;
    width: 100vw;
    &.bottom {
        top: auto;
        bottom: 0;
    }
}


.bbars-enter-active {
    animation: bb-transition .5s;
}
.bbars-leave-active {
    animation: bb-transition .5s reverse;
}

@keyframes bb-transition {
    0% {
        transform: translateY(-100%);
    }
    100% {}
}

.bbars2-enter-active {
    animation: bb2-transition .5s;
}
.bbars2-leave-active {
    animation: bb2-transition .5s reverse;
}

@keyframes bb2-transition {
    0% {
        transform: translateY(100%);
    }
    100% {}
}

</style>
