import type { Components, JSX } from "../types/components";

interface UxSlider extends Components.UxSlider, HTMLElement {}
export const UxSlider: {
  prototype: UxSlider;
  new (): UxSlider;
};
/**
 * Used to define this component and all nested components recursively.
 */
export const defineCustomElement: () => void;
