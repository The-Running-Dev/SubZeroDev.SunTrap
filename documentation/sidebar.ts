import type {SidebarsConfig} from '@docusaurus/plugin-content-docs';

/**
 * The sidebar is manual so category and reading order are explicit. The
 * category folders organize authored source; Docusaurus does not infer the
 * product's intended reading order from them.
 */
const sidebars: SidebarsConfig = {
  docs: [
    'index',
    {
      type: 'category',
      label: 'Orientation',
      collapsed: false,
      items: ['vision/vision'],
    },
    {
      type: 'category',
      label: 'Game Design',
      collapsed: false,
      items: ['design/game-design', 'design/content-and-systems'],
    },
    {
      type: 'category',
      label: 'Product',
      collapsed: false,
      items: ['product/client-specification', 'product/mvp'],
    },
    {
      type: 'category',
      label: 'Delivery',
      collapsed: false,
      items: ['delivery/roadmap-risks-and-open-questions'],
    },
    {
      type: 'category',
      label: 'Working on It',
      collapsed: false,
      items: ['working-on-it/documentation-site'],
    },
  ],
};

export default sidebars;
