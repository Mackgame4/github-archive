import type { Components, JSX } from "../types/components";

interface UxProvider extends Components.UxProvider, HTMLElement {}
export const UxProvider: {
  prototype: UxProvider;
  new (): UxProvider;
};
/**
 * Used to define this component and all nested components recursively.
 */
export const defineCustomElement: () => void;
