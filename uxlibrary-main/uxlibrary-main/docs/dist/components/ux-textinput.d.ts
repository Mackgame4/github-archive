import type { Components, JSX } from "../types/components";

interface UxTextinput extends Components.UxTextinput, HTMLElement {}
export const UxTextinput: {
  prototype: UxTextinput;
  new (): UxTextinput;
};
/**
 * Used to define this component and all nested components recursively.
 */
export const defineCustomElement: () => void;
