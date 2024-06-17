<script>
    export let rounded = false;
    export let type = "normal";
</script>

<span class="badge {rounded ? 'badge--rounded' : ''} {type == 'sale' ? 'badge--sale' : ''}">
    {#if type == 'sale'}
    <svg class="badgeIcon" fill="currentColor" viewBox="0 0 20 20" xmlns="http://www.w3.org/2000/svg" aria-hidden="true">
        <path clip-rule="evenodd" fill-rule="evenodd" d="M4.93 1.31a41.401 41.401 0 0110.14 0C16.194 1.45 17 2.414 17 3.517V18.25a.75.75 0 01-1.075.676l-2.8-1.344-2.8 1.344a.75.75 0 01-.65 0l-2.8-1.344-2.8 1.344A.75.75 0 013 18.25V3.517c0-1.103.806-2.068 1.93-2.207zm8.85 5.97a.75.75 0 00-1.06-1.06l-6.5 6.5a.75.75 0 101.06 1.06l6.5-6.5zM9 8a1 1 0 11-2 0 1 1 0 012 0zm3 5a1 1 0 100-2 1 1 0 000 2z"></path>
    </svg>
    {/if}
    <slot />
</span>

<style lang="postcss">
    .badge {
        font-size: 0.75rem;
        font-weight: 600;
        display: inline-block;
        padding: 0.25rem 0.5rem;
        text-transform: uppercase;
        border-radius: 0.25rem;
        color: #FFFFFF;
        background-color: #2A2B30;
        border: 1px solid #2A2B30;
    }

    .badge--rounded {
        border-radius: 7px;
    }

    .badge--sale {
        color: #FFFFFF;
        background-color: rgba(151, 1, 1, 0.7);
        border: 1px solid #970101;
    }

    .badgeIcon {
        width: 0.75rem;
        height: 0.75rem;
        margin-right: 0.25rem;
    }
</style>