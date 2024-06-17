/* uxlibrary custom elements */
export { MyComponent as UxBadge } from '../types/components/ux-badge/ux-badge';
export { UxButton as UxButton } from '../types/components/ux-button/ux-button';
export { UxCard as UxCard } from '../types/components/ux-card/ux-card';
export { UxIcon as UxIcon } from '../types/components/ux-icon/ux-icon';
export { UxOtp as UxOtp } from '../types/components/ux-otp/ux-otp';
export { UxPlayground as UxPlayground } from '../types/components/ux-playground/ux-playground';
export { MyComponent as UxProvider } from '../types/components/ux-provider/ux-provider';
export { UxSelect as UxSelect } from '../types/components/ux-select/ux-select';
export { UxSlider as UxSlider } from '../types/components/ux-slider/ux-slider';
export { UxTextinput as UxTextinput } from '../types/components/ux-textinput/ux-textinput';
export { UxVideo as UxVideo } from '../types/components/ux-video/ux-video';

/**
 * Used to manually set the base path where assets can be found.
 * If the script is used as "module", it's recommended to use "import.meta.url",
 * such as "setAssetPath(import.meta.url)". Other options include
 * "setAssetPath(document.currentScript.src)", or using a bundler's replace plugin to
 * dynamically set the path at build time, such as "setAssetPath(process.env.ASSET_PATH)".
 * But do note that this configuration depends on how your script is bundled, or lack of
 * bundling, and where your assets can be loaded from. Additionally custom bundling
 * will have to ensure the static assets are copied to its build directory.
 */
export declare const setAssetPath: (path: string) => void;

/**
 * Used to specify a nonce value that corresponds with an application's CSP.
 * When set, the nonce will be added to all dynamically created script and style tags at runtime.
 * Alternatively, the nonce value can be set on a meta tag in the DOM head
 * (<meta name="csp-nonce" content="{ nonce value here }" />) which
 * will result in the same behavior.
 */
export declare const setNonce: (nonce: string) => void

export interface SetPlatformOptions {
  raf?: (c: FrameRequestCallback) => number;
  ael?: (el: EventTarget, eventName: string, listener: EventListenerOrEventListenerObject, options: boolean | AddEventListenerOptions) => void;
  rel?: (el: EventTarget, eventName: string, listener: EventListenerOrEventListenerObject, options: boolean | AddEventListenerOptions) => void;
}
export declare const setPlatformOptions: (opts: SetPlatformOptions) => void;
export * from '../types';
