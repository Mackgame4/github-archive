import { Component, Host, h } from '@stencil/core';

@Component({
  tag: 'fluid-card',
  styleUrl: 'fluid-card.css',
  shadow: true,
})
export class FluidCard {

  render() {
    return (
      <Host>
        <slot></slot>
      </Host>
    );
  }
}