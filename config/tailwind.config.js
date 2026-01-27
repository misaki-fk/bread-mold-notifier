const defaultTheme = require('tailwindcss/defaultTheme')

module.exports = {
  content: [
    './app/views/**/*.{erb,html,slim}',
    './app/helpers/**/*.rb',
    './app/javascript/**/*.{js,ts}',
    './app/assets/stylesheets/**/*.css',
  ],
  theme: {
    extend: {
      fontFamily: {
        sans: ['Inter var', ...defaultTheme.fontFamily.sans],
      },
    },
  },
  plugins: [
    require("daisyui"),
  ],
  daisyui: {
    themes: [
      {
        bread: {
          "primary": "#a56c2fff",
          "primary-content": "#ffffff",

          "secondary": "#e9c455ff",
          "secondary-content": "#4B3425",

          "accent": "#E17055",
          "accent-content": "#ffffff",

          "neutral": "#4B3425",
          "neutral-content": "#ffffff",

          "base-100": "#FFF8EE",
          "base-200": "#F5EBDD",
          "base-300": "#EADCC8",
          "base-content": "#4B3425",

          "info": "#A7C7E7",
          "success": "#6FB98F",
          "warning": "#F4B266",
          "error": "#E06666",
        },
      },
    ],
  },
}
