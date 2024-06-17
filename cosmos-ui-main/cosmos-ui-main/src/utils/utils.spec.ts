import { cn } from './utils';

describe('cn', () => {
  it('should return a string', () => {
    expect(cn('')).toEqual(expect.any(String));
  });

  it('should return a string with the same value as the input', () => {
    expect(cn('test')).toEqual('test');
  });
});