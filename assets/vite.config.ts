import { defineConfig } from "vite"
import combo from "vite-plugin-combo"
import react from "@vitejs/plugin-react"
import tailwindcss from "@tailwindcss/vite"

export default defineConfig({
  plugins: [
    combo({
      input: ["src/app.tsx"],
      staticDir: "../priv/static",
      ssrInput: ["src/ssr.tsx"],
      ssrOutDir: "../priv/ssr",
    }),
    react(),
    tailwindcss(),
  ],
})
