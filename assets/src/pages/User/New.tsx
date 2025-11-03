import { Link, useForm } from "@inertiajs/react"
import MainLayout from "@/layouts/MainLayout"
import FieldGroup from "@/components/form/FieldGroup"
import TextInput from "@/components/form/TextInput"
import SelectInput from "@/components/form/SelectInput"
import ImageInput from "@/components/form/ImageInput"
import LoadingButton from "@/components/button/LoadingButton"

function New() {
  const form = useForm({
    first_name: "",
    last_name: "",
    email: "",
    password: "",
    role: "user",
    photo: null as File | null,
  })

  function handleSubmit(e: React.FormEvent<HTMLFormElement>) {
    e.preventDefault()
    form.submit("post", "/users")
  }

  return (
    <div>
      <div>
        <h1 className="mb-8 text-3xl font-bold">
          <Link href="/users" className="text-indigo-600 hover:text-indigo-700">
            Users
          </Link>{" "}
          <span className="font-medium text-indigo-600">/</span> Create
        </h1>
      </div>
      <div className="max-w-3xl overflow-hidden rounded bg-white shadow">
        <form onSubmit={handleSubmit}>
          <div className="grid gap-8 p-8 lg:grid-cols-2">
            <FieldGroup label="First Name" name="first_name" error={form.errors.first_name}>
              <TextInput
                name="first_name"
                error={form.errors.first_name}
                value={form.data.first_name}
                onChange={(e) => form.setData("first_name", e.target.value)}
              />
            </FieldGroup>

            <FieldGroup label="Last Name" name="last_name" error={form.errors.last_name}>
              <TextInput
                name="last_name"
                error={form.errors.last_name}
                value={form.data.last_name}
                onChange={(e) => form.setData("last_name", e.target.value)}
              />
            </FieldGroup>

            <FieldGroup label="Email" name="email" error={form.errors.email}>
              <TextInput
                name="email"
                type="email"
                error={form.errors.email}
                value={form.data.email}
                onChange={(e) => form.setData("email", e.target.value)}
              />
            </FieldGroup>

            <FieldGroup label="Password" name="password" error={form.errors.password}>
              <TextInput
                name="password"
                type="password"
                error={form.errors.password}
                value={form.data.password}
                onChange={(e) => form.setData("password", e.target.value)}
              />
            </FieldGroup>

            <FieldGroup label="Role" name="role" error={form.errors.role}>
              <SelectInput
                name="role"
                error={form.errors.role}
                value={form.data.role}
                onChange={(e) => form.setData("role", e.target.value)}
                options={[
                  { label: "Owner", value: "owner" },
                  { label: "User", value: "user" },
                ]}
              />
            </FieldGroup>

            <FieldGroup label="Photo" name="photo" error={form.errors.photo}>
              <ImageInput
                name="photo"
                error={form.errors.photo}
                value={""}
                onChange={(file) => form.setData("photo", file)}
              />
            </FieldGroup>
          </div>
          <div className="flex items-center border-t border-gray-100 bg-gray-50 px-8 py-4">
            <LoadingButton loading={form.processing} type="submit" className="btn ml-auto">
              Create User
            </LoadingButton>
          </div>
        </form>
      </div>
    </div>
  )
}

New.layout = (page: React.ReactNode) => <MainLayout title="Create User" children={page} />

export default New
