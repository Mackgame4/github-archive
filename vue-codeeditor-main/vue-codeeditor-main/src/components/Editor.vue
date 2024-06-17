<template>
  <div id="editor" ref="editor" @mouseup="mouseup()"></div>
</template>

<script>
import * as monaco from 'monaco-editor';

export default {
  name: 'Editor',
  components: {
  },
  data() {
    return {
      cursorStyle: 'block'
    }
  },
  async mounted() {
    const el = this.$refs.editor;
    this.editor = monaco.editor.create(el, {
      value: "console.log('hello world');",
      language: 'javascript',
      theme: 'vs-dark',
      lineHeight: 1.8,
      fontSize: 16,
      fontFamily: 'FiraCode',
      fontLigatures: true,
      autoIndent: false,
      formatOnType: true,
      formatOnPaste: true,
      renderLineHighlight: "gutter",
      cursorStyle: this.cursorStyle,
      cursorBlinking: "solid",
      overviewRulerBorder: false,
      //lineNumbers: 'off',
      glyphMargin: false,
      //folding: false,
      lineDecorationsWidth: 0, // Undocumented see https://github.com/Microsoft/vscode/issues/30795#issuecomment-410998882
      lineNumbersMinChars: 4.5,
      roundedSelection: false,
      scrollBeyondLastLine: false,
      readOnly: false,
      minimap: {
        enabled: false
      }
    });
    this.changeTheme('Pastels on Dark');
    this.$nextTick(() => {
      var self = this;
      window.onresize = function (){
        console.log("window resize");
        self.editor.layout();
      };
      /*document.getElementById("editor").addEventListener("dblclick", function() {
        self.changeCursorStyle();
      });*/
      // Debug
      this.editor.addCommand(monaco.KeyCode.F9, function () {
        console.log("F9 pressed");
        self.setEditorTheme();
      });
    });
  },
  methods: {
    mouseup() {
      if (window.getSelection) {
        let text = window.getSelection().toString()
        if (text.length > 0) {
          this.editor.updateOptions({
            cursorStyle: 'line'
          });
        } else {
          this.editor.updateOptions({
            cursorStyle: 'block'
          });
        }
      }
    },
    changeTheme(theme) {
      import('monaco-themes/themes/'+theme+'.json').then(data => {
        let name = theme.replace(/\s/g, '');
        monaco.editor.defineTheme(name, data);
        monaco.editor.setTheme(name);
      })
    },
    setEditorTheme() {
      monaco.editor.defineTheme('myTheme', {
        base: 'vs',
        inherit: true,
        rules: [{ background: 'EDF9FA' }],
        colors: {
          'editor.foreground': '#000000',
          'editor.background': '#EDF9FA',
          'editorCursor.foreground': '#8B0000',
          "editor.cursorStyle": "block",
          "editor.cursorBlinking": "phase",
          'editor.lineHighlightBackground': '#0000FF20',
          'editorLineNumber.foreground': '#008800',
          'editor.selectionBackground': '#88000030',
          'editor.inactiveSelectionBackground': '#88000015'
        }
      });
      monaco.editor.setTheme('myTheme');
    }
  }
}
</script>

<style>
#editor {
  height: 100%;
  width: 100%;
  margin: 0 !important;
}

.monaco-editor {
  height: 100%;
  width: 100%;
  margin: 0 !important;
}

.monaco-editor .rename-box {
  display: none !important;
}

.monaco-editor .slider {
  margin: 0 !important;
}

div.monaco-editor {    
  text-rendering: optimizeLegibility;
}
</style>