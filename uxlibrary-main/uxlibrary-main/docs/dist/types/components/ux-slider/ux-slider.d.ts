import { EventEmitter } from '../../stencil-public-runtime';
export declare class UxSlider {
  el: HTMLElement;
  min: number;
  max: number;
  value: number;
  componentChange: EventEmitter;
  componentInput: EventEmitter;
  private changeSliderValue;
  render(): any;
}
