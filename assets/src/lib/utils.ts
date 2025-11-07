import { clsx, type ClassValue } from "clsx"
import { twMerge } from "tailwind-merge"

export function cn(...inputs: ClassValue[]) {
  return twMerge(clsx(inputs))
}

export function getURLPath(url: string): string {
  const isAbsoluteURL = url.startsWith("http://") || url.startsWith("https://")
  const parsed = isAbsoluteURL
    ? new URL(url)
    : // use "https://example.com" as the fake base to make parsing work
      new URL(url, "https://example.com")

  return parsed.pathname
}

export function mergeURLQueryParams(
  url: string,
  queryParams: Record<string, string | number | boolean>,
): string {
  const isAbsoluteURL = url.startsWith("http://") || url.startsWith("https://")
  const parsed = isAbsoluteURL
    ? new URL(url)
    : // use "https://example.com" as the fake base to make parsing work
      new URL(url, "https://example.com")

  Object.entries(queryParams).forEach(([key, value]) => {
    parsed.searchParams.set(key, String(value))
  })

  return isAbsoluteURL ? parsed.href : `${parsed.pathname}${parsed.search}`
}

export function fileSize(size: number) {
  const i = Math.floor(Math.log(size) / Math.log(1024))
  return Number((size / Math.pow(1024, i)).toFixed(2)) + " " + ["B", "kB", "MB", "GB", "TB"][i]
}
