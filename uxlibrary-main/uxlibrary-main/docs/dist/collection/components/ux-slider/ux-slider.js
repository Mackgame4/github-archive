import { h } from '@stencil/core';
export class UxSlider {
  constructor() {
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
  static get is() { return "ux-slider"; }
  static get encapsulation() { return "shadow"; }
  static get originalStyleUrls() {
    return {
      "$": ["ux-slider.css"]
    };
  }
  static get styleUrls() {
    return {
      "$": ["ux-slider.css"]
    };
  }
  static get properties() {
    return {
      "min": {
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
        "attribute": "min",
        "reflect": false,
        "defaultValue": "0"
      },
      "max": {
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
        "attribute": "max",
        "reflect": false,
        "defaultValue": "100"
      },
      "value": {
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
        "attribute": "value",
        "reflect": false,
        "defaultValue": "0"
      }
    };
  }
  static get events() {
    return [{
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
      }, {
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
      }];
  }
  static get elementRef() { return "el"; }
}
