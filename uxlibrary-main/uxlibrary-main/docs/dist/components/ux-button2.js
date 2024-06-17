import { proxyCustomElement, HTMLElement, h } from '@stencil/core/internal/client';
import { d as defineCustomElement$1 } from './ux-icon2.js';

const uxButtonCss = ":host{display:block}button{border:none}button:focus{outline:none}.button{display:inline-block;padding:0.5rem 1rem;font-size:1rem;font-weight:600;line-height:1.5;text-align:center;white-space:nowrap;vertical-align:middle;cursor:pointer;user-select:none;border-radius:0.25rem;transition:color 0.2s ease-in-out, background-color 0.2s ease-in-out, border-color 0.2s ease-in-out, box-shadow 0.2s ease-in-out;background-color:var(--containerSecondary);color:var(--textPrimary)}.prependIcon{margin-right:0.25rem}.appendIcon{margin-left:0.25rem}.button--shadow:hover{box-shadow:0px 0px 10px var(--containerSecondary)}.button--shadow:active{box-shadow:none !important}.button--rounded{border-radius:10rem}.button--ring{outline:2px solid transparent !important;transition:outline 0.1s ease-in-out}.button--ring:focus,.button--ring:active{outline:2px solid var(--ringColor) !important;outline-offset:2.5px}.button--block{display:block;width:100%}.button--xs{padding:0.25rem 0.5rem;font-size:0.75rem;line-height:1.5}.button--sm{padding:0.25rem 0.5rem;font-size:0.875rem;line-height:1.5}.button--md{padding:0.5rem 0.7rem;font-size:0.9rem;line-height:1.5}.button--lg{padding:0.5rem 1rem;font-size:1rem;line-height:1.5}.button--xl{padding:0.75rem 1.5rem;font-size:1.25rem;line-height:1.5}.button--primary{background-color:var(--primary);color:var(--textPrimary)}.button--shadow.button--primary:hover{box-shadow:0px 0px 10px var(--primary)}.button--secondary{background-color:var(--containerSecondary);color:var(--textPrimary)}.button--shadow.button--secondary:hover{box-shadow:0px 0px 10px var(--containerSecondary)}.button--success{background-color:var(--success);color:var(--textPrimary)}.button--shadow.button--success:hover{box-shadow:0px 0px 10px var(--success)}.button--info{background-color:var(--info);color:var(--textPrimary)}.button--shadow.button--info:hover{box-shadow:0px 0px 10px var(--info)}.button--warning{background-color:var(--warning);color:var(--textPrimary)}.button--shadow.button--warning:hover{box-shadow:0px 0px 10px var(--warning)}.button--danger{background-color:var(--danger);color:var(--textPrimary)}.button--shadow.button--danger:hover{box-shadow:0px 0px 10px var(--danger)}.button--error{background-color:var(--error);color:var(--textPrimary)}.button--shadow.button--error:hover{box-shadow:0px 0px 10px var(--error)}";

const UxButton = /*@__PURE__*/ proxyCustomElement(class extends HTMLElement {
  constructor() {
    super();
    this.__registerHost();
    this.rounded = false;
    this.text = undefined;
    this.size = 'md';
    this.prependIcon = undefined;
    this.appendIcon = undefined;
    this.type = 'secondary';
    this.color = undefined;
    this.block = false;
    this.disabled = false;
    this.loading = false;
    this.ring = false;
    this.shadow = true;
    this.elevation = 0;
  }
  styleState() {
    if (!this.color)
      return {
        ['--ringColor']: `var(--${this.type})`
      };
    return {
      backgroundColor: this.color,
      ['--ringColor']: this.color
    };
  }
  render() {
    return (h("button", { style: this.styleState(), class: `button ${this.type ? `button--${this.type}` : ''} ${this.elevation > 0 && this.elevation <= 6 ? `elevation-${this.elevation}` : ''} ${this.shadow ? `button--shadow` : ''} ${this.ring ? `button--ring` : ''} ${this.block ? `button--block` : ''} ${this.size ? `button--${this.size}` : ''} ${this.rounded ? 'button--rounded' : ''}` }, this.prependIcon ?
      h("ux-icon", { class: "prependIcon", icon: this.prependIcon })
      :
        null, this.text ?
      h("span", null, this.text)
      :
        h("slot", null), this.appendIcon ?
      h("ux-icon", { class: "appendIcon", icon: this.appendIcon })
      :
        null));
  }
  static get style() { return uxButtonCss; }
}, [4, "ux-button", {
    "rounded": [4],
    "text": [1],
    "size": [1],
    "prependIcon": [1, "prepend-icon"],
    "appendIcon": [1, "append-icon"],
    "type": [1],
    "color": [1],
    "block": [4],
    "disabled": [4],
    "loading": [4],
    "ring": [4],
    "shadow": [4],
    "elevation": [2]
  }]);
function defineCustomElement() {
  if (typeof customElements === "undefined") {
    return;
  }
  const components = ["ux-button", "ux-icon"];
  components.forEach(tagName => { switch (tagName) {
    case "ux-button":
      if (!customElements.get(tagName)) {
        customElements.define(tagName, UxButton);
      }
      break;
    case "ux-icon":
      if (!customElements.get(tagName)) {
        defineCustomElement$1();
      }
      break;
  } });
}

export { UxButton as U, defineCustomElement as d };
