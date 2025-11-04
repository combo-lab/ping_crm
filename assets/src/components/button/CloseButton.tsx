import { ComponentProps } from "react"
import { X } from "lucide-react"
import { cn } from "@/lib/utils"

interface Props extends ComponentProps<"button"> {
  color: string | "red" | "green"
}

export default function CloseButton({ color, onClick }: Props) {
  const className = cn("-mr-2 block fill-current", {
    "text-red-700 group-hover:text-red-800": color === "red",
    "text-green-700 group-hover:text-green-800": color === "green",
  })
  return (
    <button onClick={onClick} type="button" className="group p-2 focus:outline-none">
      <X size={16} className={className} />
    </button>
  )
}
