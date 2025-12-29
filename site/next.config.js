/** @type {import('next').NextConfig} */

const nextConfig = {
  output: 'export',
  distDir: '../public',
  env: {
    name: 'Buzzbold Registry',
    description: 'Custom workspaces for Buzzbold.',
    icon: 'https://buzzbold.com/app/uploads/2017/02/buzzbold-bubbles-white-pad.png',
    listUrl: 'https://buzzbold.github.io/kasm-workspaces-registry/',
    contactUrl: 'https://github.com/buzzbold/kasm-workspaces-registry/issues',
  },
  reactStrictMode: true,
  basePath: '/kasm-workspaces-registry/1.0',
  trailingSlash: true,
  images: {
    unoptimized: true,
  }
}

module.exports = nextConfig
