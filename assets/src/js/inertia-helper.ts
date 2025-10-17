// An Inertia helper for resolving page component.
//
// # Usage
//
// Use it in the `resolve` function.
//
// ## Resolve page component
//
//     createInertiaApp({
//       // ...
//       resolve: (name) =>
//         resolvePageComponent(
//           `./pages/${name}.jsx`,
//           import.meta.glob("./pages/**/*.jsx", { eager: true }),
//         ),
//     })
//
// ## Resolve page component with a fallback name
//
//     createInertiaApp({
//       // ...
//       resolve: (name) =>
//         resolvePageComponent(
//           `./pages/${name}.jsx`,
//           import.meta.glob("./pages/**/*.jsx", { eager: true }),
//           { fallbackName: "./pages/404.jsx" },
//         ),
//     })
//

type EagerPages<T> = Record<string, T>
type LazyPages<T> = Record<string, () => Promise<T>>

export async function resolvePageComponent<T>(
  page: string,
  pages: EagerPages<T> | LazyPages<T>,
  options?: { fallbackName?: string },
): Promise<T> {
  if (typeof pages[page] === "undefined" && options?.fallbackName) {
    page = options.fallbackName
  }

  const resolvedPage = pages[page]

  if (typeof resolvedPage === "undefined") {
    throw new Error(`Page not found: ${page}`)
  }

  // When code spiltting is enabled, page is a function.
  // Or, page is an object.
  return typeof resolvedPage === "function" ? (resolvedPage as () => Promise<T>)() : resolvedPage
}
