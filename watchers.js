const fs = require('fs')
const { exec } = require('child_process');

cleanDirs()
setWatcher('./contracts', 'truffle compile && npm run generate-types')

function setWatcher(watchedDir, cmd) {
    console.log('[Start watch]:', ...arguments)
    const useCmd = debounce(filename => {
        console.log(`${filename} file Changed`)
        exec(cmd, (error, stdout, stderr) => {
            if (error) {
                console.error(`error: ${watchedDir} ${error.message}`);
                return;
            }
            if (stderr) {
                console.error(`stderr: ${watchedDir} ${stderr}`);
                return;
            }
            console.log(`stdout:\n${stdout}`);
        })
    }, 1000)
    fs.watch(watchedDir, (event, filename) => {
        if (filename) {
            useCmd(filename)
        }
    })
    useCmd('pre')
}

function cleanDirs(dirs = ['./build', './types']) {
    for (let dirName of dirs) {
        if (fs.existsSync(dirName)) {
            console.log('Clean', dirName)
            fs.rmSync(dirName, { recursive: true, force: true })
        }
    }

}

function debounce(f, ms) {
    let isCooldown = false;
    return function () {
        if (isCooldown) return;
        f.apply(this, arguments);
        isCooldown = true;
        setTimeout(() => isCooldown = false, ms);
    };
}
