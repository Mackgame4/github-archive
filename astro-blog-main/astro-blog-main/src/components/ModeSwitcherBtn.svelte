<script lang="ts">
    import ModeSwitcher from './ModeSwitcher.svelte'
    import { SunIcon, MoonIcon } from 'svelte-feather-icons';
</script>
<ModeSwitcher let:theme>
    {#if theme === 'dark'}
        <MoonIcon />
    {:else}
        <SunIcon />
    {/if}
</ModeSwitcher>