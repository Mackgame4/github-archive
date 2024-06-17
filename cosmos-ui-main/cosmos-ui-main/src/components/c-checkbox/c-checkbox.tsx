import { Component, Prop, State, h } from '@stencil/core';
import { cn } from '../../utils/utils';

@Component({
  tag: 'c-checkbox',
  styleUrl: 'c-checkbox.css',
  shadow: true,
})
export class CCheckbox {
  @Prop() description: string;
  @Prop() checked: boolean = false;
  @Prop({
    mutable: true,
  }) disabled: boolean = false;
  @State() state: string = 'unchecked';

  componentWillLoad() {
    this.state = this.checked ? 'checked' : 'unchecked';
  }

  get checkboxVariants() {
    return cn(
      "peer h-4 w-4 shrink-0 rounded-sm border border-primary shadow cursor-pointer focus:outline-none focus:ring-1 focus:ring-ring data-[state=checked]:bg-primary data-[state=checked]:text-primary-foreground",
    )
  }

  updateState() {
    if (!this.disabled) {
      this.state = this.state === 'unchecked' ? 'checked' : 'unchecked';
    }
  }

  render() {
    return (
      <div class="inline-flex items-center space-x-2">
        <input type="checkbox" class="peer hidden" checked={this.checked} disabled={this.disabled} />
        <div class={`${this.checkboxVariants} ${this.disabled ? 'cursor-not-allowed opacity-50' : ''}`}
          onClick={() => {this.updateState()}}
          data-state={this.state}
        >
          {this.state === 'checked' && <c-icon name="check" class="custom-padding flex items-center justify-center text-current m-auto h-4 w-3" />}
        </div>
        <div class={`grid gap-1.5 leading-none ${this.description ? 'custom-margin' : ''}`}>
        <c-label class={`${this.disabled ? 'cursor-not-allowed opacity-70' : ''} custom-margin-child text-sm font-medium leading-none cursor-normal`} htmlFor="checkbox" onClick={() => {this.updateState()}}>
          <slot></slot>
        </c-label>
        <p class="custom-margin-child text-sm text-muted-foreground">{this.description}</p>
        </div>
      </div>
      );
  }

}
