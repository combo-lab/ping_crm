import { type Page } from "@inertiajs/core"
import { createInertiaApp } from "@inertiajs/react"
import ReactDOMServer from "react-dom/server"
import { resolvePageComponent } from "./inertia-helper"

export function render(page: Page) {
  return createInertiaApp({
    page,
    render: ReactDOMServer.renderToString,
    resolve: (name) =>
      resolvePageComponent(
        `./pages/${name}.tsx`,
        import.meta.glob("./pages/**/*.tsx", { eager: true }),
      ),
    setup: ({ App, props }) => <App {...props} />,
  })
}
