<script lang="ts">
    import { fade, fly } from 'svelte/transition'
    import { isSearchVisible } from '../store/search'
    import Search from './Search.svelte'

    const dismissModal = () => isSearchVisible.set(false)
    const handleEsc = (event) => {
        if (event.key === 'Escape') {
			dismissModal()
		}
    }

    const enableScroll = () => {
        window.onscroll = function () { };
    }
</script>
{#if $isSearchVisible}
    <div class="modal_backdrop" role="button" tabindex="0" on:click={dismissModal} on:blur={enableScroll} on:keydown={handleEsc} transition:fade></div>
    <div class="modal" role="dialog">
        <div class="modal_container" transition:fly="{{ y: 200, duration: 300 }}">
            <Search />
        </div>
    </div>
{/if}
<style lang="postcss">
    .modal {
        @apply absolute top-0 left-0 w-full h-full grid justify-center content-center pointer-events-none;
    }
    .modal_backdrop {
        @apply absolute top-0 left-0 w-full h-screen opacity-50 bg-black z-0;
    }
    .modal_container {
        @apply w-full z-10 pointer-events-auto;
    }
</style>
