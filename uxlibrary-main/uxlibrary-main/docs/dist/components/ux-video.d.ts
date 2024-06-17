import type { Components, JSX } from "../types/components";

interface UxVideo extends Components.UxVideo, HTMLElement {}
export const UxVideo: {
  prototype: UxVideo;
  new (): UxVideo;
};
/**
 * Used to define this component and all nested components recursively.
 */
export const defineCustomElement: () => void;
