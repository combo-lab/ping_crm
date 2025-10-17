import { defineConfig } from "eslint/config"
import javascript from "@eslint/js"
import typescript from "typescript-eslint"
import globals from "globals"
import react from "eslint-plugin-react"
import reactHooks from "eslint-plugin-react-hooks"
import prettier from "eslint-config-prettier"

export default defineConfig([
  javascript.configs.recommended,
  ...typescript.configs.recommended,
  {
    languageOptions: {
      globals: {
        ...globals.browser
      }
    }
  },
  {
    ...react.configs.flat.recommended,
    ...react.configs.flat["jsx-runtime"],
    rules: {
      "react/react-in-jsx-scope": "off",
      "react/prop-types": "off",
      "react/no-unescaped-entities": "off"
    },
    settings: {
      react: {
        version: "detect"
      }
    }
  },
  {
    plugins: {
      "react-hooks": reactHooks
    },
    rules: {
      "react-hooks/rules-of-hooks": "error",
      "react-hooks/exhaustive-deps": "warn"
    }
  },
  {
    ignores: ["node_modules"]
  },
  prettier // Turn off all rules that might conflict with Prettier
])
