<template>
  <div id="terminal" ref="terminal"></div>
</template>

<script>
import { Terminal } from 'xterm';
import { FitAddon } from 'xterm-addon-fit';
import 'xterm/css/xterm.css';
import { ipcRenderer } from 'electron'

export default {
  name: 'Terminal',
  components: {
  },
  data() {
    return {
      term: new Terminal({ fontFamily: 'FiraCode' }),
      fitAddon: new FitAddon()
    }
  },
  mounted() {
    this.$nextTick(() => {
      var self = this;
      window.onresize = function (){
        self.fitAddon.fit();
      };
    });
    //const el = this.$refs.editor;
    this.term.loadAddon(this.fitAddon);
    this.term.setOption('theme', {
      background: '#1E1E1E'
    });
    // Open the terminal in #terminal-container
    this.term.open(document.getElementById('terminal'));
    // Make the terminal's size and geometry fit the size of #terminal-container
    this.fitAddon.fit();
    this.term.write('Hello from \x1B[1;3;31mxterm.js\x1B[0m $ ')
    let text = '';
    this.term.onData(data => {
      if (data === '\r' || data === '\n') {
        ipcRenderer.send('terminal', text);
        for (let i = 0; i < text.length; i++) {
          this.term.write('\b');
        }
        text = '';
      } else {
        if (data === '\x7F') {
          text = text.slice(0, -1);
          this.term.write('\b \b');
        } else {
          text += data;
          this.term.write(data);
        }
      }
      console.log("data:"+data, "text:"+text);
    })
    ipcRenderer.on('terminal', (event, arg) => {
      console.log(event, arg);
      this.buffer = arg;
      this.term.write(arg);
    })
  },
  methods: {
  }
}
</script>

<style>
#terminal {
  height: 100%;
  width: 100%;
  margin: 0 !important;
}
</style>