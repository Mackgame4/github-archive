'use strict'

import { app, protocol, BrowserWindow, ipcMain} from 'electron'
import { createProtocol } from 'vue-cli-plugin-electron-builder/lib'
const isDevelopment = process.env.NODE_ENV !== 'production'

const execa = require('execa');
const iconv = require("iconv-lite");
//var path = require('path');

let win;
let child;

protocol.registerSchemesAsPrivileged([
  { scheme: 'app', privileges: { secure: true, standard: true } }
])

const windowStateKeeper = require('electron-window-state');

function createWindow () {
  // Create the browser window.
  let mainWindowState = windowStateKeeper({
    defaultWidth: 1000,
    defaultHeight: 800
  });

  win = new BrowserWindow({
    x: mainWindowState.x,
    y: mainWindowState.y,
    width: mainWindowState.width,
    height: mainWindowState.height,
    webPreferences: {
      nodeIntegration: true,
      contextIsolation: false
    },
    backgroundColor: '#1E1E1E',
    autoHideMenuBar: true, // isDevelopment ? false : true,
    //show: false
  })

  mainWindowState.manage(win);

  if (process.env.WEBPACK_DEV_SERVER_URL) {
    win.loadURL(process.env.WEBPACK_DEV_SERVER_URL)
    if (!process.env.IS_TEST) win.webContents.openDevTools()
  } else {
    createProtocol('app')
    win.loadURL('app://./index.html')
  }

  win.on('closed', () => {
    win = null
  })

  win.webContents.on('did-finish-load', () => {
    let command = "cmd";
    let args = [];

    child = execa(command, args, {
      cwd: app.getPath('home'), // path.dirname(__dirname)
      stdio: ['pipe', 'pipe', 'pipe'],
      shell: true,
      env: process.env,
    })

    child.stdout.on('data', buffer => {
      if (process.platform === 'win32') {
          buffer = iconv.decode(buffer, "windows-31j");
      }
      //console.log(buffer.toString());
      win.webContents.send('terminal', buffer.toString());
    })

    child.stderr.on('data', buffer => {
      if (process.platform === 'win32') {
          buffer = iconv.decode(buffer, "windows-31j");
      }
      //console.log(buffer.toString());
      win.webContents.send('terminal', buffer.toString());
    })

    child.on('exit', (code, signal) => {
      console.log('Task exit', command, args, 'code:', code, 'signal:', signal)
    })

    child.on('error', error => {
      console.error(error)
      win.webContents.send('terminal', error.message.toString());
    });

    child.on('close', (code) => {
      console.log('pid:'+ child.pid)
      console.log(`child process exited with code ${code}`);
    });

  });
}

ipcMain.on('terminal', (event, arg) => {
  //console.log(arg);
  //let _ev = JSON.parse(arg);
  process.stdout.write(arg);
  //event.reply('terminal', 'pong')
  child.stdin.write(arg);
  if (arg != "" && arg != null) {
    child.stdin.write("\n");
  }
  //console.log('pid:'+ child.pid)
  //child.stdin.end();
})

// Quit when all windows are closed.
app.on('window-all-closed', () => {
  // On macOS it is common for applications and their menu bar
  // to stay active until the user quits explicitly with Cmd + Q
  if (process.platform !== 'darwin') {
    app.quit()
  }
})

app.on('activate', () => {
  // On macOS it's common to re-create a window in the app when the
  // dock icon is clicked and there are no other windows open.
  if (win === null) {
    createWindow()
  }
})

// This method will be called when Electron has finished
// initialization and is ready to create browser windows.
// Some APIs can only be used after this event occurs.
app.on('ready', async () => {
  if (isDevelopment && !process.env.IS_TEST) {
    // Install Vue Devtools
    try {
      //await installVueDevtools()
    } catch (e) {
      console.error('Vue Devtools failed to install:', e.toString())
    }
  }
  createWindow()
})

// Exit cleanly on request from parent process in development mode.
if (isDevelopment) {
  if (process.platform === 'win32') {
    process.on('message', data => {
      if (data === 'graceful-exit') {
        app.quit()
      }
    })
  } else {
    process.on('SIGTERM', () => {
      app.quit()
    })
  }
}