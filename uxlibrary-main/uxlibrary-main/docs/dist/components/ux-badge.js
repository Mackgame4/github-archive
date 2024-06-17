import { proxyCustomElement, HTMLElement, h } from '@stencil/core/internal/client';
import { d as defineCustomElement$2 } from './ux-icon2.js';

const uxBadgeCss = ":host{display:block}.badge{display:inline-block;padding:0.25rem 0.5rem;font-size:0.75rem;font-weight:600;line-height:1;text-align:center;white-space:nowrap;vertical-align:baseline;border-radius:0.25rem;background-color:var(--containerSecondary)}.prependIcon{margin-right:0.25rem}.appendIcon{margin-left:0.25rem}.badge--rounded{border-radius:10rem}.badge--xs{padding:0.25rem 0.45rem;font-size:0.55rem}.badge--sm{padding:0.25rem 0.5rem;font-size:0.65rem}.badge--md{padding:0.25rem 0.5rem;font-size:0.75rem}.badge--lg{padding:0.25rem 0.5rem;font-size:0.85rem}.badge--xl{padding:0.25rem 0.5rem;font-size:1.0rem}.badge--primary{background-color:var(--primary);color:var(--textPrimary)}.badge--secondary{background-color:var(--secondary);color:var(--textSecondary)}.badge--success{background-color:var(--success);color:var(--textOnSuccess)}.badge--error{background-color:var(--error);color:var(--textOnError)}.badge--warning{background-color:var(--warning);color:var(--textOnWarning)}.badge--danger{background-color:var(--danger);color:var(--textOnDanger)}.badge--info{background-color:var(--info);color:var(--textOnInfo)}";

const MyComponent = /*@__PURE__*/ proxyCustomElement(class extends HTMLElement {
  constructor() {
    super();
    this.__registerHost();
    this.__attachShadow();
    this.rounded = false;
    this.text = undefined;
    this.size = 'md';
    this.prependIcon = undefined;
    this.appendIcon = undefined;
    this.type = undefined;
    this.color = undefined;
  }
  /*private getText(): string {
    return this.first;
  }*/
  render() {
    return (
    //<span class={{ 'badge': true, 'badge--rounded': this.rounded }}></span>
    // or with interpolation
    h("span", { style: this.color ? { backgroundColor: this.color } : null, class: `badge ${this.type ? `badge--${this.type}` : ''} ${this.size ? `badge--${this.size}` : ''} ${this.rounded ? 'badge--rounded' : ''}` }, this.prependIcon ?
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
  static get style() { return uxBadgeCss; }
}, [1, "ux-badge", {
    "rounded": [4],
    "text": [1],
    "size": [1],
    "prependIcon": [1, "prepend-icon"],
    "appendIcon": [1, "append-icon"],
    "type": [1],
    "color": [1]
  }]);
function defineCustomElement$1() {
  if (typeof customElements === "undefined") {
    return;
  }
  const components = ["ux-badge", "ux-icon"];
  components.forEach(tagName => { switch (tagName) {
    case "ux-badge":
      if (!customElements.get(tagName)) {
        customElements.define(tagName, MyComponent);
      }
      break;
    case "ux-icon":
      if (!customElements.get(tagName)) {
        defineCustomElement$2();
      }
      break;
  } });
}

const UxBadge = MyComponent;
const defineCustomElement = defineCustomElement$1;

export { UxBadge, defineCustomElement };
