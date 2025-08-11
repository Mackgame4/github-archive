<script setup lang="ts">
import { defineProps } from 'vue'

defineProps<{
  icon: string
  size?: number | string
  color?: string
}>()
</script>

<template>
  <svg
    class="icon"
    :width="size ?? '24'"
    :height="size ?? '24'"
    viewBox="0 0 24 24"
    xmlns="http://www.w3.org/2000/svg"
    :fill="color ?? 'currentColor'"
    aria-hidden="true"
  >
    <path :d="icon" />
  </svg>
</template>

<style scoped>
.icon {
  display: inline-block;
  vertical-align: middle;
  fill: var(--icon-color, currentColor);
}
</style>