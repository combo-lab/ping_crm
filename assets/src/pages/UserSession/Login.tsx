import { user_session_path } from "@/routes"
import { Head, useForm } from "@inertiajs/react"
import Logo from "@/components/Logo"
import FieldGroup from "@/components/form/FieldGroup"
import TextInput from "@/components/form/TextInput"
import LoadingButton from "@/components/button/LoadingButton"

export default function LoginPage() {
  const form = useForm({
    email: "johndoe@example.com",
    password: "secret!secret!",
  })

  function handleSubmit(e: React.FormEvent<HTMLFormElement>) {
    e.preventDefault()
    form.submit("post", user_session_path(":create"))
  }

  return (
    <>
      <Head title="Login" />
      <div className="flex min-h-screen items-center justify-center bg-indigo-800 p-6">
        <div className="w-full max-w-md">
          <Logo className="mx-auto block w-full max-w-xs fill-current text-white" height={50} />
          <form
            onSubmit={handleSubmit}
            className="mt-8 overflow-hidden rounded-lg bg-white shadow-xl"
          >
            <div className="px-10 py-12">
              <h1 className="text-center text-3xl font-bold">Welcome Back!</h1>

              <div className="mx-auto mt-6 w-24 border-b-2 border-gray-200" />

              {form.errors["credentials" as keyof typeof form.errors] && (
                <div className="mt-6 rounded bg-red-100 px-4 py-3 text-red-700">
                  {form.errors["credentials" as keyof typeof form.errors]}
                </div>
              )}

              <div className="mt-6 grid gap-6">
                <FieldGroup label="Email" name="email">
                  <TextInput
                    name="email"
                    type="email"
                    value={form.data.email}
                    onChange={(e) => {
                      form.clearErrors()
                      form.setData("email", e.target.value)
                    }}
                  />
                </FieldGroup>

                <FieldGroup label="Password" name="password">
                  <TextInput
                    name="password"
                    type="password"
                    value={form.data.password}
                    onChange={(e) => {
                      form.clearErrors()
                      form.setData("password", e.target.value)
                    }}
                  />
                </FieldGroup>
              </div>
            </div>
            <div className="flex items-center justify-end border-t border-gray-200 bg-gray-100 px-10 py-4">
              <LoadingButton type="submit" loading={form.processing} className="btn">
                Login
              </LoadingButton>
            </div>
          </form>
        </div>
      </div>
    </>
  )
}
