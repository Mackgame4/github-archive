import { h } from '@stencil/core';
export class UxCard {
  gatherStructure() {
    const headers = this.element.querySelectorAll('ux-card-header');
    const bodys = this.element.querySelectorAll('ux-card-body');
    const footers = this.element.querySelectorAll('ux-card-footer');
    let headerDivs = Array.from(headers).map((header) => {
      let headerAlign = header.getAttribute('align');
      if (headerAlign) {
        return (h("div", { class: `header header--${headerAlign}` }, header.textContent));
      }
      return (h("div", { class: "header" }, header.textContent));
    });
    let bodyDivs = Array.from(bodys).map((body) => {
      let bodyAlign = body.getAttribute('align');
      if (bodyAlign) {
        return (h("div", { class: `body body--${bodyAlign}` }, body.textContent));
      }
      return (h("div", { class: "body" }, body.textContent));
    });
    let footerDivs = Array.from(footers).map((footer) => {
      let footerAlign = footer.getAttribute('align');
      if (footerAlign) {
        return (h("div", { class: `footer footer--${footerAlign}` }, footer.textContent));
      }
      return (h("div", { class: "footer" }, footer.textContent));
    });
    return { headerDivs, bodyDivs, footerDivs };
  }
  render() {
    return (h("div", { class: "card" }, h("slot", { name: "header" }, this.gatherStructure().headerDivs), h("slot", { name: "body" }, this.gatherStructure().bodyDivs), h("slot", { name: "footer" }, this.gatherStructure().footerDivs)));
  }
  static get is() { return "ux-card"; }
  static get encapsulation() { return "shadow"; }
  static get originalStyleUrls() {
    return {
      "$": ["ux-card.css"]
    };
  }
  static get styleUrls() {
    return {
      "$": ["ux-card.css"]
    };
  }
  static get elementRef() { return "element"; }
}
