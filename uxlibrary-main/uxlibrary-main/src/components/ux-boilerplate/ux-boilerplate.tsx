import { Component, Host, h } from '@stencil/core';

@Component({
  tag: 'ux-boilerplate',
  styleUrl: 'ux-boilerplate.scss',
  shadow: true,
})
export class UxBoilerplate {

  render() {
    return (
      <Host>
        <slot></slot>
      </Host>
    );
  }
}