import type { Components, JSX } from "../types/components";

interface UxPlayground extends Components.UxPlayground, HTMLElement {}
export const UxPlayground: {
  prototype: UxPlayground;
  new (): UxPlayground;
};
/**
 * Used to define this component and all nested components recursively.
 */
export const defineCustomElement: () => void;
