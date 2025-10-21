import { PageProps } from "@/types"

import { useState } from "react"
import { usePage, Link } from "@inertiajs/react"
import { ChevronDown } from "lucide-react"

export default function BottomHeader() {
  const { auth } = usePage<PageProps>().props
  const [menuOpened, setMenuOpened] = useState(false)

  return (
    <div className="md:text-md flex w-full items-center justify-between border-b border-gray-200 bg-white p-4 text-sm md:px-12 md:py-0">
      <div className="mt-1 mr-4">{auth.user.account.data!.name}</div>
      <div className="relative">
        <div
          className="group flex cursor-pointer items-center select-none"
          onClick={() => setMenuOpened(true)}
        >
          <div className="mr-1 whitespace-nowrap text-gray-800 group-hover:text-indigo-600 focus:text-indigo-600">
            <span>{auth.user.first_name}</span>
            <span className="ml-1 hidden md:inline">{auth.user.last_name}</span>
          </div>
          <ChevronDown size={20} className="text-gray-800 group-hover:text-indigo-600" />
        </div>
        <div className={menuOpened ? "" : "hidden"}>
          <div className="absolute top-0 right-0 left-auto z-20 mt-8 rounded bg-white py-2 text-sm whitespace-nowrap shadow-xl">
            <Link
              href="/profile"
              className="block px-6 py-2 hover:bg-indigo-600 hover:text-white"
              onClick={() => setMenuOpened(false)}
            >
              Profile
            </Link>
            <Link
              href="/users"
              className="block px-6 py-2 hover:bg-indigo-600 hover:text-white"
              onClick={() => setMenuOpened(false)}
            >
              Manage Users
            </Link>
            <Link
              as="button"
              href="/logout"
              method="delete"
              className="block w-full px-6 py-2 text-left hover:bg-indigo-600 hover:text-white focus:outline-none"
            >
              Logout
            </Link>
          </div>
          <div
            onClick={() => {
              setMenuOpened(false)
            }}
            className="fixed inset-0 z-10 bg-black opacity-25"
          ></div>
        </div>
      </div>
    </div>
  )
}
