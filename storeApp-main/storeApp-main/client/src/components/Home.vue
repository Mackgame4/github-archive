
<template>
  <div id="home" style="height: 100%; margin-top: 25px;">
    <div style="margin-bottom: 68px;" class="desktop-only"></div>
    <!--div style="display: table; margin: 30px auto 30px auto;" class="desktop-only"><span class="badge sf-badge" @click="$router.push('/').catch(()=>{})">Inicio</span> | <span class="badge sf-badge" @click="$router.push('/store').catch(()=>{})">Loja</span> | <span class="badge sf-badge" @click="$router.push('/pages').catch(()=>{})">Páginas</span> | <span class="badge sf-badge" @click="$router.push('/account').catch(()=>{})">Conta</span></div-->
    <SfHero class="hero">
      <SfHeroItem v-for="(img, index) in heroes" :key="index" :image="img.image" :title="img.title" :subtitle="img.subtitle" :button-text="img.buttonText" link="/store" :background="img.background" :class="img.className" />
    </SfHero>
    <SfBannerGrid class="banner-grid">
      <template v-for="banner in banners" #[banner.slot]>
        <SfBanner :key="banner.slot" :title="banner.title" :subtitle="banner.subtitle" :description="banner.description" :button-text="banner.buttonText" :image="banner.image" :class="banner.class" @click="$router.push('/store').catch(()=>{})">
          <template #title>
            <SfHeading :title="banner.title" :level="2" class="sf-heading--no-underline sf-heading--left sf-banner__title" @click="$router.push('/store').catch(()=>{})" />
          </template>
          <template #subtitle>
            <span class="banner-grid__subtitle" @click="$router.push('/store').catch(()=>{})">{{ banner.subtitle }}</span>
          </template>
        </SfBanner>
      </template>
    </SfBannerGrid>
    <SfCallToAction class="call-to-action" title="Subscreve a nossa Newsletters" description="Esteja atualizado das próximas vendas e eventos. Receba presentes e ofertas especiais!" button-text="Subscrever" image="https://docs.storefrontui.io/assets/storybook/Home/newsletter.jpg" @click="$router.push('/pages-2')" />
    <div class="match-with-it">
      <p class="match-with-it__paragraph">Moda para takeaway</p>
      <SfButton class="sf-button--text smartphone-only" @click="$router.push('/store').catch(()=>{})">Ver tudo</SfButton>
    </div>
    <SfCarousel v-if="!isProductLoading" :settings="{ peek: 16, breakpoints: { 1023: { peek: 0, perView: 2 } } }" class="carousel">
      <SfCarouselItem v-for="(product, index) in products" :key="index" class="carousel__item">
        <SfProductCard
          :image="product.thumbnail_url"
          :title="product.title"
          :link="'/product/' + product.id"
          :regular-price="storeConfig.currency+product.price.regular"
          :special-price="product.price.sale != 0 ? storeConfig.currency+product.price.sale : ''"
          :badgeLabel="!product.new ? product.quantity <= 2 ? 'Pouco Stock' : '' : 'New'"
          :show-add-to-cart-button="true"
          wishlistIcon=""
          :addToCartDisabled="product.quantity === 0"
          @click:add-to-cart="addItem(product)"
        />
      </SfCarouselItem>
    </SfCarousel>
    <SfSection title-heading="#Share Your Look" subtitle-heading="#almastore2022" class="share-your-look">
      <div class="instagram-grid">
        <div class="grid__row">
          <div class="grid__col">
            <SfImage class="smartphone-only" src="https://i.imgur.com/LtKuc2F.jpg" alt="@almastore2022" :width="140" :height="140">@almastore2022</SfImage>
            <SfImage class="desktop-only" src="https://i.imgur.com/LtKuc2F.jpg" alt="@almastore2022" :width="470" :height="470">@almastore2022</SfImage>
          </div>
          <div class="grid__col small">
            <SfImage class="smartphone-only" src="https://i.imgur.com/CMWxFX2.png" alt="@almastore2022" :width="140" :height="140">@almastore2022</SfImage>
            <SfImage class="desktop-only" src="https://i.imgur.com/CMWxFX2.png" alt="@almastore2022" :width="470" :height="160">@almastore2022</SfImage>
          </div>
        </div>
        <div class="grid__row gap">
          <div class="grid__col small">
            <SfImage class="smartphone-only" src="https://i.imgur.com/D2Rqppj.png" alt="@joana___oliveiraa" :width="140" :height="140">@joana___oliveiraa</SfImage>
            <SfImage class="desktop-only" src="https://i.imgur.com/D2Rqppj.png" alt="@joana___oliveiraa" :width="470" :height="160">@joana___oliveiraa</SfImage>
          </div>
          <div class="grid__col">
            <SfImage class="smartphone-only" src="https://i.imgur.com/7rn5NSw.png" alt="@joana___oliveiraa" :width="140" :height="140">@joana___oliveiraa</SfImage>
            <SfImage class="desktop-only" src="https://i.imgur.com/7rn5NSw.png" alt="@joana___oliveiraa" :width="470" :height="470">@joana___oliveiraa</SfImage>
          </div>
        </div>
      </div>
    </SfSection>
    <SfBanner class="app-banner desktop-only" subtitle="Moda em todo o mundo" image="https://i.imgur.com/JhE0M0F.png">
      <template #title>
        <span class="app-banner__title">Transfere a nossa aplicação para telemóvel.</span>
      </template>
      <template #call-to-action>
        <div class="app-banner__call-to-action">
          <SfButton class="app-banner__button sf-banner__call-to-action" aria-label="Go to Apple Product" @click="sendNotification(storeConfig.storeName+' mobile app is in development.')">
            <SfImage src="https://docs.storefrontui.io/assets/storybook/Home/apple.png" alt="Apple" :width="134" :height="44" />
          </SfButton>
          <SfButton class="app-banner__button sf-banner__call-to-action" aria-label="Go to Google Product" @click="sendNotification(storeConfig.storeName+' mobile app is in development.')">
            <SfImage src="https://docs.storefrontui.io/assets/storybook/Home/google.png" alt="Google" :width="134" :height="44" />
          </SfButton>
        </div>
      </template>
    </SfBanner>
  </div>
</template>
<script>
import { storeConfig } from '../config/storeConfig';
import { mapActions, mapGetters } from 'vuex';
import { SfButton, SfHero, SfBannerGrid, SfBanner, SfCallToAction, SfSection, SfCarousel, SfProductCard, SfImage, SfHeading } from "@storefront-ui/vue";

export default {
  name: "Home",
  components: {
    SfButton,
    SfHero,
    SfBannerGrid,
    SfBanner,
    SfCallToAction,
    SfSection,
    SfCarousel,
    SfProductCard,
    SfImage,
    SfHeading
  },
  data() {
    return {
      storeConfig,
      heroes: [
        {
          title: "Casacos e botins de inverno já mais confortáveis da estação.",
          subtitle: "COLEÇÃO DE INVERNO 2022",
          buttonText: "Ver mais",
          background: "rgb(236, 239, 241)",
          image: "https://docs.storefrontui.io/assets/storybook/Home/hero.png",
        },
        {
          title: "Camisolas divertidas para uma primavera estilosa.",
          subtitle: "COLEÇÃO DE PRIMAVERA 2022",
          buttonText: "Ver mais",
          background: "rgb(239, 235, 233)",
          image: "https://docs.storefrontui.io/assets/storybook/Home/bannerHM.jpg",
          className:
            "sf-hero-item--position-bg-top-left sf-hero-item--align-right",
        },
        {
          title: "Vestidos coloridos de verão já estão na loja!",
          subtitle: "COLEÇÃO DE VERÃO 2022",
          buttonText: "Ver mais",
          background: "rgb(236, 239, 241)",
          image: "https://docs.storefrontui.io/assets/storybook/Home/hero.png",
        },
      ],
      banners: [
        {
          slot: "banner-A",
          subtitle: "Vestidos",
          title: "Festas & Cocktails",
          description: "Encontre os vestidos femininos mais deslumbrantes para arrasar nas festas. Destaque-se em vestidos de renda e metalizados de todas as suas marcas favoritas.",
          buttonText: "Comprar agora",
          image: "https://docs.storefrontui.io/assets/storybook/Home/bannerF.jpg",
          class: "desktop-only",
        },
        {
          slot: "banner-B",
          subtitle: "Roupas",
          title: "Camisolas, Casacos & Blusas",
          description: "Encontre a moda feminina mais deslumbrantes da estação. Destaca a tua beleza em todas as suas marcas favoritas.",
          buttonText: "Comprar agora",
          image: "https://docs.storefrontui.io/assets/storybook/Home/bannerE.jpg",
          class: "desktop-only",
        },
        {
          slot: "banner-C",
          subtitle: "T-Shirts",
          title: "Roupa do Quotidiano",
          image: "https://docs.storefrontui.io/assets/storybook/Home/bannerC.jpg",
        },
        {
          slot: "banner-D",
          subtitle: "Sapatos",
          title: "Botas & Botins",
          image: "https://i.imgur.com/2AzrRGH.png",
        },
      ],
    };
  },
  computed: {
    ...mapGetters(['products', 'isProductLoading']),
  },
  methods: {
    ...mapActions(['updateCart']),
    addItem(product) {
      const order = {
        item: Object.assign({}, product),
        quantity: 1,
        isAdd: true
      };
      this.updateCart(order);
    },
    sendNotification(message) {
      this.$toast.info(message);
    },
  }
};
</script>
<style lang="scss" scoped>
@import "~@storefront-ui/vue/styles";
.badge {
  margin-left: 20px;
  margin-right: 20px;
  cursor: pointer;
}
#home {
  box-sizing: border-box;
  padding: 0 var(--spacer-sm);
  @include for-desktop {
    padding: 0 var(--spacer-sm);
    max-width: 1272px;
    margin: 0 auto;
  }
}
.hero {
  --hero-item-background-position: center;
}
.match-with-it {
  display: flex;
  justify-content: space-between;
  align-items: baseline;
  margin-top: var(--spacer-xl);
  font-size: var(--h3-font-size);
  font-family: var(--font-family--secondary);
  font-weight: var(--font-weight--bold);
  border-bottom: solid 1px var(--c-light);
  &__paragraph {
    margin-bottom: var(--spacer-xs);
  }
  @include for-desktop {
    border: none;
    justify-content: center;
    font-weight: var(--font-weight--semibold);
  }
}
.carousel {
  margin: 0 calc(-1 * var(--spacer-sm)) 0 0;
  @include for-desktop {
    margin: 0;
  }
  &__item {
    margin: 1.9375rem 0 2.4375rem 0;
  }
}
.banner-grid {
  margin: var(--spacer-base) 0;
  --banner-container-width: 50%;
  &__subtitle {
    font-weight: var(--font-weight--normal);
    font-size: var(--font-size--base);
    font-family: var(--font-family--secondary);
    color: var(--c-gray);
    text-transform: uppercase;
  }
  @include for-desktop {
    margin: var(--spacer-2xl) 0;
  }
}
.share-your-look {
  --heading-title-font-weight: var(--font-weight--semibold);
  @include for-desktop {
    --section-margin: var(--spacer-2xl) 0;
  }
}
.call-to-action {
  display: flex;
}
.instagram-grid {
  display: flex;
  max-height: 20.625rem;
  width: 100%;
  justify-content: center;
  margin: 0;
  @include for-desktop {
    max-height: 40.625rem;
    max-width: 60rem;
    margin: 0 auto;
  }
  &__row {
    display: flex;
    flex-direction: column;
  }
  .gap {
    margin-left: var(--spacer-xs);
    @include for-desktop {
      margin-left: var(--spacer-sm);
    }
  }
  &__col {
    width: 10rem;
    height: 10rem;
    @include for-desktop {
      &.small {
        height: 10rem;
      }
      width: 29.375rem;
      height: 29.375rem;
    }
    & + & {
      margin-top: var(--spacer-xs);
      @include for-desktop {
        margin-top: var(--spacer-sm);
      }
    }
  }
}
.app-banner {
  --banner-container-width: 100%;
  --banner-padding: 0 var(--spacer-2xl);
  --banner-subtitle-font-size: var(--font-size--xl);
  --banner-subtitle-font-weight: var(--font-weight--medium);
  --banner-subtitle-text-transform: capitalize;
  &__title {
    margin: var(--spacer-base) 0 var(--spacer-xl) 0;
    font-size: var(--h1-font-size);
    font-family: var(--font-family--secondary);
    font-weight: var(--font-weight--semibold);
    text-transform: capitalize;
  }
  display: block;
  min-height: 26.25rem;
  max-width: 65rem;
  margin: 0 auto;
  padding: 0 calc(25% + var(--spacer-2xl)) 0 var(--spacer-xl);
  &__call-to-action {
    --button-background: transparent;
    display: flex;
  }
  &__button {
    --image-width: 8.375rem;
    --image-height: 2.75rem;
    --button-padding: 0;
    & + & {
      margin: 0 0 0 calc(var(--spacer-xl) / 2);
    }
  }
}
</style>