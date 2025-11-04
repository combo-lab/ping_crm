import { ComponentProps } from "react"
import { cn } from "@/lib/utils"

interface Props extends ComponentProps<"input"> {
  error?: string
}

export default function TextInput({ name, className, error, ...props }: Props) {
  className = cn(
    "form-input w-full rounded border-gray-200 focus:border-indigo-400 focus:ring-1 focus:ring-indigo-400 focus:outline-none",
    {
      "border-red-400 focus:border-red-400 focus:ring-red-400": error,
    },
    className,
  )

  return <input id={name} name={name} className={className} {...props} />
}
