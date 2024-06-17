import { h } from '@stencil/core';
//import { format } from '../../utils/utils';
export class MyComponent {
  constructor() {
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
  static get is() { return "ux-badge"; }
  static get encapsulation() { return "shadow"; }
  static get originalStyleUrls() {
    return {
      "$": ["ux-badge.css"]
    };
  }
  static get styleUrls() {
    return {
      "$": ["ux-badge.css"]
    };
  }
  static get properties() {
    return {
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
      "text": {
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
        "attribute": "text",
        "reflect": false
      },
      "size": {
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
        "attribute": "size",
        "reflect": false,
        "defaultValue": "'md'"
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
      "type": {
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
        "attribute": "type",
        "reflect": false
      },
      "color": {
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
        "attribute": "color",
        "reflect": false
      }
    };
  }
}
