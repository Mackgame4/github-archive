import { h } from '@stencil/core';
import { log, getDataComponents } from '../../utils/utils';
export class UxPlayground {
  constructor() {
    this.changeSelectedComponent = (e) => {
      this.selectedComponent = this.components().filter((component) => {
        return component.tag === e.detail.textContent;
      })[0];
    };
    this.dataComponents = getDataComponents();
    this.darkTheme = false;
    this.selectedComponent = undefined;
    this.refreshing = false;
  }
  components() {
    let componentList = [];
    this.dataComponents.components.forEach((component) => {
      componentList.push(component);
    });
    componentList = componentList.filter((component) => {
      return component.tag !== 'ux-provider' && component.tag !== 'ux-playground';
    });
    return componentList;
  }
  changeTheme() {
    this.darkTheme = !this.darkTheme;
    return this.darkTheme;
  }
  removeChar(str) {
    if (str === undefined)
      return;
    str = str.replace(/'/g, '');
    return str;
  }
  // changes the prop of the element selectedComponent
  changePropValue(propName, e) {
    log(propName, e.detail);
    this.selectedComponent.props.forEach((prop) => {
      if (prop.name === propName) {
        prop.default = e.detail;
      }
    });
    this.refreshing = true;
    setTimeout(() => {
      this.refreshing = false;
    }, 100);
  }
  render() {
    return (h("div", { class: "playground" }, h("div", { class: "elementContainer" }, h("ux-provider", { darkTheme: this.darkTheme }, h("div", { class: "centerElement" }, this.selectedComponent != undefined && !this.refreshing ?
      h(this.selectedComponent.tag, Object.assign({}, this.selectedComponent.props.reduce((acc, prop) => {
        acc[prop.name] = prop.default;
        return acc;
      }, {})))
      : null))), h("div", { class: "elementProps" }, h("ux-provider", { darkTheme: this.darkTheme }, h("div", { class: "elementsProps" }, h("ux-button", { style: { margin: "5px" }, block: true, type: "primary", size: "md", "prepend-icon": "theme-light-dark", onClick: () => this.changeTheme() }, "Change theme"), h("ux-select", { id: "componentSelect", onComponentChange: (e) => this.changeSelectedComponent(e) }, h("ux-option", { value: "" }, "Select a component"), this.components().map((component) => (h("ux-option", { value: component.tag }, component.tag)))), this.selectedComponent != undefined ?
      h("ul", null, this.selectedComponent.props.map((prop) => (h("div", { id: "propControl" }, h("li", null, prop.name), h("ux-textinput", { placeholder: prop.name, value: this.removeChar(prop.default), onComponentChange: (e) => this.changePropValue(prop.name, e) })))))
      : null)))));
  }
  static get is() { return "ux-playground"; }
  static get encapsulation() { return "shadow"; }
  static get originalStyleUrls() {
    return {
      "$": ["ux-playground.css"]
    };
  }
  static get styleUrls() {
    return {
      "$": ["ux-playground.css"]
    };
  }
  static get states() {
    return {
      "darkTheme": {},
      "selectedComponent": {},
      "refreshing": {}
    };
  }
}
