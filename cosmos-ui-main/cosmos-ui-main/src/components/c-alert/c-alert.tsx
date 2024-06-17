import { Component, Prop, h } from '@stencil/core';
import { cn } from '../../utils/utils';

@Component({
  tag: 'c-alert',
  styleUrl: 'c-alert.css',
  shadow: true,
})
export class CAlert {
  @Prop() variant: string = 'default';
  @Prop() alertTitle: string = '';
  @Prop() alertDescription: string = '';
  @Prop() alertIcon: string = '';

  // if icon is set, use it, if not use one defined by variant
  get handleIcon() {
    if (this.alertIcon) {
      return this.alertIcon;
    } else {
      switch (this.variant) {
        case 'default':
          return 'info';
        case 'destructive':
          return 'x-octagon';
        case 'success':
          return 'check';
        case 'warning':
          return 'alert-octagon';
        case 'info':
          return 'info';
        case 'error':
          return 'alert-circle';
        default:
          return 'info';
      }
    }
  }

  get alertVariants() {
    return cn(
    "relative w-full rounded-lg border px-4 py-3 text-sm [&>#alertIcon+div]:translate-y-[-3px] [&>#alertIcon]:absolute [&>#alertIcon]:left-4 [&>#alertIcon]:top-4 [&>#alertIcon]:text-foreground [&>#alertIcon~*]:pl-7",
    {
      variant: {
        default: "bg-background text-foreground dark:bg-secondary dark:text-secondary-foreground [&>#alertIcon]:text-background-foreground",
        secondary: "bg-secondary text-secondary-foreground dark:bg-secondary dark:text-secondary-foreground [&>#alertIcon]:text-background-foreground",
        outline: "border-input dark:border-input [&>#alertIcon]:text-background-foreground",
        ghost: "border-transparent dark:border-transparent [&>#alertIcon]:text-background-foreground",
        destructive: "border-destructive/50 text-destructive dark:border-destructive [&>#alertIcon]:text-destructive",
        success: "bg-green-100 text-green-800 dark:bg-green-800 dark:text-green-100 [&>#alertIcon]:text-green-800 border-green-200 dark:border-green-800",
        warning: "bg-yellow-100 text-yellow-800 dark:bg-yellow-800 dark:text-yellow-100 [&>#alertIcon]:text-yellow-800 border-yellow-200 dark:border-yellow-800",
        info: "bg-blue-100 text-blue-800 dark:bg-blue-800 dark:text-blue-100 [&>#alertIcon]:text-blue-800 border-blue-200 dark:border-blue-800",
        error: "bg-red-100 text-red-800 dark:bg-red-800 dark:text-red-100 [&>#alertIcon]:text-red-800 border-red-200 dark:border-red-800",
      },
    },
    {
      variant: this.variant,
    }
    )
  }

  render() {
    return (
      <div role="alert" class={this.alertVariants}>
        {this.handleIcon && <c-icon id="alertIcon" name={this.handleIcon} class="h-4 w-4" />}
        <div class="mb-1 font-medium leading-none tracking-tight flex items-center">
          {this.alertTitle}
          <slot name="icon"></slot>
          <slot name="title"></slot>
        </div>
        <div class="text-sm [&_p]:leading-relaxed">
          {this.alertDescription}
          <slot name="description"></slot>
        </div>
      </div>
    );
  }
}