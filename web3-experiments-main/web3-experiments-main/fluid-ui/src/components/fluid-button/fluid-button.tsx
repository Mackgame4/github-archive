import { Component, h } from '@stencil/core';

@Component({
  tag: 'fluid-button',
  styleUrl: 'fluid-button.scss',
  shadow: true,
})
export class FluidButton {
  render() {
    return (
      <button class="button">
        <svg class="icon" viewBox="0 0 24 24">
          <path fill="currentColor" d="M12,2A10,10 0 0,0 2,12A10,10 0 0,0 12,22A10,10 0 0,0 22,12A10,10 0 0,0 12,2M12,4A8,8 0 0,1 20,12A8,8 0 0,1 12,20A8,8 0 0,1 4,12A8,8 0 0,1 12,4M11,6H13V11H18V13H13V18H11V13H6V11H11V6Z"/>
        </svg>
        <span>Sign in with Apple</span>
      </button>
    );
  }
}