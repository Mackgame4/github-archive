import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'

// https://vitejs.dev/config/
export default defineConfig({
  plugins: [react()],
  resolve: {
    alias: {
      'react-pdf': 'react-pdf/dist/esm/entry.webpack.js',
    },
  },
  optimizeDeps: {
    include: ['@react-pdf/renderer'],
  }
})
