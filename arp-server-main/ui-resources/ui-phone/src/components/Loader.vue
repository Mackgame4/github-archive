<template>
    <div class="loaderContainer">
        <div class="circle-loader" :class="{ 'succeeded': completed && successState, 'failed': completed && !successState }">
            <div class="status draw"></div>
        </div>
    </div>
</template>

<script>

export default {
    name: 'SpinnyLoader',
    components: {},
    data: () => ({
        complete: false,
        status: false,
        timeout: null,
    }),
    props: {
        completed: {
            required: false,
            default: false,
            type: Boolean,
        },
        successState: {
            required: false,
            default: true, // default goes to success when completed
            type: Boolean,
        },
        completeWithTimeout: {
            required: false,
            default: 0, // in ms
            type: Number,
        }
    },
    methods: {

    },
    computed: {

    },
    mounted() {
        if (this.completeWithTimeout > 0) {
            this.timeout = setTimeout(() => {
                this.completed = true;
            }, this.completeWithTimeout);
        }
    },
    beforeDestroy() {
        clearTimeout(this.timeout);
    }
};

</script>

<style scoped lang="less">
@import '@/arp-theme.less';

.loaderContainer {
    .circle-loader {
        border: 2.5px solid rgba(0, 0, 0, 0.2);
        border-left-color: #209bed;
        animation-name: loader-spin;
        animation-duration: 1s;
        animation-iteration-count: infinite;
        animation-timing-function: linear;
        position: relative;
        display: inline-block;
        vertical-align: top;
        transition: 1s;
    }
    .circle-loader, .circle-loader:after {
        border-radius: 50%;
        width: 100%;
        height: 100%;
    }

    .succeeded {
        -webkit-animation: none;
        animation: none;
        border-color: #5cb85c;
        transition: border opacity 500ms ease-out;
    }
    .succeeded .status.draw:after {
        animation-duration: 1.2s;
        animation-timing-function: ease;
        animation-name: checkmark;
        transform: scaleX(-1) rotate(135deg);
    }
    .succeeded .status:after {
        opacity: 1;
        height: 50%;
        width: 25%;
        transform-origin: left top;
        border-right: 2.5px solid #5cb85c;
        border-top: 2.5px solid #5cb85c;
        content: "";
        left: 23%;
        top: 50%;
        position: absolute;
    }

    .failed {
        -webkit-animation: none;
        animation: none;
        border-color: #FF0000;
        transition: border opacity 500ms ease-out;
    }
    .failed .status.draw:after {
        animation-duration: 1.2s;
        animation-timing-function: ease;
        animation-name: failedmark;
    }
    .failed .status:after {
        opacity: 1;
        height: 50%;
        width: 50%;
        border-top: 2.5px solid #FF0000;
        content: "";
        left: 25%;
        top: 50%;
        position: absolute;
    }

    @keyframes loader-spin {
        0% {
            transform: rotate(0deg);
        }
        100% {
            transform: rotate(360deg);
        }
    }
    @keyframes checkmark {
        0% {
            height: 0;
            width: 0;
            opacity: 1;
        }
        20% {
            height: 0;
            width: 25%;
            opacity: 1;
        }
        40% {
            height: 50%;
            width: 25%;
            opacity: 1;
        }
        100% {
            height: 50%;
            width: 25%;
            opacity: 1;
        }
    }
    @keyframes failedmark {
        0% {
            left: 50%;
            width: 0;
            opacity: 1;
        }
        100% {
            left: 25%;
            width: 50%;
            opacity: 1;
        }
    }
}

</style>
