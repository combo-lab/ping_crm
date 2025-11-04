import { Link, usePage } from "@inertiajs/react"
import { startsWithPath } from "@/lib/route"
import { cn } from "@/lib/utils"

interface Props {
  icon: React.ReactNode
  link: string
  text: string
}

export default function MainMenuItem({ icon, link, text }: Props) {
  const { url } = usePage()
  const isActive = startsWithPath(url, link)

  const iconClasses = cn({
    "text-white": isActive,
    "text-indigo-400 group-hover:text-white": !isActive,
  })

  const textClasses = cn({
    "text-white": isActive,
    "text-indigo-200 group-hover:text-white": !isActive,
  })

  return (
    <div className="mb-4">
      <Link href={link} className="group flex items-center space-x-3 py-3">
        <div className={iconClasses}>{icon}</div>
        <div className={textClasses}>{text}</div>
      </Link>
    </div>
  )
}
