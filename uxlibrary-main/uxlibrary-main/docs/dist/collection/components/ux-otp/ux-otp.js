import { h } from '@stencil/core';
import { log } from '../../utils/utils';
export class UxOtp {
  constructor() {
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
        log("Event emit:", "componentFilled", this.value);
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
      log("Event emit:", "componentFilled", this.value);
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
  static get is() { return "ux-otp"; }
  static get encapsulation() { return "shadow"; }
  static get originalStyleUrls() {
    return {
      "$": ["ux-otp.css"]
    };
  }
  static get styleUrls() {
    return {
      "$": ["ux-otp.css"]
    };
  }
  static get properties() {
    return {
      "length": {
        "type": "number",
        "mutable": false,
        "complexType": {
          "original": "number",
          "resolved": "number",
          "references": {}
        },
        "required": false,
        "optional": false,
        "docs": {
          "tags": [],
          "text": ""
        },
        "attribute": "length",
        "reflect": false,
        "defaultValue": "4"
      },
      "useSeparators": {
        "type": "boolean",
        "mutable": false,
        "complexType": {
          "original": "boolean",
          "resolved": "boolean",
          "references": {}
        },
        "required": false,
        "optional": false,
        "docs": {
          "tags": [],
          "text": ""
        },
        "attribute": "use-separators",
        "reflect": false,
        "defaultValue": "true"
      },
      "value": {
        "type": "unknown",
        "mutable": true,
        "complexType": {
          "original": "string[]",
          "resolved": "string[]",
          "references": {}
        },
        "required": false,
        "optional": false,
        "docs": {
          "tags": [],
          "text": ""
        }
      },
      "separator": {
        "type": "string",
        "mutable": false,
        "complexType": {
          "original": "string",
          "resolved": "string",
          "references": {}
        },
        "required": false,
        "optional": false,
        "docs": {
          "tags": [],
          "text": ""
        },
        "attribute": "separator",
        "reflect": false
      },
      "cellLength": {
        "type": "number",
        "mutable": false,
        "complexType": {
          "original": "number",
          "resolved": "number",
          "references": {}
        },
        "required": false,
        "optional": false,
        "docs": {
          "tags": [],
          "text": ""
        },
        "attribute": "cell-length",
        "reflect": false,
        "defaultValue": "1"
      },
      "uppercaseCells": {
        "type": "boolean",
        "mutable": false,
        "complexType": {
          "original": "boolean",
          "resolved": "boolean",
          "references": {}
        },
        "required": false,
        "optional": false,
        "docs": {
          "tags": [],
          "text": ""
        },
        "attribute": "uppercase-cells",
        "reflect": false,
        "defaultValue": "true"
      }
    };
  }
  static get events() {
    return [{
        "method": "componentFilled",
        "name": "componentFilled",
        "bubbles": true,
        "cancelable": true,
        "composed": true,
        "docs": {
          "tags": [],
          "text": ""
        },
        "complexType": {
          "original": "any",
          "resolved": "any",
          "references": {}
        }
      }];
  }
  static get elementRef() { return "el"; }
}
