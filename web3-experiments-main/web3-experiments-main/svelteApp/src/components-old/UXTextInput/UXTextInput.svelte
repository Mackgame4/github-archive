<script>
    import { onMount } from "svelte";
    export let type = 'text';
    export let placeholder = 'name@flowbite.com';
    export let required = false;

    export let rounded = true;

    export let preIcon = 'search';
    export let postIcon = 'send';

    import UxIcon from "../UXIcon/UXIcon.svelte";

    // generate a unique id for the input
    const id = Math.random().toString(36).substr(2, 9);

    function focusInput() {
        const input = document.getElementById(`input-${id}`);
        input.focus();
    }
</script>

<!-- svelte-ignore a11y-click-events-have-key-events -->
<label class="container flex bg-gray-50 border border-gray-300 text-gray-900 text-sm block {rounded ? 'rounded-lg' : ''}">
    <div class="absolute transform translate-x-1/2">
        <slot name="left">
            {#if preIcon}
            <UxIcon icon="{preIcon}" />
            {/if}
        </slot>
    </div>
    <input id="input-{id}" type="{type}" placeholder="{placeholder}" required="{required}" class="{rounded ? 'rounded-lg' : ''} appearance-none w-full block focus:ring-2 focus:ring-blue-500 p-2.5">
    <div class="transform absoluteLeft">
        <slot name="right" class="slot">
            {#if postIcon}
            <UxIcon icon="{postIcon}" />
            {/if}
        </slot>
    </div>
</label>

<style>
    .container {
        align-items: center;
        box-shadow: 0 1px 2px 0 rgba(0, 0, 0, 0.05);
        cursor: text;
    }

    .absoluteLeft {
        position: relative;
        transform: translateX(-100%);
    }

    input {
        padding-left: 2.2rem;
        background: none;
    }

    input:focus {
        outline: none;
    }
</style>