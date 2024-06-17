<template>
  <div id="app">
    <div class="editorContainer">
      <Editor></Editor>
    </div>
    <div class="terminalContainer">
      <Terminal></Terminal>
    </div>
  </div>
</template>

<script>
import Editor from './components/Editor.vue'
import Terminal from './components/Terminal.vue'

export default {
  name: 'App',
  components: {
    Editor,
    Terminal
  },
  data() {
    return {
    }
  },
  mounted() {
  },
  methods: {
  }
}
</script>

<style>
@font-face {
  font-family: 'FiraCode';
  src: local("FiraCode"),
    url('~@/assets/fonts/FiraCode/woff2/FiraCode-Regular.woff2') format('woff2'),
    url('~@/assets/fonts/FiraCode/woff/FiraCode-Regular.woff') format('woff'),
    url('~@/assets/fonts/FiraCode/ttf/FiraCode-Regular.ttf') format('truetype');
  font-weight: normal;
  font-style: normal;
}

body, html {
  margin: 0;
  padding: 0;
}

::-webkit-scrollbar {
  width: 12px;
}

::-webkit-scrollbar-track {
  background: none; 
}

::-webkit-scrollbar-thumb {
  background: rgba(121, 121, 121, 0.45); 
}

::-webkit-scrollbar-thumb:hover {
  background: rgba(121, 121, 121, 0.6); 
}

#app {
  width: 100vw !important;
  height: 100vh !important;
  font-family: 'Fira Code';
  text-rendering: optimizeLegibility;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
}

.editorContainer {
  width: 100vw;
  height: 50vh;
  background-color: red;
}

.terminalContainer {
  width: 100vw;
  height: 20vh;
  background-color: blue;
}
</style>
