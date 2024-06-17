import { Prop, State, h } from '@stencil/core';
import { cn } from '../../utils/utils';

export class CInput {
  @Prop() type: string = 'text';
  @Prop() placeholder: string = 'Placeholder';
  @Prop() disabled: boolean = false;
  @Prop() required: boolean = false;
  @Prop() readonly: boolean = false;
  @Prop() label: string = '';
  @Prop() value: string = '';
  @Prop() min: string = '';
  @Prop() max: string = '';
  @Prop() step: string = '';
  @Prop() prependIcon: string = '';
  @Prop() appendIcon: string = '';
  @Prop() classIcon: string = 'm-auto h-4 w-4';

  @State() focused: boolean = false;

  get inputVariants() {
    return cn(
      'flex h-9 w-full border border-input bg-background rounded-md px-2 py-1 text-sm'
    );
  }

  render() {
    return (
      <div class={`grid w-full rounded-md max-w-sm items-center gap-1.5 shadow-sm transition-colors ${
        this.focused ? 'outline-none ring-1 ring-ring' : ''
      }`}
      tabIndex={0}>
        {this.label && <c-label htmlFor="input">{this.label}</c-label>}
        <div class={this.inputVariants}>
          {this.prependIcon && (
            <c-icon name={this.prependIcon} class={this.classIcon} />
          )}
          <input
            id="input"
            class="w-full bg-transparent file:border-0 file:bg-transparent file:text-sm file:font-medium placeholder:text-muted-foreground disabled:cursor-not-allowed disabled:opacity-50 focus:outline-none mr-1 ml-1"
            type={this.type}
            placeholder={this.placeholder}
            disabled={this.disabled}
            required={this.required}
            readonly={this.readonly}
            min={this.min}
            max={this.max}
            step={this.step}
            value={this.value}
            onFocus={() => (this.focused = true)}
            onBlur={() => (this.focused = false)}
          />
          {this.appendIcon && (
            <c-icon name={this.appendIcon} class={this.classIcon} />
          )}
        </div>
      </div>
    );
  }
}