import { PageProps } from "@/types"

import { useState, useEffect } from "react"
import { usePage, router } from "@inertiajs/react"
import { usePrevious } from "react-use"
import { cn, getURLPath } from "@/lib/utils"
import FieldGroup from "@/components/form/FieldGroup"
import SelectInput from "@/components/form/SelectInput"
import TextInput from "@/components/form/TextInput"
import { ChevronDown } from "lucide-react"
import pickBy from "lodash/pickBy"

type Filter = "role" | "status"

interface SearchBarProps {
  filters: Filter[]
}

export default function SearchBar({ filters = [] }: SearchBarProps) {
  const page = usePage<
    PageProps & {
      filters: { search?: string; role?: string; status?: string }
    }
  >()

  const showFilter = filters.length !== 0

  const url = page.url
  const { filters: filterParams } = page.props

  const [values, setValues] = useState({
    search: filterParams.search || "",
    role: filterParams.role || "",
    status: filterParams.status || "",
  })

  const [opened, setOpened] = useState(false)

  const prevValues = usePrevious(values)

  function reset() {
    setValues({
      search: "",
      role: "",
      status: "",
    })
  }

  useEffect(() => {
    if (prevValues) {
      const query = pickBy(values)

      router.get(getURLPath(url), query, {
        replace: true,
        preserveState: true,
      })
    }
  }, [values])

  function handleChange(e: React.ChangeEvent<HTMLInputElement | HTMLSelectElement>) {
    const name = e.target.name
    const value = e.target.value

    setValues((values) => ({
      ...values,
      [name]: value,
    }))

    if (opened) setOpened(false)
  }

  return (
    <div className="mr-4 flex w-full max-w-md items-center">
      <div className="relative flex rounded bg-white shadow">
        {showFilter && (
          <>
            <div className={cn("absolute top-full", opened ? "" : "hidden")}>
              <div
                onClick={() => setOpened(false)}
                className="fixed inset-0 z-20 bg-black opacity-25"
              />
              <div className="relative z-30 mt-2 w-64 space-y-4 rounded bg-white px-4 py-6 shadow-lg">
                {filters.includes("role") && (
                  <FieldGroup label="Role" name="role">
                    <SelectInput
                      name="role"
                      value={values.role}
                      onChange={handleChange}
                      options={[
                        { value: "", label: "All" },
                        { value: "owner", label: "Owner" },
                        { value: "user", label: "User" },
                      ]}
                    />
                  </FieldGroup>
                )}
                {filters.includes("status") && (
                  <FieldGroup label="Status" name="status">
                    <SelectInput
                      name="status"
                      value={values.status}
                      onChange={handleChange}
                      options={[
                        { value: "all", label: "All" },
                        { value: "", label: "Active" },
                        { value: "deleted", label: "Deleted" },
                      ]}
                    />
                  </FieldGroup>
                )}
              </div>
            </div>

            <button
              onClick={() => setOpened(true)}
              className="rounded-l border-r border-gray-200 px-4 hover:bg-gray-100 focus:z-10 focus:border-white focus:ring-2 focus:ring-indigo-400 focus:outline-none md:px-6"
            >
              <div className="flex items-center">
                <span className="hidden text-gray-700 md:inline">Filter</span>
                <ChevronDown size={14} strokeWidth={3} className="md:ml-2" />
              </div>
            </button>
          </>
        )}

        <TextInput
          name="search"
          placeholder="Search…"
          autoComplete="off"
          value={values.search}
          onChange={handleChange}
          className={cn("border-0 focus:ring-2", { "rounded-l-none": showFilter })}
        />
      </div>
      <button
        onClick={reset}
        className="ml-3 text-sm text-gray-600 hover:text-gray-700 focus:text-indigo-700 focus:outline-none"
        type="button"
      >
        Reset
      </button>
    </div>
  )
}
