import { Component, Prop, h } from '@stencil/core';
import { cn } from '../../utils/utils';

@Component({
  tag: 'c-card',
  styleUrl: 'c-card.css',
  shadow: true,
})
export class CCard {
  @Prop() cardTitle: string;
  @Prop() cardSubtitle: string;
  @Prop() cardDescription: string;
  @Prop() cardFooter: string;

  get cardVariants() {
    return cn(
      "rounded-xl border bg-card text-card-foreground shadow",
    )
  }

  render() {
    return (
      <div id="card" class={this.cardVariants}>
        <div id="header" class="flex flex-col space-y-1.5 p-6">
          <slot name="header">
            <div id="title" class="text-2xl font-semibold leading-none tracking-tight">{this.cardTitle}</div>
            <div id="subtitle" class="font-semibold leading-none tracking-tight">{this.cardSubtitle}</div>
            <div id="description" class="text-sm text-muted-foreground">{this.cardDescription}</div>
          </slot>
        </div>
        <div id="content" class="p-6 pt-0">
          <slot name="content"></slot>
          <slot></slot>
        </div>
        <div id="footer" class="flex items-center p-6 pt-0">
          <slot name="footer">
            <div id="footer-text" class="text-sm text-muted-foreground">{this.cardFooter}</div>
          </slot>
        </div>
      </div>
    );
  }

}
