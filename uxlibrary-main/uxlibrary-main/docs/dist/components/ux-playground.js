import { proxyCustomElement, HTMLElement, h } from '@stencil/core/internal/client';
import { g as getDataComponents, d as defineCustomElement$4 } from './ux-provider2.js';
import { d as defineCustomElement$6 } from './ux-button2.js';
import { d as defineCustomElement$5 } from './ux-icon2.js';
import { d as defineCustomElement$3 } from './ux-select2.js';
import { d as defineCustomElement$2 } from './ux-textinput2.js';

const uxPlaygroundCss = ":host{display:block}.playground{display:flex;flex-direction:row;min-width:700px;min-height:280px;border:1px solid var(--containerSecondary);border-radius:7px;box-shadow:0px 0px 7px var(--containerSecondary);transition:border 0.2s ease-in-out, box-shadow 0.2s ease-in-out}.elementContainer{width:100%;max-height:100%;border-top-left-radius:7px;border-bottom-left-radius:7px}.elementContainer .provider{border-top-left-radius:7px;border-bottom-left-radius:7px;background-size:40px 40px;background-image:radial-gradient(circle, var(--containerSecondary) 1px, rgba(0, 0, 0, 0) 1px)}.elementProps{width:40%;max-height:100%;border-top-right-radius:7px;border-bottom-right-radius:7px}.elementProps .provider{border-top-right-radius:7px;border-bottom-right-radius:7px;background-color:var(--containerTertiary) !important}.elementsProps{display:flex;flex-direction:column;padding:7px}.centerElement{display:flex;flex-direction:column;justify-content:center;align-items:center;height:100%}";

const UxPlayground$1 = /*@__PURE__*/ proxyCustomElement(class extends HTMLElement {
  constructor() {
    super();
    this.__registerHost();
    this.__attachShadow();
    this.changeSelectedComponent = (e) => {
      this.selectedComponent = this.components().filter((component) => {
        return component.tag === e.detail.textContent;
      })[0];
    };
    this.dataComponents = getDataComponents();
    this.darkTheme = false;
    this.selectedComponent = undefined;
    this.refreshing = false;
  }
  components() {
    let componentList = [];
    this.dataComponents.components.forEach((component) => {
      componentList.push(component);
    });
    componentList = componentList.filter((component) => {
      return component.tag !== 'ux-provider' && component.tag !== 'ux-playground';
    });
    return componentList;
  }
  changeTheme() {
    this.darkTheme = !this.darkTheme;
    return this.darkTheme;
  }
  removeChar(str) {
    if (str === undefined)
      return;
    str = str.replace(/'/g, '');
    return str;
  }
  // changes the prop of the element selectedComponent
  changePropValue(propName, e) {
    this.selectedComponent.props.forEach((prop) => {
      if (prop.name === propName) {
        prop.default = e.detail;
      }
    });
    this.refreshing = true;
    setTimeout(() => {
      this.refreshing = false;
    }, 100);
  }
  render() {
    return (h("div", { class: "playground" }, h("div", { class: "elementContainer" }, h("ux-provider", { darkTheme: this.darkTheme }, h("div", { class: "centerElement" }, this.selectedComponent != undefined && !this.refreshing ?
      h(this.selectedComponent.tag, Object.assign({}, this.selectedComponent.props.reduce((acc, prop) => {
        acc[prop.name] = prop.default;
        return acc;
      }, {})))
      : null))), h("div", { class: "elementProps" }, h("ux-provider", { darkTheme: this.darkTheme }, h("div", { class: "elementsProps" }, h("ux-button", { style: { margin: "5px" }, block: true, type: "primary", size: "md", "prepend-icon": "theme-light-dark", onClick: () => this.changeTheme() }, "Change theme"), h("ux-select", { id: "componentSelect", onComponentChange: (e) => this.changeSelectedComponent(e) }, h("ux-option", { value: "" }, "Select a component"), this.components().map((component) => (h("ux-option", { value: component.tag }, component.tag)))), this.selectedComponent != undefined ?
      h("ul", null, this.selectedComponent.props.map((prop) => (h("div", { id: "propControl" }, h("li", null, prop.name), h("ux-textinput", { placeholder: prop.name, value: this.removeChar(prop.default), onComponentChange: (e) => this.changePropValue(prop.name, e) })))))
      : null)))));
  }
  static get style() { return uxPlaygroundCss; }
}, [1, "ux-playground", {
    "darkTheme": [32],
    "selectedComponent": [32],
    "refreshing": [32]
  }]);
function defineCustomElement$1() {
  if (typeof customElements === "undefined") {
    return;
  }
  const components = ["ux-playground", "ux-button", "ux-icon", "ux-provider", "ux-select", "ux-textinput"];
  components.forEach(tagName => { switch (tagName) {
    case "ux-playground":
      if (!customElements.get(tagName)) {
        customElements.define(tagName, UxPlayground$1);
      }
      break;
    case "ux-button":
      if (!customElements.get(tagName)) {
        defineCustomElement$6();
      }
      break;
    case "ux-icon":
      if (!customElements.get(tagName)) {
        defineCustomElement$5();
      }
      break;
    case "ux-provider":
      if (!customElements.get(tagName)) {
        defineCustomElement$4();
      }
      break;
    case "ux-select":
      if (!customElements.get(tagName)) {
        defineCustomElement$3();
      }
      break;
    case "ux-textinput":
      if (!customElements.get(tagName)) {
        defineCustomElement$2();
      }
      break;
  } });
}

const UxPlayground = UxPlayground$1;
const defineCustomElement = defineCustomElement$1;

export { UxPlayground, defineCustomElement };
