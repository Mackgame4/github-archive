import { Component, Host, Prop, Element, Watch, h } from '@stencil/core';
import { debugMode, toggleDark } from '../../utils/utils';

@Component({
  tag: 'c-provider',
  styleUrl: 'c-provider.css',
  shadow: false,
})
export class CProvider {
  @Prop({ mutable: true, reflect: true }) dark: boolean;
  @Prop({ mutable: true }) class: string;
  @Prop({ mutable: true }) theme: string;

  @Element() el: HTMLElement;

  componentDidLoad() {
    if (debugMode) console.log('%c Cosmos UI is ready!', 'background: #222; color: #bada55');
  }

  componentWillLoad() {
    if (this.dark) {
      this.el.classList.toggle('dark');
    }
  }

  @Watch('class')
  watchClass() {
    if (this.class.includes('dark')) {
      toggleDark(true);
    } else {
      toggleDark(false);
    }
  }

  render() {
    return (
      <Host>
        <div class="h-screen bg-background text-foreground font-sans antialiased">
          <slot></slot>
        </div>
      </Host>
    );
  }
}