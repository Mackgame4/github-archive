import { EventEmitter } from '../../stencil-public-runtime';
export declare class UxSelect {
  element: HTMLElement;
  showMenu: boolean;
  appendIconOn: string;
  appendIconOff: string;
  rotateAppendIcon: boolean;
  prependIconOn: string;
  prependIconOff: string;
  rotatePrependIcon: boolean;
  defaultSelected: number;
  showSelectedOption: boolean;
  componentChange: EventEmitter;
  private appendIconState;
  private prependIconState;
  private gatherOptions;
  private toggleOptionsMenu;
  private selectedOption;
  render(): any;
}
