import { Component, h, Prop, Element } from '@stencil/core';
import { cn } from '../../utils/utils';

@Component({
  tag: 'c-slider',
  styleUrl: 'c-slider.css',
  shadow: true,
})
export class CSlider {
  @Element() el: HTMLElement;
  @Prop({
    mutable: true,
    reflect: true,
  }) value: number = 50;
  @Prop() disabled: boolean = false;
  @Prop() min: number = 0;
  @Prop() max: number = 100;
  @Prop() step: number = 1;

  get sliderVariants() {
    return cn(
      "relative flex w-full touch-none select-none items-center"
    );
  }

  updateThumbAndRangePosition = () => {
    const trackElement = this.el.shadowRoot.querySelector('#track') as HTMLElement;
    const rangeElement = this.el.shadowRoot.querySelector('#range') as HTMLElement;
    const thumbElement = this.el.shadowRoot.querySelector('#thumb') as HTMLElement;
    if (trackElement && rangeElement && thumbElement) {
      const trackWidth = trackElement.clientWidth;
      const newPosition = (this.value / 100) * trackWidth;
      rangeElement.style.width = `${newPosition}px`;
      thumbElement.style.left = `${newPosition - thumbElement.clientWidth / 2}px`;
    }
  };

  componentDidLoad() {
    this.updateThumbAndRangePosition();
  }

  handleInputChange = (event: Event) => {
    const inputElement = event.target as HTMLInputElement;
    this.value = parseInt(inputElement.value);
    this.updateThumbAndRangePosition();
  };

  render() {
    return (
      <div class={this.sliderVariants}>
        <input class="absolute w-full h-full opacity-0 cursor-pointer" type="range" min={this.min} max={this.max} step={this.step} disabled={this.disabled} value={this.value} onInput={this.handleInputChange} />
        <div id="track" class="pointer-events-none relative h-1.5 w-full grow overflow-hidden rounded-full bg-primary/20">
          <div id="range" class="pointer-events-none absolute h-full bg-primary"></div>
        </div>
        <div id="thumb" class="pointer-events-none absolute h-4 w-4 rounded-full border border-primary/50 bg-background shadow transition-transform focus-visible:outline-none focus-visible:ring-1 focus-visible:ring-ring disabled:pointer-events-none disabled:opacity-50"></div>
      </div>
    );
  }
}