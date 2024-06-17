<script lang="ts">
    export let team: any[];
</script>

<div class="team_container">
    {#each team as member}
        <a class="team_card" href={member.url} target="_blank" rel="noopener noreferrer">
            <img src={member.img ? member.img : '/images/logotipo.jpg'} alt={member.name} />
            <div style="margin-left: 1rem;">
                <h3>{member.name}</h3>
                <p>{member.role}</p>
            </div>
        </a>
    {/each}
</div>

<style lang="postcss">
    .team_container {
        display: grid;
        grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
        grid-gap: 1rem;
        width: 100%;
        height: 100%;
    }

    .team_card {
        padding: 1rem;
        align-items: left;
        justify-content: left;
        @apply flex flex-row bg-white dark:bg-gray-700 rounded-lg shadow-md overflow-hidden no-underline hover:shadow-lg hover:bg-gray-100 dark:hover:bg-gray-600 transition-all duration-200 ease-in-out;
    }
    
    .team_card img {
        @apply w-20 h-20 rounded-full;
    }

    .team_card h3 {
        @apply text-lg font-semibold;
    }

    .team_card p {
        @apply text-theme-primary dark:text-theme-dark-primary text-sm;
    }
</style>