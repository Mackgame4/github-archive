<script>
    export let size = "md";
    export let type = "info";
    export let rounded = false;
    export let disabled = false;
</script>

<span class="ux-badge ux-badge--{size} ux-badge--{type} {rounded ? 'ux-badge--rounded' : ''} {disabled ? 'ux-badge--disabled' : ''}">
    <slot />
</span>

<style lang="postcss">
    .ux-badge {
        @apply text-xs font-semibold inline-block py-1 px-2 uppercase rounded text-orange-600 bg-orange-200 uppercase last:mr-0 mr-1;
    }

    .ux-badge--sm {
        @apply text-xs;
    }

    .ux-badge--md {
        @apply text-sm;
    }

    .ux-badge--lg {
        @apply text-base;
    }

    .ux-badge--xl {
        @apply text-lg;
    }

    .ux-badge--info {
        @apply text-blue-600 bg-blue-200;
    }

    .ux-badge--success {
        @apply text-green-600 bg-green-200;
    }

    .ux-badge--danger {
        @apply text-red-600 bg-red-200;
    }

    .ux-badge--warning {
        @apply text-yellow-600 bg-yellow-200;
    }

    .ux-badge--rounded {
        @apply rounded-full;
    }

    .ux-badge--disabled {
        @apply opacity-50;
    }
</style>