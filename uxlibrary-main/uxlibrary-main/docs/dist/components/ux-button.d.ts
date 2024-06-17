import type { Components, JSX } from "../types/components";

interface UxButton extends Components.UxButton, HTMLElement {}
export const UxButton: {
  prototype: UxButton;
  new (): UxButton;
};
/**
 * Used to define this component and all nested components recursively.
 */
export const defineCustomElement: () => void;
