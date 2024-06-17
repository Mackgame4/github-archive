<script>
    export let size = "md";
    export let type = "info";
    export let disabled = false;
</script>

<button class="ux-button ux-button--{type} ux-button--{size}" disabled={disabled}>
    <slot />
</button>

<style lang="postcss">
    .ux-button {
        @apply bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded;
    }

    .ux-button--sm {
        @apply py-1 px-2 text-sm;
    }

    .ux-button--md {
        @apply py-2 px-4 text-base;
    }

    .ux-button--lg {
        @apply py-3 px-6 text-lg;
    }

        .ux-button--info {
            @apply bg-blue-500 hover:bg-blue-700;
        }

        .ux-button--success {
            @apply bg-green-500 hover:bg-green-700;
        }

        .ux-button--danger {
            @apply bg-red-500 hover:bg-red-700;
        }

        .ux-button:disabled {
            @apply bg-gray-500 cursor-not-allowed;
        }
</style>