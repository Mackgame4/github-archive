<script>
    import { onMount } from "svelte";
    import feather from "feather-icons";
    onMount(() => {
        feather.replace();
    });

    export let icon;
    export let size = 'm';
    export let customIconSize = 18;

    let iconSize;

    if (customIconSize != 18) {
        size = 'custom';
    }

    if (size === 'sm') {
        iconSize = 14;
    } else if (size === 'm') {
        iconSize = 18;
    } else if (size === 'l') {
        iconSize = 20;
    } else if (size === 'xl') {
        iconSize = 24;
    } else {
        iconSize = customIconSize;
    }
</script>

<div style="--iconSize: {iconSize}px">
    <i data-feather={icon}></i>
</div>

<style>
    :global(.feather) {
        width: var(--iconSize) !important;
    }
</style>