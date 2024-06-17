import { newE2EPage } from '@stencil/core/testing';

describe('ux-boilerplate', () => {
  it('renders', async () => {
    const page = await newE2EPage();
    await page.setContent('<ux-boilerplate></ux-boilerplate>');

    const element = await page.find('ux-boilerplate');
    expect(element).toHaveClass('hydrated');
  });
});