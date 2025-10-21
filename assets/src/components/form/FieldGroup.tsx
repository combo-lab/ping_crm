interface FieldGroupProps {
  className?: string
  name?: string
  label?: string
  error?: string
  children: React.ReactNode
}

export default function FieldGroup({ className, label, name, error, children }: FieldGroupProps) {
  return (
    <div className={className}>
      {label && (
        <label className="mb-2 block font-medium text-gray-800 select-none" htmlFor={name}>
          {label}
        </label>
      )}
      {children}
      {error && <div className="mt-2 text-sm text-red-500">{error}</div>}
    </div>
  )
}
