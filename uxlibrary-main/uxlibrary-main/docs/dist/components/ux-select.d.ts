import type { Components, JSX } from "../types/components";

interface UxSelect extends Components.UxSelect, HTMLElement {}
export const UxSelect: {
  prototype: UxSelect;
  new (): UxSelect;
};
/**
 * Used to define this component and all nested components recursively.
 */
export const defineCustomElement: () => void;
