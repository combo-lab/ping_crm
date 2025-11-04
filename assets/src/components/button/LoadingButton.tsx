import { cn } from "@/lib/utils"

interface Props extends React.ButtonHTMLAttributes<HTMLButtonElement> {
  loading: boolean
}

export default function LoadingButton({ loading, className, children, ...props }: Props) {
  className = cn(
    "flex items-center",
    "focus:outline-none",
    {
      "bg-opacity-75 pointer-events-none select-none": loading,
    },
    className,
  )
  return (
    <button disabled={loading} className={className} {...props}>
      {loading && <div className="btn-spinner mr-2" />}
      {children}
    </button>
  )
}
