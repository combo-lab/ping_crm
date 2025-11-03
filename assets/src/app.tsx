import "vite/modulepreload-polyfill"

import "@fontsource-variable/inter"
import "./app.css"

import axios from "axios"
import { createInertiaApp } from "@inertiajs/react"
import { StrictMode } from "react"
import { createRoot, hydrateRoot } from "react-dom/client"
import { resolvePageComponent } from "./inertia-helper"

axios.defaults.xsrfCookieName = "CSRF-TOKEN"
axios.defaults.xsrfHeaderName = "X-CSRF-TOKEN"

const appName = "PingCRM"

function ssr_mode() {
  return document.documentElement.hasAttribute("data-ssr")
}

createInertiaApp({
  title: (title) => (title ? `${title} - ${appName}` : appName),
  resolve: (name) =>
    resolvePageComponent(
      `./pages/${name}.tsx`,
      import.meta.glob("./pages/**/*.tsx", { eager: true }),
    ),
  setup({ el, App, props }) {
    if (ssr_mode()) {
      hydrateRoot(el, <App {...props} />)
    } else {
      createRoot(el).render(
        <StrictMode>
          <App {...props} />
        </StrictMode>,
      )
    }
  },
})
