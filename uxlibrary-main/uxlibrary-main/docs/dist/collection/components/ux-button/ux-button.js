import { h } from '@stencil/core';
export class UxButton {
  constructor() {
    this.rounded = false;
    this.text = undefined;
    this.size = 'md';
    this.prependIcon = undefined;
    this.appendIcon = undefined;
    this.type = 'secondary';
    this.color = undefined;
    this.block = false;
    this.disabled = false;
    this.loading = false;
    this.ring = false;
    this.shadow = true;
    this.elevation = 0;
  }
  styleState() {
    if (!this.color)
      return {
        ['--ringColor']: `var(--${this.type})`
      };
    return {
      backgroundColor: this.color,
      ['--ringColor']: this.color
    };
  }
  render() {
    return (h("button", { style: this.styleState(), class: `button ${this.type ? `button--${this.type}` : ''} ${this.elevation > 0 && this.elevation <= 6 ? `elevation-${this.elevation}` : ''} ${this.shadow ? `button--shadow` : ''} ${this.ring ? `button--ring` : ''} ${this.block ? `button--block` : ''} ${this.size ? `button--${this.size}` : ''} ${this.rounded ? 'button--rounded' : ''}` }, this.prependIcon ?
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
  static get is() { return "ux-button"; }
  static get originalStyleUrls() {
    return {
      "$": ["ux-button.css"]
    };
  }
  static get styleUrls() {
    return {
      "$": ["ux-button.css"]
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
        "reflect": false,
        "defaultValue": "'secondary'"
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
      },
      "block": {
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
        "attribute": "block",
        "reflect": false,
        "defaultValue": "false"
      },
      "disabled": {
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
        "attribute": "disabled",
        "reflect": false,
        "defaultValue": "false"
      },
      "loading": {
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
        "attribute": "loading",
        "reflect": false,
        "defaultValue": "false"
      },
      "ring": {
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
        "attribute": "ring",
        "reflect": false,
        "defaultValue": "false"
      },
      "shadow": {
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
        "attribute": "shadow",
        "reflect": false,
        "defaultValue": "true"
      },
      "elevation": {
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
        "attribute": "elevation",
        "reflect": false,
        "defaultValue": "0"
      }
    };
  }
}
