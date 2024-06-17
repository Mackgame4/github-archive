<template>
    <v-card-text class="container" v-html="data.value"></v-card-text>
</template>

<script>
export default {
    name: 'TextDisplay',
    props: {
        data: {
            required: true,
        },
        index: {
            required: true,
        }
    },
};
</script>

<style lang="less" scoped>
@import '@/arp-theme.less';
.container {
    background: @darker;
    border-radius: 0.8vh;
}
</style>