import { UserEdit, UserRole } from "@/types"

import { Head, Link, useForm, router } from "@inertiajs/react"
import MainLayout from "@/layouts/MainLayout"
import FieldGroup from "@/components/form/FieldGroup"
import TextInput from "@/components/form/TextInput"
import SelectInput from "@/components/form/SelectInput"
import FileInput from "@/components/form/FileInput"
import TrashedMessage from "@/components/message/TrashedMessage"
import LoadingButton from "@/components/button/LoadingButton"
import DeleteButton from "@/components/button/DeleteButton"

interface EditProps {
  user: UserEdit
}

function Edit({ user }: EditProps) {
  const form = useForm({
    first_name: user.first_name || "",
    last_name: user.last_name || "",
    email: user.email || "",
    password: "",
    role: user.role,
    photo: "",
    _method: "put",
  })

  function handleSubmit(e: React.FormEvent<HTMLFormElement>) {
    e.preventDefault()
    form.submit("post", `/users/${user.id}`)
  }

  function delete_() {
    if (confirm("Are you sure you want to delete this user?")) {
      router.delete(`/users/${user.id}`)
    }
  }

  function restore() {
    if (confirm("Are you sure you want to restore this user?")) {
      router.put(`/users/${user.id}/restore`)
    }
  }

  return (
    <div>
      <Head title={user.full_name} />
      <div className="mb-8 flex max-w-lg justify-start">
        <h1 className="text-3xl font-bold">
          <Link href="/users" className="text-indigo-600 hover:text-indigo-700">
            Users
          </Link>{" "}
          <span className="font-medium text-indigo-600">/</span> {user.full_name}
        </h1>
        {user.photo && <img className="ml-4 block h-8 w-8 rounded-full" src={user.photo} />}
      </div>
      {user.deleted_at && (
        <TrashedMessage message="This user has been deleted." onRestore={restore} />
      )}
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
              <FileInput
                name="photo"
                accept="image/*"
                error={form.errors.photo}
                value={form.data.photo}
                onChange={(photo) => {
                  form.setData("photo", photo as unknown as string)
                }}
              />
            </FieldGroup>
          </div>
          <div className="flex items-center border-t border-gray-100 bg-gray-50 px-8 py-4">
            {!user.deleted_at && <DeleteButton onDelete={delete_}>Delete User</DeleteButton>}
            <LoadingButton loading={form.processing} type="submit" className="btn ml-auto">
              Update User
            </LoadingButton>
          </div>
        </form>
      </div>
    </div>
  )
}

Edit.layout = (page: React.ReactNode) => <MainLayout children={page} />

export default Edit
