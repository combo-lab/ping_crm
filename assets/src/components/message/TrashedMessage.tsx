import { Trash2 } from "lucide-react"
import Alert from "@/components/Alert"

interface TrashedMessageProps {
  message: string
  onRestore: () => void
}

export default function TrashedMessage({ message, onRestore }: TrashedMessageProps) {
  return (
    <Alert
      variant="warning"
      message={message}
      icon={<Trash2 size={20} />}
      action={
        <button
          onClick={onRestore}
          children="Restore"
          className="text-xs font-medium text-yellow-800 hover:underline focus:outline-none"
        />
      }
    />
  )
}
