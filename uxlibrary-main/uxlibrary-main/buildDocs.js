const fs = require('fs');

const sourceDir = './dist';
const destDir = './docs/dist';

fs.cpSync(sourceDir, destDir, {recursive: true});