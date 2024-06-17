<script>
    import { onMount } from 'svelte';

    import Splide from '@splidejs/splide';
    import '@splidejs/svelte-splide/css';
    import { Grid } from '@splidejs/splide-extension-grid';

    export let splideSettings = {
        type: 'loop',
        height     : '32rem',
        perPage    : 2,
        perMove    : 2,
        autoplay: true,
        interval: 5000,
        //padding: '4rem',
        //focus: 'center',
        //heightRatio: 0.5,
        pagination: false,
        arrows: false,
        //fixedWidth: '100%',
        //fixedHeight: '100%',
        //cover: true,
        gap: '7px',
        grid       : {
            // You can define rows/cols instead of dimensions.
            dimensions: [ [ 1, 1 ], [ 2, 2 ] ],
            gap: {
                row: '7px',
                col: '7px',
            }
        }
    };

    export let carouselItems = [
        {
            title: 'Red Dead Redemption 2',
            image: 'https://www.rocketchainsaw.com.au/wp-content/uploads/2018/05/Red-Dead-Redemption-2-New-Logo.jpg'
        },
        {
            title: 'The Last of Us Part II',
            image: 'https://s3.gaming-cdn.com/images/products/6215/orig/the-last-of-us-part-ii-pc-game-cover.jpg?v=1666694210'
        },
        {
            title: 'Marvel\'s Guardians of the Galaxy',
            image: 'https://s2.gaming-cdn.com/images/products/9016/orig/marvel-s-guardians-of-the-galaxy-pc-jogo-steam-cover.jpg?v=1659947591'
        }
    ];

    onMount(() => {
        var splide = new Splide('.splide', splideSettings);
        // Updates the bar width whenever the carousel moves:
        splide.on('mounted move', function () {
            var end  = splide.Components.Controller.getEnd() + 1;
            var rate = Math.min( ( splide.index + 1 ) / end, 1 );
            document.getElementById('slider-progress-bar').style.width = String( 100 * rate ) + '%';
        });
        splide.mount({Grid});

        // if the main div is resized, the carousel will be resized as well
        var mainDiv = document.getElementById('mainDiv');
        var resizeObserver = new ResizeObserver(entries => {
            //for (let entry of entries) {
                splide.refresh();
            //}
        });
        resizeObserver.observe(mainDiv);
    });

    import Badge from "./Badge.svelte";
</script>

<div id="mainDiv">
    <div class="splide">
        <div class="splide__track">
        <ul class="splide__list">
            {#each carouselItems as item}
            <li class="splide__slide">
                <img src={item.image} alt={item.title} />
                <div class="itemTitle">
                    <Badge rounded>{item.title}</Badge>
                    {#if item.sale}
                    <Badge type="sale" rounded>Sale</Badge>
                    {/if}
                </div>
            </li>
            {/each}
        </ul>
        </div>
        <!--div class="slider-progress">
            <div id="slider-progress-bar" class="slider-progress-bar"></div>
        </div-->
    </div>
</div>

<style>
    .splide {
        position: relative;
    }

    .splide__track {
        height: 100%;
        border-radius: 7px;
    }

    .splide__slide {
        display: flex;
        flex-direction: column;
        align-items: center;
        justify-content: center;
        height: 100%;
        width: 100%;
        border-radius: 7px;
        background-color: #1A1B1F;
        border: 1px solid #1A1B1F;
        box-shadow: 0 0 10px #222327;
    }

    .splide__slide img {
        width: 100%;
        height: 100%;
        object-fit: cover;
        border-radius: 7px;
    }

    .itemTitle {
        position: absolute;
        bottom: 7px;
        left: 50%;
        transform: translateX(-50%);
    }
</style>