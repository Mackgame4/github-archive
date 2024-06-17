import { proxyCustomElement, HTMLElement, h } from '@stencil/core/internal/client';

const uxCardCss = ":host{display:block}.card{background-color:var(--containerTertiary);border-radius:4px;box-shadow:0 2px 4px 0 rgba(0, 0, 0, 0.2), 0 25px 50px 0 rgba(0, 0, 0, 0.1);display:block;padding:20px}.header{display:flex;justify-content:space-between;margin-bottom:20px;font-size:larger}.header>*{margin:0}.header--right{justify-content:flex-end}.header--center{justify-content:center}.header--left{justify-content:flex-start}.body{display:flex;flex-direction:column}.body--center{align-items:center}.body--left{align-items:flex-start}.body--right{align-items:flex-end}.footer{display:flex;margin-top:20px;font-size:smaller}.footer>*{margin:0}.footer--right{justify-content:flex-end}.footer--center{justify-content:center}.footer--left{justify-content:flex-start}";

const UxCard$1 = /*@__PURE__*/ proxyCustomElement(class extends HTMLElement {
  constructor() {
    super();
    this.__registerHost();
    this.__attachShadow();
  }
  gatherStructure() {
    const headers = this.element.querySelectorAll('ux-card-header');
    const bodys = this.element.querySelectorAll('ux-card-body');
    const footers = this.element.querySelectorAll('ux-card-footer');
    let headerDivs = Array.from(headers).map((header) => {
      let headerAlign = header.getAttribute('align');
      if (headerAlign) {
        return (h("div", { class: `header header--${headerAlign}` }, header.textContent));
      }
      return (h("div", { class: "header" }, header.textContent));
    });
    let bodyDivs = Array.from(bodys).map((body) => {
      let bodyAlign = body.getAttribute('align');
      if (bodyAlign) {
        return (h("div", { class: `body body--${bodyAlign}` }, body.textContent));
      }
      return (h("div", { class: "body" }, body.textContent));
    });
    let footerDivs = Array.from(footers).map((footer) => {
      let footerAlign = footer.getAttribute('align');
      if (footerAlign) {
        return (h("div", { class: `footer footer--${footerAlign}` }, footer.textContent));
      }
      return (h("div", { class: "footer" }, footer.textContent));
    });
    return { headerDivs, bodyDivs, footerDivs };
  }
  render() {
    return (h("div", { class: "card" }, h("slot", { name: "header" }, this.gatherStructure().headerDivs), h("slot", { name: "body" }, this.gatherStructure().bodyDivs), h("slot", { name: "footer" }, this.gatherStructure().footerDivs)));
  }
  get element() { return this; }
  static get style() { return uxCardCss; }
}, [1, "ux-card"]);
function defineCustomElement$1() {
  if (typeof customElements === "undefined") {
    return;
  }
  const components = ["ux-card"];
  components.forEach(tagName => { switch (tagName) {
    case "ux-card":
      if (!customElements.get(tagName)) {
        customElements.define(tagName, UxCard$1);
      }
      break;
  } });
}

const UxCard = UxCard$1;
const defineCustomElement = defineCustomElement$1;

export { UxCard, defineCustomElement };
