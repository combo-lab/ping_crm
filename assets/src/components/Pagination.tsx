import { usePage, Link } from "@inertiajs/react"
import { cn, mergeURLQueryParams } from "@/lib/utils"

interface PageItemProps {
  key: string | number
  label: string | number
  url: string
  active: boolean
}

function PageItem({ label, url, active }: PageItemProps) {
  const className = cn(
    "mr-1 mb-1 rounded border border-solid border-gray-200 px-4 py-3 text-sm",
    "hover:bg-white focus:border-indigo-700 focus:text-indigo-700 focus:outline-none",
    { "bg-white": active },
  )

  return (
    <Link className={className} href={url}>
      {label}
    </Link>
  )
}

interface PaginationProps {
  page: number
  page_size: number
  total_count: number
  total_pages: number
  has_prev_page: boolean
  has_next_page: boolean
}

export default function Pagination({ page, total_pages }: PaginationProps) {
  const { url } = usePage()

  const pages = Array.from({ length: total_pages }, (_, i) => {
    const current_page = i + 1
    return {
      label: current_page,
      active: current_page === page,
      url: mergeURLQueryParams(url, { page: current_page }),
    }
  })

  return (
    <div className="flex-end mt-6 -mb-1 flex">
      {pages.map((page) => {
        return <PageItem key={page.label} {...page} />
      })}
    </div>
  )
}
