import type { Config } from '@docusaurus/types';
import type * as Preset from '@docusaurus/preset-classic';

/**
 * Local Docusaurus config — overrides the base image's default when this
 * directory is copied over /template (see ./Dockerfile). Content lives in
 * ./docs; the sidebar is ./sidebar.ts.
 *
 * Broken links and anchors fail the production build so the published site
 * cannot silently drift.
 */
const config: Config = {
  title: 'Sun Trap',
  tagline: 'A satirical resort-management simulation',
  url: 'https://suntrap.subzerodev.com',
  baseUrl: '/',
  onBrokenLinks: 'throw',
  onBrokenAnchors: 'throw',
  markdown: {
    hooks: {
      onBrokenMarkdownLinks: 'throw'
    }
  },
  i18n: { defaultLocale: 'en', locales: ['en'] },
  presets: [
    [
      'classic',
      {
        docs: {
          sidebarPath: './sidebar.ts',
          routeBasePath: 'docs'
        },
        blog: false
      } satisfies Preset.Options
    ]
  ],

  themeConfig: {
    navbar: {
      title: 'Sun Trap',
      items: [
        {
          type: 'docSidebar',
          sidebarId: 'docs',
          position: 'left',
          label: 'Documentation'
        }
      ]
    },
    footer: { style: 'dark', links: [] }
  } satisfies Preset.ThemeConfig
};

export default config;
