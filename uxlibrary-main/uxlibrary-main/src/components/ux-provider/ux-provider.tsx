import { Component, Host, h, Prop, State } from '@stencil/core';

@Component({
  tag: 'ux-provider',
  styleUrl: 'ux-provider.scss',
  shadow: false,
})
export class UxProvider {

  @Prop({
    reflect: true,
    mutable: true
  }) theme: string = 'dark';

  @State() loading: boolean = false;

  private toggleTheme() {
    this.theme = this.theme === 'light' ? 'dark' : 'light';
    this.loading = true;
    setTimeout(() => {
      this.loading = false;
    }
    , 1000);
  }

  render() {
    return (
      <Host>
        <button onClick={this.toggleTheme}>Toggle Theme</button>
        { this.loading ?
        <div class={`provider ${this.theme === 'dark' ? 'bg' : ''} ${this.theme === 'light' ? 'provider--light' : 'provider--dark'}`}>
          <slot></slot>
        </div>
        : null }
      </Host>
    );
  }
}