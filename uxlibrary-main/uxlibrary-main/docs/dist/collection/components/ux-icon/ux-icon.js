import { h } from '@stencil/core';
import { log } from '../../utils/utils';
// import mdi icons from https://materialdesignicons.com/ and use them as web components
import * as mdi from '@mdi/js';
export class UxIcon {
  constructor() {
    this.icon = 'account-box';
    this.size = 'md';
  }
  getIcon() {
    let iconName = this.icon.replace(/'/g, '');
    iconName = iconName.replace(/-([a-z])/g, function (g) { return g[1].toUpperCase(); });
    iconName = iconName.charAt(0).toUpperCase() + iconName.slice(1);
    return mdi[`mdi${iconName}`];
  }
  svgPathToJsx(path) {
    try {
      return path.replace(/d="([^"]+)"/, 'd={$1}');
    }
    catch (e) {
      log("ux-icon", `${this.icon} is not a valid icon name.`);
    }
  }
  render() {
    return (h("div", { class: `icon ${this.size ? `icon--${this.size}` : ''}` }, h("svg", { viewBox: "0 0 24 24" }, h("path", { d: this.svgPathToJsx(this.getIcon()) }))));
  }
  static get is() { return "ux-icon"; }
  static get originalStyleUrls() {
    return {
      "$": ["ux-icon.css"]
    };
  }
  static get styleUrls() {
    return {
      "$": ["ux-icon.css"]
    };
  }
  static get properties() {
    return {
      "icon": {
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
        "attribute": "icon",
        "reflect": false,
        "defaultValue": "'account-box'"
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
      }
    };
  }
}
