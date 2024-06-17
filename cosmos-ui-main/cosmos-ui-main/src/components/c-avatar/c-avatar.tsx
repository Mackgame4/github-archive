import { Component, Prop, h } from '@stencil/core';
import { cn } from '../../utils/utils';

@Component({
  tag: 'c-avatar',
  styleUrl: 'c-avatar.css',
  shadow: true,
})
export class CAvatar {
  @Prop() src: string = '';
  @Prop() alt: string = '';
  @Prop() size: string = 'md';
  @Prop() variant: string = 'circle';
  @Prop() text: string = '';

  get avatarVariants() {
    return cn(
      "relative flex h-10 w-10 shrink-0 overflow-hidden",
      {
        variant: {
          circle: "rounded-full",
          square: "rounded-md",
        },
        size: {
          sm: "h-8 w-8",
          md: "h-10 w-10",
          lg: "h-12 w-12"
        },
      },
      {
        variant: this.variant,
        size: this.size,
      }
    );
  }

  render() {
    return (
      <div class={this.avatarVariants}>
        {this.src && <img class="aspect-square h-full w-full" src={this.src} alt={this.alt} />}
        <span class="flex h-full w-full items-center justify-center bg-muted">{this.text}<slot></slot></span>
      </div>
    );
  }

}
