import { Config } from '@stencil/core';
import tailwind, { setPluginConfigurationDefaults, tailwindHMR } from 'stencil-tailwind-plugin';
import tailwindConfig from './tailwind.config';

const tailwindOpts = {
  debug: false,
  tailwindCssPath: './src/styles/tailwind.css',
  tailwindConf: tailwindConfig,
  stripComments: true,
  minify: true
}

setPluginConfigurationDefaults(tailwindOpts);

export const config: Config = {
  namespace: 'cosmosui',
  globalStyle: './src/styles/tailwind.css',
  plugins: [
    tailwind(),
    tailwindHMR()
  ],
  devServer: {
    reloadStrategy: 'pageReload'
  },
  outputTargets: [
    {
      type: 'dist',
      //esmLoaderPath: '../loader',
    },
    {
      type: 'dist-custom-elements',
    },
    {
      type: 'docs-readme',
    },
    {
      type: 'docs-json',
      file: 'src/utils/docs.json'
    },
    {
      type: 'www',
      serviceWorker: null, // disable service workers
    },
  ],
  testing: {
    browserHeadless: "new",
  },
};
