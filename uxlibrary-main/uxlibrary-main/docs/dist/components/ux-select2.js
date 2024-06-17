import { proxyCustomElement, HTMLElement, createEvent, h } from '@stencil/core/internal/client';
import { d as defineCustomElement$1 } from './ux-icon2.js';

const uxSelectCss = ":host{display:block}select{border:none}select:focus{outline:none}.select{position:relative;display:inline-block;width:calc(100% - 20px);height:100%;padding:0 20px 0 0;border:1px solid var(--containerSecondary);border-radius:7px;background-color:var(--containerSecondary);color:var(--textPrimary);font-size:16px;font-weight:400;line-height:1.5;cursor:pointer;user-select:none;transition:border 0.2s ease-in-out, box-shadow 0.2s ease-in-out}.select:hover{border:1px solid var(--containerSecondary);box-shadow:0px 0px 7px var(--containerSecondary)}.select:active{border:1px solid var(--containerSecondary);box-shadow:0px 0px 7px var(--containerSecondary)}.select .appendIcon{position:absolute;top:50%;right:7px;transform:translateY(-50%)}.select .prependIcon{position:absolute;top:50%;left:1px;transform:translateY(-50%)}.option{padding:5px 10px;cursor:pointer}.options .option:hover{background-color:var(--containerTertiary)}.options{position:absolute;top:100%;left:0;z-index:1;width:100%;max-height:200px;padding:5px 0;border:1px solid var(--containerSecondary);border-radius:7px;background-color:var(--containerSecondary);color:var(--textPrimary);font-size:16px;font-weight:400;line-height:1.5;overflow-y:auto;transition:border 0.2s ease-in-out, box-shadow 0.2s ease-in-out}";

const UxSelect = /*@__PURE__*/ proxyCustomElement(class extends HTMLElement {
  constructor() {
    super();
    this.__registerHost();
    this.__attachShadow();
    this.componentChange = createEvent(this, "componentChange", 7);
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
  get element() { return this; }
  static get style() { return uxSelectCss; }
}, [1, "ux-select", {
    "appendIconOn": [1, "append-icon-on"],
    "appendIconOff": [1, "append-icon-off"],
    "rotateAppendIcon": [4, "rotate-append-icon"],
    "prependIconOn": [1, "prepend-icon-on"],
    "prependIconOff": [1, "prepend-icon-off"],
    "rotatePrependIcon": [4, "rotate-prepend-icon"],
    "defaultSelected": [1026, "default-selected"],
    "showSelectedOption": [1028, "show-selected-option"],
    "showMenu": [32]
  }]);
function defineCustomElement() {
  if (typeof customElements === "undefined") {
    return;
  }
  const components = ["ux-select", "ux-icon"];
  components.forEach(tagName => { switch (tagName) {
    case "ux-select":
      if (!customElements.get(tagName)) {
        customElements.define(tagName, UxSelect);
      }
      break;
    case "ux-icon":
      if (!customElements.get(tagName)) {
        defineCustomElement$1();
      }
      break;
  } });
}

export { UxSelect as U, defineCustomElement as d };
