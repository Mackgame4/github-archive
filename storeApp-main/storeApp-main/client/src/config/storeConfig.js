const config = {
  storeName: 'Alma Store',
  logo: 'https://i.imgur.com/9lhSpme.png',
  logoLight: 'https://i.imgur.com/aBs4L1s.png',
  currency: '€',
  socialMedia: {
    facebook: 'https://www.facebook.com/Alma-Store-102323855615304',
    twitter: 'https://www.facebook.com/joana.oliveira.58367',
    instagram: 'https://www.instagram.com/almastore2022',
  },
  stores: [
    { location: 'Arco de Baúlhe', address: 'Av. Cap. Elísio de Azevedo A69, 4860-041', phone: '+351 934 921 763', email: 'oliveirajoana2808@gmail.com', latlng: [41.4852009,-7.9630336] },
  ],
  vuescrollOptions: {
    scrollPanel: {
      initialScrollY: false,
      initialScrollX: false,
      scrollingX: false,
      scrollingY: true,
      verticalNativeBarPos: 'right'
    },
    vuescroll: {
      detectResize: false
    },
    bar: {
      showDelay: 800,
      onlyShowBarOnScroll: true,
      background: '#c1c1c1',
      opacity: 0.6,
      minSize: 0,
      size: '6px'
    }
  },
}

export const storeConfig = config;