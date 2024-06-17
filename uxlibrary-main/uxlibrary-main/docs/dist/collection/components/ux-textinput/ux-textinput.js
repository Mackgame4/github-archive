import { h } from '@stencil/core';
export class UxTextinput {
  constructor() {
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
  static get is() { return "ux-textinput"; }
  static get encapsulation() { return "shadow"; }
  static get originalStyleUrls() {
    return {
      "$": ["ux-textinput.css"]
    };
  }
  static get styleUrls() {
    return {
      "$": ["ux-textinput.css"]
    };
  }
  static get properties() {
    return {
      "value": {
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
        "attribute": "value",
        "reflect": false,
        "defaultValue": "''"
      },
      "rounded": {
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
        "attribute": "rounded",
        "reflect": false,
        "defaultValue": "false"
      },
      "prependIcon": {
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
        "attribute": "prepend-icon",
        "reflect": false
      },
      "appendIcon": {
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
        "attribute": "append-icon",
        "reflect": false
      },
      "placeholder": {
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
        "attribute": "placeholder",
        "reflect": false,
        "defaultValue": "''"
      },
      "maxlength": {
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
        "attribute": "maxlength",
        "reflect": false
      }
    };
  }
  static get events() {
    return [{
        "method": "componentInput",
        "name": "componentInput",
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
      }, {
        "method": "componentChange",
        "name": "componentChange",
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
  static get elementRef() { return "element"; }
}
