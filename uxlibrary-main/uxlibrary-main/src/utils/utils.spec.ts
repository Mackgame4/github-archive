import { log } from './utils';

describe('log', () => {
  it('returns empty string for no names defined', () => {
    expect(log(undefined, undefined, undefined)).toEqual('');
  });

  it('formats just first names', () => {
    expect(log('Joseph', undefined, undefined)).toEqual('Joseph');
  });

  it('formats first and last names', () => {
    expect(log('Joseph', undefined, 'Publique')).toEqual('Joseph Publique');
  });

  it('formats first, middle and last names', () => {
    expect(log('Joseph', 'Quincy', 'Publique')).toEqual('Joseph Quincy Publique');
  });
});
