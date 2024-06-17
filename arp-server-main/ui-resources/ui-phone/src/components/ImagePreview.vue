<template>
   <div>
    <div class="imageContainer" :class="{ 'viewingImage': showingImage }" @mouseenter="startHover" @mouseleave="stopHover">
        <transition name="fade" mode="out-in">
            <div class="innerContainer" v-if="showingImage" key="showing" @click="clickImage(true)" :style="getInnerStyling">
                
            </div>
            <div class="innerContainer innerPreview" v-else key="hiding">
                <div @click="clickImage(false)">
                    <v-icon class="viewIcon" size="60">mdi-eye</v-icon>
                    <p>Reveal Image</p>
                    <p class="previewText grey--text text--lighten-2">Only view images from trusted sources.</p>
                </div>
                <p class="urlText"><a v-clipboard="src">Copy Image URL</a></p>
            </div>
        </transition>
    </div>
        <transition name="fade">
        <div class="popOverPreview" v-if="showingLarge">
            <img :src="src" />
        </div>
        </transition>
   </div>
</template>

<script>
//import Nui from '../../utils/Nui';

export default {
    name: 'ImagePreview',
    components: {

    },
    data: () => ({
        showingImage: false,
        showingLarge: false,

        preload: null,
    }),
    props: {
        src: {
            required: true,
            type: String,
        },
        autoReveal: {
            required: false,
            default: false,
            type: Boolean,
        }
    },
    computed: {
        getInnerStyling() {
            return {
                background: `url(${this.src}`,
            }
        }
    },
    methods: {
        startHover() {
            if (this.showingImage) {
                this.showingLarge = true;
            }
        },
        stopHover() {
            if (this.showingLarge) {
                this.showingLarge = false;
            }
        },
        clickImage(img) {
            console.log(1)
            if (!this.showingImage || (this.showingImage && img)) {
                console.log(2)
                this.showingImage = !this.showingImage;
                this.stopHover();
            }
        }
    },
    created() {
        this.preload = new Image(); // preload the image so it has loaded beforehand
        this.preload.src = this.src;
    },
    mounted() {
        if (this.autoReveal) {
            this.clickImage(false);
        }
    },
    beforeDestroy() {
        this.preload.src = '';
    }
};

</script>

<style scoped lang="less">
@import '@/arp-theme.less';

.popOverPreview {
    position: fixed;
    max-height: calc(var(--outer-height));
    max-width: calc(650px * var(--resize-percentage));
    right: calc(20px + var(--outer-width));
    transform: translateY(50%);
    bottom: calc(var(--outer-height) * 0.6);
    img {
        box-shadow: 2px 2px 5px 2px rgba(0, 0, 0, 0.392);
    }
}

img {
    width: 100%;
    height: 100%;
}

.viewingImage {
    padding: 0 !important;
}

.imageContainer {
    width: calc(250px * var(--resize-percentage));
    height: calc(200px * var(--resize-percentage));
    background: rgba(100, 100, 100, 1);
    border-radius: 20px;
    padding: 10px;
    transition: .5s;
    user-select: none;
    margin: 0;
    .innerContainer {
        height: 100%;
        width: 100%;
        border-radius: 20px;
        background-size: contain !important;
        background-repeat: no-repeat !important;
        background-position: center !important;
        div {
            height: 90%;
        }
        .urlText {
            font-size: .75rem;
            height: 10%;
            a {
                color: rgb(140, 176, 209);
            }
        }
        p {
            width: 100%;
            height: 20%;
            text-align: center;
            font-size: calc(1.1rem * var(--resize-percentage));
            margin: 0;
        }
    }
    .innerPreview {
        .viewIcon {
            width: 100%;
            height: 50%;
        }
        .previewText {
            font-size: calc(0.75rem * var(--resize-percentage));
        }
    }
    &:hover {
        background: rgb(70, 70, 70);
    }
}

</style>
