import { h } from '@stencil/core';
import { redirectToGithub, buildVersion } from '../../utils/utils';
export class MyComponent {
  constructor() {
    this.darkTheme = false;
    this.debugMode = undefined;
    this.customTheme = {
      name: 'default',
      colors: {}
    };
  }
  // a function that changes the theme
  changeTheme(theme) {
    if (theme === 'dark') {
      this.darkTheme = true;
    }
    else if (theme === 'light') {
      this.darkTheme = false;
    }
    else {
      this.darkTheme = !this.darkTheme;
    }
    return this.darkTheme;
  }
  render() {
    return (h("div", { style: this.customTheme.name != 'default' ? this.customTheme.colors : '', class: `provider ${this.darkTheme ? 'provider--darkTheme' : 'provider--lightTheme'}` }, this.debugMode ? (h("div", { id: "debugModeContainer" }, h("div", { class: "debugBox" }, h("span", null, "UXLibrary v", buildVersion), h("ux-button", { onClick: () => this.changeTheme() }, "Change theme")), h("div", { class: "mediaBox" }, h("ux-button", { prependIcon: "github", onClick: () => redirectToGithub() }, "Github")))) : null, h("slot", null)));
  }
  static get is() { return "ux-provider"; }
  static get originalStyleUrls() {
    return {
      "$": ["ux-provider.css"]
    };
  }
  static get styleUrls() {
    return {
      "$": ["ux-provider.css"]
    };
  }
  static get properties() {
    return {
      "darkTheme": {
        "type": "boolean",
        "mutable": true,
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
        "attribute": "dark-theme",
        "reflect": false,
        "defaultValue": "false"
      },
      "debugMode": {
        "type": "boolean",
        "mutable": true,
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
        "attribute": "debug-mode",
        "reflect": false
      },
      "customTheme": {
        "type": "any",
        "mutable": false,
        "complexType": {
          "original": "any",
          "resolved": "any",
          "references": {}
        },
        "required": false,
        "optional": false,
        "docs": {
          "tags": [],
          "text": ""
        },
        "attribute": "custom-theme",
        "reflect": false,
        "defaultValue": "{\r\n    name: 'default',\r\n    colors: {\r\n    }\r\n  }"
      }
    };
  }
}
