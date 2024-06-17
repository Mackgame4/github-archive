<script lang="ts">
    import { onMount } from 'svelte'
    import { SearchIcon } from 'svelte-feather-icons'
    import PostSearchPreview from './PostSearchPreview.svelte'

    let searchInput: HTMLInputElement
    let searchableDocs: any[]
    let searchIndex: string

    let searchQuery = ''
    let searchResults = []

    onMount(async() => {
        const lunr = (await import('lunr')).default
        const resp = await fetch('/search-index.json')
        searchableDocs = await resp.json();
        // Initialize indexing
        searchIndex = lunr(function(){
            // the match key...
            this.ref('slug')
            // indexable properties
            this.field('title')
            this.field('description')
            this.field('tags')
            // Omit, if you don't want to search on `body`
            this.field('body')
            // Index every document
            searchableDocs.forEach((doc: any) => {
                this.add(doc)
            }, this)
        })
        searchInput.focus()
    })

    $: {
        if(searchQuery && searchQuery.length >= 3) {
            const matches = searchIndex.search(searchQuery)
            searchResults = []
            if (Array.isArray(matches)) {
                matches.map((match: { ref: any; }) => {
                    searchableDocs.filter((doc: { slug: any; }) => {
                            if(match.ref === doc.slug) {
                                searchResults.push(doc as never)
                            }
                    })
                })
            } else {
                searchResults = []
            }
        }
    }
</script>
<div class="search">
    <div class="search__ctrl">
        <label for="search"><SearchIcon /></label>
        <input type="text" name="search" bind:this={searchInput} placeholder="O que procura?" bind:value={searchQuery} />
    </div>
    <div class="search__results">
        {#if searchResults.length}
            {#each searchResults as post, i }
                <PostSearchPreview post={post} isLast={ i === searchResults.length - 1 } />
            {/each}
        {:else}
            <div class="search__results--none">
                {#if searchQuery.length}
                    No matching items found!
                {:else}
                    Search something and let me find it for you! :-)
                {/if}
            </div>
        {/if}
    </div>
    <div class="note"><small>Clique no fundo para fechar</small></div>
</div>
<style lang="postcss">
    .search {
        @apply w-full relative bg-gray-100 dark:bg-gray-800 p-8 rounded-md shadow-lg;
    }
    input {
        @apply w-full px-4 py-2 pl-10 text-lg text-black border-0 shadow-inner rounded-md bg-gray-100;
    }
    .search__ctrl {
        @apply pb-4 relative;
    }
    .search__ctrl label {
        @apply text-black absolute top-2 left-2;
    }
    .search__results {
        @apply w-96 h-64 py-4 overflow-y-auto;
    }
    .search__results--none {
        @apply text-center text-base;
    }
    .note {
        @apply w-full text-center text-base;
    }
</style>
