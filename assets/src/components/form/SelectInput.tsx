import { ComponentProps } from "react"
import { cn } from "@/lib/utils"

interface SelectInputProps extends ComponentProps<"select"> {
  error?: string
  options: { value: string; label: string }[]
}

export default function SelectInput({
  name,
  className,
  error,
  options = [],
  ...props
}: SelectInputProps) {
  className = cn(
    "w-full form-select rounded border-gray-200 focus:border-indigo-400 focus:ring-1 focus:ring-indigo-400 focus:outline-none",
    { "border-red-400 focus:border-red-400 focus:ring-red-400": error },
    className,
  )

  return (
    <select id={name} name={name} className={className} {...props}>
      {options.map(({ value, label }, index) => (
        <option key={index} value={value}>
          {label}
        </option>
      ))}
    </select>
  )
}
