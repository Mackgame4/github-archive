import { Component, Prop, h } from '@stencil/core';
// eslint-disable-next-line @typescript-eslint/ban-ts-comment
// @ts-ignore
import feather from 'feather-icons'; // https://feathericons.com

@Component({
  tag: 'c-icon',
  styleUrl: 'c-icon.css',
  shadow: true,
})
export class CIcon {
  @Prop() name: string = 'circle';
  @Prop() size: string = '24px';
  @Prop() strokeWidth: string = '2px';
  @Prop() color: string = 'currentColor';
  @Prop({
    reflect: true,
  }) class: string = 'h-4 w-4';

  render() {
    return (
      <div class={this.class}>
      <i innerHTML={feather.icons[this.name].toSvg({
        class: 'w-full h-full',
        width: this.size,
        height: this.size,
        'stroke-width': this.strokeWidth,
        color: this.color,
      })}></i>
      </div>
    );
  }
}