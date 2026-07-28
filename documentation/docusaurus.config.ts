import type {Config} from '@docusaurus/types';
import type * as Preset from '@docusaurus/preset-classic';

const config: Config = {
  title: 'Sun Trap',
  tagline: 'A satirical resort-management simulation',
  url: 'https://suntrap.subzerodev.com',
  baseUrl: '/',

  onBrokenLinks: 'throw',
  onBrokenAnchors: 'throw',

  markdown: {
    hooks: {
      onBrokenMarkdownLinks: 'throw',
    },
  },

  i18n: {defaultLocale: 'en', locales: ['en']},

  presets: [
    [
      'classic',
      {
        docs: {
          path: '.',
          include: [
            'index.md',
            'vision/**/*.md',
            'design/**/*.md',
            'product/**/*.md',
            'delivery/**/*.md',
            'working-on-it/**/*.md',
          ],
          exclude: [
            '**/node_modules/**',
            '**/.docusaurus/**',
            '**/artifacts/**',
            '**/build/**',
            '**/src/**',
          ],
          sidebarPath: './sidebar.ts',
          routeBasePath: '/',
        },
        blog: false,
      } satisfies Preset.Options,
    ],
  ],

  themeConfig: {
    navbar: {
      title: 'Sun Trap',
      items: [{type: 'docSidebar', sidebarId: 'docs', position: 'left', label: 'Documentation'}],
    },
    footer: {style: 'dark', links: []},
  } satisfies Preset.ThemeConfig,
};

export default config;
