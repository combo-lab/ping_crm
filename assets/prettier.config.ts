import type { Config } from "prettier"

const config: Config = {
  semi: false,
  singleQuote: false,
  printWidth: 98,
  tabWidth: 2,
  trailingComma: "none",
  quoteProps: "consistent",
  bracketSpacing: true,
  arrowParens: "always",
  singleAttributePerLine: false,
  plugins: ["prettier-plugin-tailwindcss"],
  tailwindFunctions: ["clsx", "cn"],
  tailwindStylesheet: "src/css/app.css"
}

export default config
