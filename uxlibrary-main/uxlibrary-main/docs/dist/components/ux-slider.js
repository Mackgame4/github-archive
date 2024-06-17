import { proxyCustomElement, HTMLElement, createEvent, h } from '@stencil/core/internal/client';

const uxSliderCss = ":host{display:block}.slider-container{display:flex;position:relative;margin:0}.slider{display:flex;position:relative;margin:0}.slider input[type=\"range\"]{-webkit-appearance:none !important;appearance:none !important;width:100%;background:transparent;border:none;outline:none}.slider input[type=\"range\"]::-webkit-slider-runnable-track{-webkit-appearance:none !important;appearance:none !important;width:100%;height:3px;background:red;border-radius:7px !important}.slider input[type=\"range\"]::-moz-range-track{-webkit-appearance:none !important;appearance:none !important;width:100%;height:3px;background:red;border-radius:7px !important}.slider input[type=\"range\"]::-webkit-slider-thumb{-webkit-appearance:none !important;appearance:none !important;width:17px;height:17px;background:black;border:2px solid black;border-radius:50%;cursor:pointer;transform:translateY(-7px)}.slider input[type=\"range\"]::-moz-range-thumb{-webkit-appearance:none !important;appearance:none !important;width:30px;height:30px;background:black;border:2px solid black;border-radius:50%;cursor:pointer}.slider .spanMin{margin-right:10px}.slider .spanMax{margin-left:10px}";

const UxSlider$1 = /*@__PURE__*/ proxyCustomElement(class extends HTMLElement {
  constructor() {
    super();
    this.__registerHost();
    this.__attachShadow();
    this.componentChange = createEvent(this, "componentChange", 7);
    this.componentInput = createEvent(this, "componentInput", 7);
    this.min = 0;
    this.max = 100;
    this.value = 0;
  }
  changeSliderValue(e) {
    this.value = e.target.value;
    this.componentChange.emit(this.value);
    this.componentInput.emit(this.value);
  }
  render() {
    return (h("div", { class: "slider-container" }, h("div", { class: "slider" }, h("span", { class: "spanMin" }, this.min), h("input", { type: "range", min: this.min, max: this.max, value: this.value, onInput: (e) => this.changeSliderValue(e) }), h("span", { class: "spanMax" }, this.max))));
  }
  get el() { return this; }
  static get style() { return uxSliderCss; }
}, [1, "ux-slider", {
    "min": [2],
    "max": [2],
    "value": [2]
  }]);
function defineCustomElement$1() {
  if (typeof customElements === "undefined") {
    return;
  }
  const components = ["ux-slider"];
  components.forEach(tagName => { switch (tagName) {
    case "ux-slider":
      if (!customElements.get(tagName)) {
        customElements.define(tagName, UxSlider$1);
      }
      break;
  } });
}

const UxSlider = UxSlider$1;
const defineCustomElement = defineCustomElement$1;

export { UxSlider, defineCustomElement };
