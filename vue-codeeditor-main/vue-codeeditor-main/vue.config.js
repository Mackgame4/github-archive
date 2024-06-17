const monacoWebpackPlugin = require("monaco-editor-webpack-plugin");

module.exports = {
  productionSourceMap: false,
  configureWebpack: {
    plugins: [new monacoWebpackPlugin()],
  },
  pluginOptions: {
    electronBuilder: {
      nodeIntegration: true
    }
  }
};