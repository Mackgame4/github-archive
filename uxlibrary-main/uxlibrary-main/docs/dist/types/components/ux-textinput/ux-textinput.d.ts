import { EventEmitter } from '../../stencil-public-runtime';
export declare class UxTextinput {
  element: HTMLElement;
  value: string;
  rounded: boolean;
  prependIcon: string;
  appendIcon: string;
  placeholder: string;
  maxlength: number;
  componentInput: EventEmitter;
  componentChange: EventEmitter;
  private gatherInnerText;
  private textInputChanged;
  private inputChanged;
  render(): any;
}
