// Learn more https://docs.expo.io/guides/customizing-metro
const { getDefaultConfig } = require('expo/metro-config');

/** @type {import('expo/metro-config').MetroConfig} */
const config = getDefaultConfig(__dirname);

// Adds support for `mjs` files
config.resolver.sourceExts.push('mjs'); // config.watcher.additionalExts.push('mjs', 'cjs');

module.exports = config;