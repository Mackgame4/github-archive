import { Component, Prop, Element, h } from '@stencil/core';

@Component({
  tag: 'fluid-provider',
  styleUrl: 'fluid-provider.scss',
  shadow: false
})
export class FluidProvider {

  @Element() el: HTMLElement;

  @Prop() background: string = 'white';
  @Prop() backgroundImage: string;

  componentDidLoad() {
    if (this.background) {
      this.el.style.setProperty('--fluid-provider-background', this.background);
    }
  }

  render() {
    return (
        <div class="provider">
          <div class="content">
            <header>
              <slot name="header"></slot>
            </header>
            <main>
              <slot name="content"></slot>
              <slot></slot>
            </main>
            <footer>
              <slot name="footer"></slot>
            </footer>
          </div>
          <div class="background">
            <slot name="background"></slot>
            { this.backgroundImage && <img src={this.backgroundImage} /> }
          </div>
        </div>
    );
  }
}