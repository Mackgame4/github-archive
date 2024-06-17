import { Component, Prop, h } from '@stencil/core';
import { cn, getTheme } from '../../utils/utils';

const themes = {
  "shadcn": {
    className: "inline-flex items-center justify-center rounded-md text-sm font-medium transition-colors focus-visible:outline-none focus-visible:ring-1 focus-visible:ring-ring disabled:pointer-events-none disabled:opacity-50",
    content: {
      variant: {
        default: "bg-primary text-primary-foreground shadow hover:bg-primary/90",
        destructive: "bg-destructive text-destructive-foreground shadow-sm hover:bg-destructive/90",
        outline: "border border-input bg-background shadow-sm hover:bg-accent hover:text-accent-foreground",
        secondary: "bg-secondary text-secondary-foreground shadow-sm hover:bg-secondary/80",
        ghost: "hover:bg-accent hover:text-accent-foreground",
        link: "text-primary underline-offset-4 hover:underline",
      },
      size: {
        sm: "h-8 rounded-md px-3 text-xs",
        md: "h-9 px-4 py-2",
        lg: "h-10 rounded-md px-8",
        icon: "h-9 w-9",
      },
    }
  },
  "enterprise": {
    className: "inline-flex items-center justify-center rounded-none text-sm font-medium transition-colors focus-visible:outline-none focus-visible:ring-1 focus-visible:ring-ring disabled:pointer-events-none disabled:opacity-50",
    content: {
      variant: {
        default: "bg-primary text-primary-foreground shadow hover:bg-primary/90",
        destructive: "bg-destructive text-destructive-foreground shadow-sm hover:bg-destructive/90",
        outline: "border border-input bg-background shadow-sm hover:bg-accent hover:text-accent-foreground",
        secondary: "bg-secondary text-secondary-foreground shadow-sm hover:bg-secondary/80",
        ghost: "hover:bg-accent hover:text-accent-foreground",
        link: "text-primary underline-offset-4 hover:underline",
      },
      size: {
        sm: "h-8 px-4",
        md: "h-10 px-6",
        lg: "h-12 px-8",
        icon: "h-10 w-10",
      },
    }
  },
  // WIP - not ready yet
  "tailwind": {
    className: "inline-flex items-center justify-center rounded-lg text-sm font-medium transition-colors tracking-wide focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-primary",
    content: {
      variant: {
        default: "bg-primary text-primary-foreground shadow-md hover:shadow-lg",
      },
      size: {
        sm: "h-8 px-4",
        md: "h-10 px-6",
        lg: "h-12 px-8",
        icon: "h-10 w-10",
      },
    }
  },
  "bootsrap": {
    className: "inline-flex items-center justify-center rounded-lg text-sm font-medium transition-colors focus:ring-4 focus:ring-primary/50 focus:outline-none",
    content: {
      variant: {
        default: "bg-primary text-primary-foreground shadow-md hover:shadow-lg",
      },
      size: {
        sm: "h-8 px-4",
        md: "h-10 px-6",
        lg: "h-12 px-8",
        icon: "h-10 w-10",
      }
    }
  },
}

@Component({
  tag: 'c-button',
  styleUrl: 'c-button.css',
  shadow: true,
})
export class CButton {
  @Prop() variant: string = 'default';
  @Prop() size: string = 'md';
  @Prop() disabled: boolean = false;
  @Prop() prependIcon: string = '';
  @Prop() appendIcon: string = '';
  @Prop() classIcon: string = 'h-4 w-4';

  get buttonVariants() {
    return cn(
      themes[getTheme()].className,
      themes[getTheme()].content,
      {
        variant: this.variant,
        size: this.size,
      }
    )
  }

  render() {
    return <button class={this.buttonVariants} disabled={this.disabled}>
      {this.prependIcon && <c-icon name={this.prependIcon} class={`${this.classIcon} mr-2`} />}
      <slot></slot>
      {this.appendIcon && <c-icon name={this.appendIcon} class={`${this.classIcon} ml-2`} />}
  </button>;
  }
}
