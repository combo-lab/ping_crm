import { Link } from "@inertiajs/react"
import { ChevronRight } from "lucide-react"
import get from "lodash/get"

interface Props<T> {
  columns: {
    label: string
    name: string
    colSpan?: number
    renderCell?: (row: T) => React.ReactNode
  }[]
  rows: T[]
  getRowDetailsUrl?: (row: T) => string
}

export default function Table<T>({ columns = [], rows = [], getRowDetailsUrl }: Props<T>) {
  return (
    <div className="overflow-x-auto rounded bg-white shadow">
      <table className="w-full whitespace-nowrap">
        <thead>
          <tr className="text-left font-bold">
            {columns?.map((column) => (
              <th key={column.label} colSpan={column.colSpan ?? 1} className="px-6 pt-5 pb-4">
                {column.label}
              </th>
            ))}
          </tr>
        </thead>
        <tbody>
          {/* Empty state */}
          {rows?.length === 0 && (
            <tr>
              <td
                className="border-t border-gray-200 px-6 py-24 text-center"
                colSpan={columns.length}
              >
                No data found.
              </td>
            </tr>
          )}
          {rows?.map((row, index) => {
            return (
              <tr key={index} className="focus-within:bg-gray-100 hover:bg-gray-100">
                {columns.map((column) => {
                  return (
                    <td key={column.name} className="border-t border-gray-200">
                      <Link
                        tabIndex={-1}
                        href={getRowDetailsUrl?.(row)}
                        className="focus:text-indigo flex items-center px-6 py-4 focus:outline-none"
                      >
                        {column.renderCell?.(row) ?? get(row, column.name) ?? "N/A"}
                      </Link>
                    </td>
                  )
                })}
                <td className="w-px border-t border-gray-200">
                  <Link
                    href={getRowDetailsUrl?.(row)}
                    className="flex items-center px-4 focus:outline-none"
                  >
                    <ChevronRight size={24} className="text-gray-400" />
                  </Link>
                </td>
              </tr>
            )
          })}
        </tbody>
      </table>
    </div>
  )
}
