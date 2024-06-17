import type { Components, JSX } from "../types/components";

interface UxIcon extends Components.UxIcon, HTMLElement {}
export const UxIcon: {
  prototype: UxIcon;
  new (): UxIcon;
};
/**
 * Used to define this component and all nested components recursively.
 */
export const defineCustomElement: () => void;
