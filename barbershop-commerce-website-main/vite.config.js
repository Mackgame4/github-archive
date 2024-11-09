import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'
import path from 'path'
import inject from "@rollup/plugin-inject";

// https://vitejs.dev/config/
export default defineConfig({
  base: './',
  plugins: [
    inject({
      $: 'jquery',
      jQuery: 'jquery',
    }),
    vue()],
  resolve: {
    alias: {
      '@': path.resolve(__dirname, './src'),
      './runtimeConfig': './runtimeConfig.browser',
    },
  },
  rollupOptions: {
      output: {
          globals: {
            jquery: 'window.jQuery',
            jquery: 'window.$'
          }
      }
  }
})
