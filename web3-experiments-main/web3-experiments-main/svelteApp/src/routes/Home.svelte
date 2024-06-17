<script>
    import Carousel from "./Carousel.svelte";

    let carouselItems = [
        {
            title: 'Marvel\'s Spider Man',
            image: 'https://image.api.playstation.com/vulcan/ap/rnd/202008/1420/HcLcfeQBXd2RiQaCeWQDCIFN.jpg',
            sale: true
        },
        {
            title: 'The Last of Us Part II',
            image: 'https://w0.peakpx.com/wallpaper/151/819/HD-wallpaper-the-last-of-us-ellie-game-games-gaming-ps4-the-last-of-us-2-the-last-of-us-part-2-tlou-tlou2.jpg',
            sale: false
        },
        {
            title: 'Days Gone',
            image: 'https://i0.wp.com/www.portaldonerd.com.br/wp-content/uploads/2021/05/15134739112089.jpg',
            sale: true
        },
        {
            title: 'Ghost of Tsushima',
            image: 'https://meups.com.br/wp-content/uploads/2020/07/Ghost-of-Tsushima-15-900x503.jpg',
            sale: false
        },
        {
            title: 'Mortal Kombat 11',
            image: 'https://i.pinimg.com/originals/2a/3c/e5/2a3ce50b8800ae66f599edffa2634ffa.jpg',
            sale: false
        }
    ];
</script>

<div>
    <div class="heroContainer">
        <div class="carousel">
            <Carousel carouselItems={carouselItems} />
        </div>
        <div>
            <!--div class="appSliderSection">
                <div class="sectionDivider">
                    <svg fill="currentColor" viewBox="0 0 20 20" xmlns="http://www.w3.org/2000/svg" aria-hidden="true">
                        <path clip-rule="evenodd" fill-rule="evenodd" d="M5.23 15.79a.75.75 0 01-.02-1.06l4.25-4.5a.75.75 0 011.08 0l4.25 4.5a.75.75 0 11-1.08 1.04L10 11.832 6.29 15.77a.75.75 0 01-1.06.02zm0-6a.75.75 0 01-.02-1.06l4.25-4.5a.75.75 0 011.08 0l4.25 4.5a.75.75 0 11-1.08 1.04L10 5.832 6.29 9.77a.75.75 0 01-1.06.02z"></path>
                    </svg>
                    <h2>Most Downloaded</h2>
                </div>
                <div class="appSlider">
                </div>
            </div-->
            <div class="appSliderSection">
                <div class="sectionDivider">
                    <svg fill="currentColor" viewBox="0 0 20 20" xmlns="http://www.w3.org/2000/svg" aria-hidden="true">
                        <path clip-rule="evenodd" fill-rule="evenodd" d="M4.25 2A2.25 2.25 0 002 4.25v2.5A2.25 2.25 0 004.25 9h2.5A2.25 2.25 0 009 6.75v-2.5A2.25 2.25 0 006.75 2h-2.5zm0 9A2.25 2.25 0 002 13.25v2.5A2.25 2.25 0 004.25 18h2.5A2.25 2.25 0 009 15.75v-2.5A2.25 2.25 0 006.75 11h-2.5zm9-9A2.25 2.25 0 0011 4.25v2.5A2.25 2.25 0 0013.25 9h2.5A2.25 2.25 0 0018 6.75v-2.5A2.25 2.25 0 0015.75 2h-2.5zm0 9A2.25 2.25 0 0011 13.25v2.5A2.25 2.25 0 0013.25 18h2.5A2.25 2.25 0 0018 15.75v-2.5A2.25 2.25 0 0015.75 11h-2.5z"></path>
                    </svg>
                    <h2>All</h2>
                </div>
                <div class="appList">
                    {#each carouselItems as item}
                        <div class="appCard">
                            <img src={item.image} alt={item.title} />
                            <h4>{item.title}</h4>
                        </div>
                    {/each}
                </div>
            </div>
        </div>
    </div>
</div>

<style>
    .heroContainer {
        display: flex;
        flex-direction: column;
        width: 100%;
        height: 100%;
    }

    .carousel {
        width: 100%;
    }

    .sectionDivider {
        display: flex;
        align-items: center;
        margin-top: 20px;
        /*margin-left: 25px;*/
    }

    .sectionDivider svg {
        width: 1.3rem;
        height: 1.3rem;
        margin-top: -22px;
        margin-right: 7px;
        fill: #fff;
    }
    
    .sectionDivider h2 {
        margin: 0;
        font-family: URWGeometricMedium;
        padding: 0;
        font-size: 1.3rem;
        font-weight: 400;
        color: #fff;
        margin-bottom: 1rem;
    }

    .appList {
        display: flex;
        flex-wrap: wrap;
        margin-top: -15px;
    }

    .appCard {
        display: flex;
        width: 300px;
        background-color: none;
        color: #A5A6AB;
        border-radius: 7px;
        padding: 10px 10px;
        margin: 10px;
        transition: 0.3s;
        cursor: pointer;
    }

    .appCard:hover {
        background-color: #232428;
        color: #fff;
        box-shadow: 0 0 10px #222327;
    }

    .appCard img {
        width: 60px;
        height: 60px;
        border-radius: 7px;
        object-fit: cover;
    }

    .appCard h4 {
        font-family: URWGeometricMedium;
        font-size: 1.3rem;
        font-weight: 400;
        margin: 0;
        margin: auto;
        margin-top: 17px;
    }
</style>