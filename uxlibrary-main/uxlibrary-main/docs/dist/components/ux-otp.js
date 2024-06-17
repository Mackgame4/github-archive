import { proxyCustomElement, HTMLElement, createEvent, h } from '@stencil/core/internal/client';
import { d as defineCustomElement$3 } from './ux-icon2.js';
import { d as defineCustomElement$2 } from './ux-textinput2.js';

const uxOtpCss = ":host{display:block}.otp-container{display:flex;flex-direction:row;margin:0}.otp-input{display:flex;flex-direction:row;align-items:center;justify-content:center;vertical-align:middle;margin:0}.otp-separator{margin:0 0.3rem}.otp-textinput{width:2rem;height:2rem}";

const UxOtp$1 = /*@__PURE__*/ proxyCustomElement(class extends HTMLElement {
  constructor() {
    super();
    this.__registerHost();
    this.__attachShadow();
    this.componentFilled = createEvent(this, "componentFilled", 7);
    this.length = 4;
    this.useSeparators = true;
    this.value = undefined;
    this.separator = undefined;
    this.cellLength = 1;
    this.uppercaseCells = true;
  }
  componentWillLoad() {
    if (this.value === undefined) {
      this.value = [];
    }
    if (this.separator === undefined) {
      this.separator = '';
    }
  }
  componentDidLoad() {
    document.addEventListener("paste", (e) => {
      if (e.target.tagName !== "UX-OTP") {
        return;
      }
      let paste = (e.clipboardData).getData("text");
      if (paste.length != 0) {
        e.preventDefault();
        const inputs = this.el.shadowRoot.querySelectorAll(".otp-textinput");
        for (let i = 0; i < inputs.length; i++) {
          // if letter is empty or space or separator, remove it from paste
          if (paste[i] === '' || paste[i] === ' ' || paste[i] === this.separator) {
            paste = paste.slice(0, i) + paste.slice(i + 1);
          }
          let letter = paste[i];
          if (i >= paste.length || letter === '' || letter === ' ') {
            break;
          }
          if (this.uppercaseCells) {
            letter = letter.toUpperCase();
          }
          inputs[i].shadowRoot.querySelector("input").value = letter;
          this.value[i] = letter;
        }
      }
      if (this.isFilled()) {
        this.componentFilled.emit(this.value);
      }
    });
    // on backspace, delete letter from previous cell
    /*document.addEventListener("keydown", (e: any) => {
      if (e.key === "Backspace") {
        const inputs = this.el.shadowRoot.querySelectorAll(".otp-textinput");
        for (let i = 0; i < inputs.length; i++) {
          let inputValue = inputs[i].shadowRoot.querySelector("input").value;
          if (inputValue.length != 0) {
              inputs[i].shadowRoot.querySelector("input").focus();
              inputs[i].shadowRoot.querySelector("input").value = '';
              this.value[i - 1] = '';
          }
        }
      }
    });*/
  }
  changeInputCell() {
    const inputs = this.el.shadowRoot.querySelectorAll(".otp-textinput");
    for (let i = 0; i < inputs.length; i++) {
      let inputValue = inputs[i].shadowRoot.querySelector("input").value;
      if (this.uppercaseCells) {
        inputValue = inputValue.toUpperCase();
        inputs[i].shadowRoot.querySelector("input").value = inputValue;
      }
      if (inputValue.length === this.cellLength) {
        if (i !== inputs.length - 1) {
          inputs[i + 1].shadowRoot.querySelector("input").focus();
        }
        else {
          inputs[i].shadowRoot.querySelector("input").blur();
        }
      }
      if (inputValue !== ' ' || inputValue !== this.separator) {
        this.value[i] = inputValue;
      }
    }
    this.value = this.value.slice(0, this.length);
    if (this.uppercaseCells) {
      this.value = this.value.map((cell) => cell.toUpperCase());
    }
    if (this.isFilled()) {
      this.componentFilled.emit(this.value);
    }
  }
  isFilled() {
    let filled = true;
    const inputs = this.el.shadowRoot.querySelectorAll(".otp-textinput");
    for (let i = 0; i < inputs.length; i++) {
      if (inputs[i].shadowRoot.querySelector("input").value.length !== this.cellLength) {
        filled = false;
        break;
      }
    }
    return filled;
  }
  render() {
    return (h("div", { class: "otp-container" }, [...Array(this.length)].map((_, index) => (h("div", { class: `otp-input ${this.uppercaseCells ? 'otp-input--uppercase' : ''}` }, h("ux-textinput", { class: "otp-textinput", maxlength: this.cellLength, value: this.value[index], onComponentInput: () => this.changeInputCell() }), this.useSeparators && index !== this.length - 1 && h("div", { class: "otp-separator" }, this.separator))))));
  }
  get el() { return this; }
  static get style() { return uxOtpCss; }
}, [1, "ux-otp", {
    "length": [2],
    "useSeparators": [4, "use-separators"],
    "value": [1040],
    "separator": [1],
    "cellLength": [2, "cell-length"],
    "uppercaseCells": [4, "uppercase-cells"]
  }]);
function defineCustomElement$1() {
  if (typeof customElements === "undefined") {
    return;
  }
  const components = ["ux-otp", "ux-icon", "ux-textinput"];
  components.forEach(tagName => { switch (tagName) {
    case "ux-otp":
      if (!customElements.get(tagName)) {
        customElements.define(tagName, UxOtp$1);
      }
      break;
    case "ux-icon":
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

const UxOtp = UxOtp$1;
const defineCustomElement = defineCustomElement$1;

export { UxOtp, defineCustomElement };
