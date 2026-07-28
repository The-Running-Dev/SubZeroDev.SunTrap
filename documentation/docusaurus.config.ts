import type {Config} from '@docusaurus/types';
import type * as Preset from '@docusaurus/preset-classic';

const config: Config = {
  title: 'Sun Trap',
  tagline: 'A satirical resort-management simulation',
  url: 'https://the-running-dev.github.io',
  baseUrl: '/SubZeroDev.SunTrap/',

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
