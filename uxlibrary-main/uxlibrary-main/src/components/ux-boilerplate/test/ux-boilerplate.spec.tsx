import { newSpecPage } from '@stencil/core/testing';
import { UxBoilerplate } from '../ux-boilerplate';

describe('ux-boilerplate', () => {
  it('renders', async () => {
    const page = await newSpecPage({
      components: [UxBoilerplate],
      html: `<ux-boilerplate></ux-boilerplate>`,
    });
    expect(page.root).toEqualHtml(`
      <ux-boilerplate>
        <mock:shadow-root>
          <slot></slot>
        </mock:shadow-root>
      </ux-boilerplate>
    `);
  });
});