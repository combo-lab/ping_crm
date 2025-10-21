/**
 * Check if the url starts with the path.
 *
 * @param url - The url to check.
 * @param path - The path to check against.
 * @param options - options.
 * @param options.mode - Root matching mode.
                         Available modes: "strict" (only matches itself) or "loose" (matches all paths).
                         Default: "strict".
 * @returns {boolean}
 *
 * @example
 * startsWithPath("/users/123", "/users")                      // true
 * startsWithPath("/users", "/users")                          // true
 * startsWithPath("/admin/users", "/users")                    // false
 * startsWithPath("/", "/", { mode: "strict" })                // true
 * startsWithPath("/users", "/", { mode: "strict" })           // false
 * startsWithPath("/", "/", { mode: "loose" })                 // true
 * startsWithPath("/users", "/", { mode: "loose" })            // true
 * startsWithPath("/users?key=value", "/users")                // true
 */
export function startsWithPath(
  url: string,
  path: string,
  options: { mode?: "strict" | "loose" } = {},
): boolean {
  const { mode = "strict" } = options

  const currentPath = toPath(url)
  const targetPath = path

  // Exact match
  if (currentPath === targetPath) {
    return true
  }

  // Special case: root path only matches itself
  if (targetPath === "/") {
    return mode === "loose" ? true : currentPath === "/"
  }

  const currentSegments = currentPath.split("/").filter(Boolean)
  const targetSegments = targetPath.split("/").filter(Boolean)

  // Current path cannot be shorter than target path
  if (currentSegments.length < targetSegments.length) {
    return false
  }

  // Check if all target segments match
  return targetSegments.every((segment, i) => segment === currentSegments[i])
}

function toPath(url: string): string {
  return url.split("?")[0].split("#")[0]
}
