import { Component, Host, h, Prop, Element } from '@stencil/core';
import feather from 'feather-icons';

@Component({
  tag: 'ux-icon',
  styleUrl: 'ux-icon.scss',
  shadow: true,
})
export class UxIcon {

  @Element() el: HTMLElement;

  @Prop({
    reflect: true,
    mutable: true
  }) name: string = 'settings';

  @Prop() size: string = 'md';

  @Prop() color: string = 'currentColor';

  @Prop() stroke: string = 'normal';

  private svgToHTML(svg: string) {
    let parser = new DOMParser();
    let doc = parser.parseFromString(svg, 'image/svg+xml');
    return doc.documentElement;
  }

  public componentDidLoad() {
    let iconSize = this.size;
    let className = 'svg--normal';
    if (this.name) {
      let iconSVG = feather.icons[this.name].toSvg();
      let iconHTML = this.svgToHTML(iconSVG);
      className = 'icon--' + this.stroke;
      iconHTML.classList.add(className);
      if (this.size === 'xs') iconSize = '12';
      if (this.size === 'sm') iconSize = '16';
      if (this.size == 'md') iconSize = '24';
      if (this.size === 'lg') iconSize = '32';
      if (this.size === 'xl') iconSize = '48';
      let style = {
        width: iconSize + 'px',
        height: iconSize + 'px',
        color: this.color
      }
      const icon = this.el.shadowRoot.querySelector('.icon').appendChild(iconHTML);
      Object.assign(icon.style, style);
    }
  }

  render() {
    return (
      <Host>
        <div class="icon">
          <slot name="icon"></slot>
        </div>
      </Host>
    );
  }
}