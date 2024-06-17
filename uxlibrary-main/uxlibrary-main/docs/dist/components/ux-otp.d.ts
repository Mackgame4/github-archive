import type { Components, JSX } from "../types/components";

interface UxOtp extends Components.UxOtp, HTMLElement {}
export const UxOtp: {
  prototype: UxOtp;
  new (): UxOtp;
};
/**
 * Used to define this component and all nested components recursively.
 */
export const defineCustomElement: () => void;
