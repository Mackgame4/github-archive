import { proxyCustomElement, HTMLElement, createEvent, h } from '@stencil/core/internal/client';
import { d as defineCustomElement$1 } from './ux-icon2.js';

const uxTextinputCss = ":host{display:block}input{border:none;background-color:transparent;font-size:1.1em;color:var(--textPrimary)}input:focus{outline:none}.textinput{position:relative;display:flex;align-items:center}.textinput{background-color:var(--containerSecondary);padding:0.5em;border-radius:7px;border:1px solid var(--containerSecondary);transition:border 0.2s ease-in-out, box-shadow 0.2s ease-in-out}.textinput:hover{border:1px solid var(--containerSecondary);box-shadow:0px 0px 7px var(--containerSecondary)}.textinput:focus{border:1px solid var(--containerSecondary);box-shadow:0px 0px 7px var(--containerSecondary)}.textinput--rounded{border-radius:50px}.textinput--disabled{background-color:var(--containerTertiary);color:var(--textSecondary);cursor:not-allowed}.prependIcon{margin-right:0.3em;transform:translateY(-0.07em)}.appendIcon{margin-left:0.3em;transform:translateY(-0.07em)}";

const UxTextinput = /*@__PURE__*/ proxyCustomElement(class extends HTMLElement {
  constructor() {
    super();
    this.__registerHost();
    this.__attachShadow();
    this.componentInput = createEvent(this, "componentInput", 7);
    this.componentChange = createEvent(this, "componentChange", 7);
    this.value = '';
    this.rounded = false;
    this.prependIcon = undefined;
    this.appendIcon = undefined;
    this.placeholder = '';
    this.maxlength = undefined;
  }
  gatherInnerText() {
    if (this.element.textContent) {
      return this.element.textContent;
    }
    else if (this.value) {
      return this.value;
    }
    else {
      return '';
    }
  }
  textInputChanged(event) {
    this.componentInput.emit(event.target.value);
  }
  inputChanged(event) {
    this.componentChange.emit(event.target.value);
  }
  render() {
    return (h("div", { class: `textinput ${this.rounded ? 'textinput--rounded' : ''}` }, this.prependIcon ?
      h("div", { class: "prependIcon" }, h("slot", { name: "prependIcon" }, h("ux-icon", { icon: this.prependIcon })))
      : null, h("input", { id: "textInput", maxlength: this.maxlength, class: "input", type: "text", value: this.gatherInnerText(), placeholder: this.placeholder, onInput: (event) => this.textInputChanged(event), onChange: (event) => this.inputChanged(event) }), this.appendIcon ?
      h("div", { class: "appendIcon" }, h("slot", { name: "appendIcon" }, h("ux-icon", { icon: this.appendIcon })))
      : null));
  }
  get element() { return this; }
  static get style() { return uxTextinputCss; }
}, [1, "ux-textinput", {
    "value": [1],
    "rounded": [4],
    "prependIcon": [1, "prepend-icon"],
    "appendIcon": [1, "append-icon"],
    "placeholder": [1],
    "maxlength": [2]
  }]);
function defineCustomElement() {
  if (typeof customElements === "undefined") {
    return;
  }
  const components = ["ux-textinput", "ux-icon"];
  components.forEach(tagName => { switch (tagName) {
    case "ux-textinput":
      if (!customElements.get(tagName)) {
        customElements.define(tagName, UxTextinput);
      }
      break;
    case "ux-icon":
      if (!customElements.get(tagName)) {
        defineCustomElement$1();
      }
      break;
  } });
}

export { UxTextinput as U, defineCustomElement as d };
