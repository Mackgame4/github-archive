import type { Components, JSX } from "../types/components";

interface UxCard extends Components.UxCard, HTMLElement {}
export const UxCard: {
  prototype: UxCard;
  new (): UxCard;
};
/**
 * Used to define this component and all nested components recursively.
 */
export const defineCustomElement: () => void;
