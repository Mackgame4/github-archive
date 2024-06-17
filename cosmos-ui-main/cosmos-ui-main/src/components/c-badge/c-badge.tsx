import { Component, Prop, h } from '@stencil/core';
import { cn } from '../../utils/utils';

@Component({
  tag: 'c-badge',
  styleUrl: 'c-badge.css',
  shadow: true,
})
export class CBadge {
  @Prop() variant: string = 'default';
  @Prop() type: string = 'default';
  @Prop() size: string = 'sm';

  get badgeVariants() {
    return cn(
      "inline-flex items-center rounded-md border font-semibold transition-colors focus:outline-none focus:ring-2 focus:ring-ring focus:ring-offset-2",
      {
        variant: {
          default: "border-transparent bg-primary text-primary-foreground shadow hover:bg-primary/80",
          secondary: "border-transparent bg-secondary text-secondary-foreground hover:bg-secondary/80",
          destructive: "border-transparent bg-destructive text-destructive-foreground shadow hover:bg-destructive/80",
          outline: "text-foreground",
        },
        type: {
          default: "rounded-md",
          pill: "rounded-full",
        },
        size: {
          sm: "px-2.5 py-0.5 text-xs",
          md: "px-2.5 py-0.5 text-sm",
          lg: "px-3 py-0.5 text-sm",
        },
    },
    {
      variant: this.variant,
      type: this.type,
      size: this.size,
    }
    )
  }

  render() {
    return (
      <span class={this.badgeVariants}>
        <slot></slot>
      </span>
    );
  }

}
