import React, { useState, useEffect, useRef, ComponentProps } from "react"
import { cn } from "@/lib/utils"

interface ImageInputProps {
  name: string
  value: string | null
  error?: string
  onChange?: (file: File | null) => void
}

export default function ImageInput(props: ImageInputProps) {
  const { name, error, onChange } = props
  const fileInput = useRef<HTMLInputElement>(null)
  const [file, setFile] = useState<File | null>(null)

  const selectedFileURL = file && URL.createObjectURL(file)

  useEffect(() => {
    return () => {
      if (selectedFileURL) {
        URL.revokeObjectURL(selectedFileURL)
      }
    }
  }, [fileInput, selectedFileURL])

  const existingFileURL = props.value
  const previewURL = selectedFileURL || existingFileURL

  function handleBrowse() {
    fileInput.current?.click()
  }

  function handleRemove() {
    setFile(null)
    onChange?.(null)

    if (fileInput.current) {
      fileInput.current.value = ""
    }
  }

  function handleChange(e: React.FormEvent<HTMLInputElement>) {
    const files = e.currentTarget?.files as FileList
    const file = files[0] || null
    setFile(file)
    onChange?.(file)
  }

  return (
    <>
      <input
        id={name}
        ref={fileInput}
        type="file"
        accept="image/*"
        className="hidden"
        onChange={handleChange}
      />
      <div
        className={cn(
          "grid grid-cols-[auto_min-content]",
          "form-input w-full rounded border-gray-200 p-0 focus:border-indigo-400 focus:ring-1 focus:ring-indigo-400 focus:outline-none",
          { "border-red-400 focus:border-red-400 focus:ring-red-400": error },
        )}
      >
        <div className="p-2 pl-3">
          {file ? (
            <BrowseButton text="Remove" onClick={handleRemove} />
          ) : (
            <BrowseButton text="Browse" onClick={handleBrowse} />
          )}
        </div>
        {previewURL && (
          <div className="m-1 aspect-square overflow-hidden rounded-full bg-red-200 object-cover">
            <img className="h-full w-full object-cover" src={previewURL} />
          </div>
        )}
      </div>
    </>
  )
}

interface BrowseButtonProps extends ComponentProps<"button"> {
  text: string
}

function BrowseButton({ text, onClick, ...props }: BrowseButtonProps) {
  return (
    <button
      {...props}
      type="button"
      className="rounded-sm bg-gray-600 px-4 py-1 text-xs font-medium text-white hover:bg-gray-700 focus:outline-none"
      onClick={onClick}
    >
      {text}
    </button>
  )
}
