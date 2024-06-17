import { Component, Prop, h } from '@stencil/core';
import { cn } from '../../utils/utils';

@Component({
  tag: 'c-label',
  styleUrl: 'c-label.css',
  shadow: true,
})
export class CLabel {
  @Prop() htmlFor: string = 'input';

  get labelVariants() {
    return cn(
      "text-sm font-medium leading-none peer-disabled:cursor-not-allowed peer-disabled:opacity-70"
    );
  }

  render() {
    return (
      <label class={this.labelVariants} htmlFor={this.htmlFor}>
        <slot></slot>
      </label>
    );
  }

}
