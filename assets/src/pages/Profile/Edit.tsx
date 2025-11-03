import { UserEdit, UserRole } from "@/types"

import { useForm } from "@inertiajs/react"
import MainLayout from "@/layouts/MainLayout"
import FieldGroup from "@/components/form/FieldGroup"
import TextInput from "@/components/form/TextInput"
import SelectInput from "@/components/form/SelectInput"
import ImageInput from "@/components/form/ImageInput"
import LoadingButton from "@/components/button/LoadingButton"

interface EditProps {
  user: UserEdit
}

const title = "Profile"

function Edit({ user }: EditProps) {
  const form = useForm({
    _method: "put",
    first_name: user.first_name || "",
    last_name: user.last_name || "",
    email: user.email || "",
    password: "",
    role: user.role,
    photo: null as File | null,
  })

  function handleSubmit(e: React.FormEvent<HTMLFormElement>) {
    e.preventDefault()
    form.submit("post", "/profile")
  }

  return (
    <>
      <div className="mb-8 flex max-w-lg justify-start">
        <h1 className="text-3xl font-bold">{title}</h1>
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
                placeholder="••••••••••••"
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
                onChange={(e) => form.setData("role", e.target.value as UserRole)}
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
                onChange={(file) => {
                  form.setData("photo", file)
                }}
              />
            </FieldGroup>
          </div>
          <div className="flex items-center border-t border-gray-100 bg-gray-50 px-8 py-4">
            <LoadingButton loading={form.processing} type="submit" className="btn ml-auto">
              Update
            </LoadingButton>
          </div>
        </form>
      </div>
    </>
  )
}

Edit.layout = (page: React.ReactNode) => <MainLayout title={title} children={page} />

export default Edit
