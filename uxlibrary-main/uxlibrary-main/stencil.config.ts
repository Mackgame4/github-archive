import { Config } from '@stencil/core';
import { sass } from '@stencil/sass';
import tailwind, { tailwindHMR } from 'stencil-tailwind-plugin';

export const config: Config = {
  namespace: 'uxlibrary',
  plugins: [
    tailwind(),
    tailwindHMR(),
    sass({
      injectGlobalPaths: [
        'src/styles/global.scss',
        'src/styles/variables.scss',
        'src/styles/mixins.scss'
      ]
    })
  ],
  outputTargets: [
    {
      type: 'dist',
      esmLoaderPath: '../loader',
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
};