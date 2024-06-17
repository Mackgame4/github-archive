import { EventEmitter } from '../../stencil-public-runtime';
export declare class UxOtp {
  el: HTMLElement;
  length: number;
  useSeparators: boolean;
  value: string[];
  separator: string;
  cellLength: number;
  uppercaseCells: boolean;
  componentFilled: EventEmitter;
  componentWillLoad(): void;
  componentDidLoad(): void;
  private changeInputCell;
  private isFilled;
  render(): any;
}
