const fs = require('fs')
const { exec } = require('child_process');

setWatcher('./contracts', 'truffle compile && npm run generate-types')

function setWatcher(watchedDir, cmd) {
    console.log('[Start watch]:', ...arguments)
    const useCmd = () => exec(cmd, (error, stdout, stderr) => {
        if (error) {
            console.error(`error: ${watchedDir} ${error.message}`);
            return;
        }
        if (stderr) {
            console.error(`stderr: ${watchedDir} ${stderr}`);
            return;
        }
        console.log(`stdout:\n${stdout}`);
    });
    fs.watch(watchedDir, (event, filename) => {
        if (filename) {
            console.log(`${filename} file Changed`)
            useCmd()
        }
    })
    useCmd()
}