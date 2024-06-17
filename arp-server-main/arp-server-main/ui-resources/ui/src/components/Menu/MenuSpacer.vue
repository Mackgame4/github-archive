<template>
    <v-divider></v-divider>
</template>

<script>
export default {
    name: 'MenuSpacer',
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