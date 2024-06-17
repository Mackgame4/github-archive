import { Terminal } from 'xterm'
import { FitAddon } from 'xterm-addon-fit';
import { AttachAddon } from 'xterm-addon-attach';
Terminal.applyAddon(FitAddon)
Terminal.applyAddon(AttachAddon)

export default Terminal