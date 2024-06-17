import { p as promiseResolve, b as bootstrapLazy } from './index-66dd387c.js';
export { s as setNonce } from './index-66dd387c.js';

/*
 Stencil Client Patch Esm v2.22.2 | MIT Licensed | https://stenciljs.com
 */
const patchEsm = () => {
    return promiseResolve();
};

const defineCustomElements = (win, options) => {
  if (typeof window === 'undefined') return Promise.resolve();
  return patchEsm().then(() => {
  return bootstrapLazy([["ux-badge_10",[[1,"ux-playground",{"darkTheme":[32],"selectedComponent":[32],"refreshing":[32]}],[1,"ux-otp",{"length":[2],"useSeparators":[4,"use-separators"],"value":[1040],"separator":[1],"cellLength":[2,"cell-length"],"uppercaseCells":[4,"uppercase-cells"]}],[1,"ux-badge",{"rounded":[4],"text":[1],"size":[1],"prependIcon":[1,"prepend-icon"],"appendIcon":[1,"append-icon"],"type":[1],"color":[1]}],[1,"ux-card"],[1,"ux-slider",{"min":[2],"max":[2],"value":[2]}],[4,"ux-provider",{"darkTheme":[1028,"dark-theme"],"debugMode":[1028,"debug-mode"],"customTheme":[8,"custom-theme"]}],[1,"ux-select",{"appendIconOn":[1,"append-icon-on"],"appendIconOff":[1,"append-icon-off"],"rotateAppendIcon":[4,"rotate-append-icon"],"prependIconOn":[1,"prepend-icon-on"],"prependIconOff":[1,"prepend-icon-off"],"rotatePrependIcon":[4,"rotate-prepend-icon"],"defaultSelected":[1026,"default-selected"],"showSelectedOption":[1028,"show-selected-option"],"showMenu":[32]}],[1,"ux-textinput",{"value":[1],"rounded":[4],"prependIcon":[1,"prepend-icon"],"appendIcon":[1,"append-icon"],"placeholder":[1],"maxlength":[2]}],[4,"ux-button",{"rounded":[4],"text":[1],"size":[1],"prependIcon":[1,"prepend-icon"],"appendIcon":[1,"append-icon"],"type":[1],"color":[1],"block":[4],"disabled":[4],"loading":[4],"ring":[4],"shadow":[4],"elevation":[2]}],[0,"ux-icon",{"icon":[1],"size":[1]}]]],["ux-video",[[1,"ux-video",{"src":[1],"autoplay":[4],"loop":[4],"muted":[4],"controls":[4],"fullscreen":[1028],"theater":[1028],"hasVideoLoaded":[32],"isPlaying":[32],"isMuted":[32],"duration":[32],"currentTime":[32],"supportsPictureInPicture":[32],"isPictureInPicture":[32]}]]]], options);
  });
};

export { defineCustomElements };
