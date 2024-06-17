<script lang="ts">
    import { SearchIcon } from 'svelte-feather-icons'
    import { isSearchVisible } from '../store/search'

    function showSearchDialog() {
        isSearchVisible.set(true)
    }

    const disableScroll = () => {
        window.onscroll = function () { window.scrollTo(0, 0); };
    }
</script>
<button on:click={showSearchDialog} on:blur={disableScroll}>
    <SearchIcon />
</button>