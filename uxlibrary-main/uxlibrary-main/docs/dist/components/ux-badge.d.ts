import type { Components, JSX } from "../types/components";

interface UxBadge extends Components.UxBadge, HTMLElement {}
export const UxBadge: {
  prototype: UxBadge;
  new (): UxBadge;
};
/**
 * Used to define this component and all nested components recursively.
 */
export const defineCustomElement: () => void;
