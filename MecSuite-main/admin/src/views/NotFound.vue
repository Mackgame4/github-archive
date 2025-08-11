<script lang="ts" setup>
import { useRouter } from 'vue-router';

const router = useRouter();

import { mdiAlertCircle, mdiArrowLeft } from '@mdi/js'

import Icon from '@/components/Icon.vue'
</script>

<template>
    <IContainer class="_display:flex! _flex-direction:column! _align-items:center! _justify-content:center! _height:100%!">
        <Icon :icon="mdiAlertCircle" size="64" class="_text:primary!" />
        <h1>404 - Page Not Found</h1>
        <p>Oops! The page you're looking for doesn't exist.</p>
        <IButton color="primary" size="lg" @click="router.back()">
            <Icon :icon="mdiArrowLeft" size="24" class="_text:primary!" /> Back
        </IButton>
    </IContainer>
</template>