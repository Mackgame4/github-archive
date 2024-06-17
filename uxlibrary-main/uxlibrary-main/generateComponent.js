const readline = require('readline');
const fs = require('fs-extra');

const rl = readline.createInterface({
    input: process.stdin,
    output: process.stdout
});

const componentsFolder = './src/components';
const boilerplateName = "ux-boilerplate";

function main() {
    rl.question('What is the name of your component? ', (componentName) => {
        componentName = componentName.toLowerCase();
        if (componentName.indexOf('-') === -1 || !componentName) {
            console.log('Component name needs to have a "-" to be a web component.');
            main();
            return;
        }
        // remove the "test" folder from being copied
        fs.copySync(`${componentsFolder}/${boilerplateName}`, `${componentsFolder}/${componentName}`, { filter: (src, dest) => !src.includes('test') });
        fs.renameSync(`${componentsFolder}/${componentName}/${boilerplateName}.tsx`, `${componentsFolder}/${componentName}/${componentName}.tsx`);
        fs.renameSync(`${componentsFolder}/${componentName}/${boilerplateName}.scss`, `${componentsFolder}/${componentName}/${componentName}.scss`);
        // replace the "ux-boilerplate" text inside each file with the component name and changes the class "UxBoilerplate" to the component name
        fs.readFile(`${componentsFolder}/${componentName}/${componentName}.tsx`, 'utf8', function (err,data) {
            if (err) {
                return console.log(err);
            }
            const result = data.replace(/ux-boilerplate/g, componentName).replace(/UxBoilerplate/g, (componentName.charAt(0).toUpperCase() + componentName.slice(1)).replace(/-([a-z])/g, function (g) { return g[1].toUpperCase(); }));
            fs.writeFile(`${componentsFolder}/${componentName}/${componentName}.tsx`, result, 'utf8', function (err) {
                if (err) return console.log(err);
            });
        });
        rl.close();
    });
}

main();