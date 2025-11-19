import { dashboard_path } from "@/routes"
import { useState } from "react"
import { Link } from "@inertiajs/react"
import Logo from "@/components/Logo"
import MainMenu from "@/components/menu/MainMenu"
import { Menu } from "lucide-react"

export default () => {
  const [menuOpened, setMenuOpened] = useState(false)
  return (
    <div className="flex items-center justify-between bg-indigo-900 px-6 py-4 md:w-56 md:flex-shrink-0 md:justify-center">
      <Link className="mt-1" href={dashboard_path(":index")}>
        <Logo className="fill-current text-white" width="120" height="28" />
      </Link>
      <div className="relative md:hidden">
        <Menu
          color="white"
          size={32}
          onClick={() => setMenuOpened(true)}
          className="cursor-pointer"
        />
        <div className={`${menuOpened ? "" : "hidden"} absolute right-0 z-20`}>
          <MainMenu className="relative z-20 mt-2 rounded bg-indigo-800 px-8 py-4 pb-2 shadow-lg" />
          <div
            onClick={() => {
              setMenuOpened(false)
            }}
            className="fixed inset-0 z-10 bg-black opacity-25"
          />
        </div>
      </div>
    </div>
  )
}
