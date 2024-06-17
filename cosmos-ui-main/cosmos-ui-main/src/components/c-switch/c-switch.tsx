import { Component, Prop, State, h } from '@stencil/core';
import { cn } from '../../utils/utils';

@Component({
  tag: 'c-switch',
  styleUrl: 'c-switch.css',
  shadow: true,
})
export class CSwitch {
  @Prop() checked: boolean = false;
  @Prop({
    mutable: true,
  }) disabled: boolean = false;
  @State() state: string = 'unchecked';

  componentWillLoad() {
    this.state = this.checked ? 'checked' : 'unchecked';
  }

  updateState() {
    if (!this.disabled) {
      this.state = this.state === 'unchecked' ? 'checked' : 'unchecked';
    }
  }

  get switchVariants() {
    return cn(
      "peer inline-flex h-[20px] w-[36px] shrink-0 cursor-pointer items-center rounded-full border-2 border-transparent shadow-sm transition-colors focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 focus-visible:ring-offset-background data-[state=checked]:bg-primary data-[state=unchecked]:bg-input",
    )
  }

  render() {
    return (
      <div class="inline-flex items-center space-x-2">
      <div class={`${this.switchVariants} ${this.disabled ? 'cursor-not-allowed opacity-50' : ''}`}
        onClick={() => {this.updateState()}}
        data-state={this.state}
      >
        <input type="checkbox" class="peer hidden" />
        <div class="pointer-events-none block h-4 w-4 rounded-full bg-background shadow-lg ring-0 transition-transform data-[state=checked]:translate-x-4 data-[state=unchecked]:translate-x-0"
          data-state={this.state}
        ></div>
      </div>
      <c-label class={`${this.disabled ? 'cursor-not-allowed opacity-70' : ''} text-sm font-medium leading-none cursor-normal`} htmlFor="checkbox" onClick={() => {this.updateState()}}>
        <slot></slot>
      </c-label>
    </div>
    );
  }

}
