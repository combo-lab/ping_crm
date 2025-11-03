import { PageProps } from "@/types"

import { useState } from "react"
import { usePage } from "@inertiajs/react"
import Alert from "@/components/Alert"

export default function FlashMessages() {
  const { flash, errors } = usePage<PageProps>().props
  const formErrors = Object.keys(errors).length

  const [visible, setVisible] = useState(true)
  const [prevFlash, setPrevFlash] = useState(flash)
  const [prevErrors, setPrevErrors] = useState(errors)

  if (flash !== prevFlash) {
    setPrevFlash(flash)
    setVisible(true)
  }

  if (errors !== prevErrors) {
    setPrevErrors(errors)
    setVisible(true)
  }

  return (
    <>
      {flash.info && visible && (
        <Alert variant="info" message={flash.info} onClose={() => setVisible(false)} />
      )}
      {flash.success && visible && (
        <Alert variant="success" message={flash.success} onClose={() => setVisible(false)} />
      )}
      {flash.error && visible && (
        <Alert variant="error" message={flash.error} onClose={() => setVisible(false)} />
      )}
      {formErrors > 0 && visible && (
        <Alert
          variant="error"
          message={"There are " + formErrors + " form errors."}
          onClose={() => setVisible(false)}
        />
      )}
    </>
  )
}
