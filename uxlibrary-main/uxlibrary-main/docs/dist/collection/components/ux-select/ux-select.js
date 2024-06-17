import { h } from '@stencil/core';
export class UxSelect {
  constructor() {
    this.showMenu = false;
    this.appendIconOn = 'chevron-up';
    this.appendIconOff = 'chevron-down';
    this.rotateAppendIcon = true;
    this.prependIconOn = undefined;
    this.prependIconOff = undefined;
    this.rotatePrependIcon = false;
    this.defaultSelected = 0;
    this.showSelectedOption = false;
  }
  appendIconState() {
    if (this.showMenu && this.rotateAppendIcon) {
      return this.appendIconOn;
    }
    else {
      return this.appendIconOff;
    }
  }
  prependIconState() {
    if (this.showMenu && this.rotatePrependIcon) {
      return this.prependIconOn || this.prependIconOff;
    }
    else {
      return this.prependIconOff || this.prependIconOn;
    }
  }
  gatherOptions() {
    const options = this.element.querySelectorAll('ux-option');
    return Array.from(options).map((option) => {
      return (h("div", { class: "option", onClick: () => this.selectedOption(Array.from(options).indexOf(option)) }, option.textContent));
    });
  }
  toggleOptionsMenu() {
    this.showMenu = !this.showMenu;
  }
  selectedOption(index) {
    const options = this.element.querySelectorAll('ux-option');
    this.defaultSelected = index;
    // sets "ux-select" atrribute "value" to the value of the selected option
    //this.element.setAttribute('value', options[index].getAttribute('value'));
    // emits an event that returns the selected option
    this.componentChange.emit(options[index]);
  }
  render() {
    return (h("div", { class: "select", onClick: () => this.toggleOptionsMenu() }, h("div", { class: "selected" }, h("div", { class: "prependIcon" }, h("slot", { name: "prependIcon" }, this.prependIconOn || this.prependIconOff ?
      h("ux-icon", { icon: this.prependIconState() })
      : null)), h("slot", { name: "selected" }, this.gatherOptions()[this.defaultSelected]), h("div", { class: "appendIcon" }, h("slot", { name: "appendIcon" }, h("ux-icon", { icon: this.appendIconState() })))), this.showMenu ?
      h("div", { class: "options" }, h("slot", { name: "options" }, this.showSelectedOption ? this.gatherOptions() : this.gatherOptions().filter((_option, index) => index !== this.defaultSelected)))
      : null));
  }
  static get is() { return "ux-select"; }
  static get encapsulation() { return "shadow"; }
  static get originalStyleUrls() {
    return {
      "$": ["ux-select.css"]
    };
  }
  static get styleUrls() {
    return {
      "$": ["ux-select.css"]
    };
  }
  static get properties() {
    return {
      "appendIconOn": {
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
        "attribute": "append-icon-on",
        "reflect": false,
        "defaultValue": "'chevron-up'"
      },
      "appendIconOff": {
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
        "attribute": "append-icon-off",
        "reflect": false,
        "defaultValue": "'chevron-down'"
      },
      "rotateAppendIcon": {
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
        "attribute": "rotate-append-icon",
        "reflect": false,
        "defaultValue": "true"
      },
      "prependIconOn": {
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
        "attribute": "prepend-icon-on",
        "reflect": false
      },
      "prependIconOff": {
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
        "attribute": "prepend-icon-off",
        "reflect": false
      },
      "rotatePrependIcon": {
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
        "attribute": "rotate-prepend-icon",
        "reflect": false,
        "defaultValue": "false"
      },
      "defaultSelected": {
        "type": "number",
        "mutable": true,
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
        "attribute": "default-selected",
        "reflect": false,
        "defaultValue": "0"
      },
      "showSelectedOption": {
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
        "attribute": "show-selected-option",
        "reflect": false,
        "defaultValue": "false"
      }
    };
  }
  static get states() {
    return {
      "showMenu": {}
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
      }];
  }
  static get elementRef() { return "element"; }
}
