import { OrgEdit } from "@/types"

import { Head, Link, useForm, router } from "@inertiajs/react"
import MainLayout from "@/layouts/MainLayout"
import FieldGroup from "@/components/form/FieldGroup"
import TextInput from "@/components/form/TextInput"
import SelectInput from "@/components/form/SelectInput"
import Table from "@/components/Table"
import LoadingButton from "@/components/button/LoadingButton"
import DeleteButton from "@/components/button/DeleteButton"
import TrashedMessage from "@/components/message/TrashedMessage"

interface Props {
  org: OrgEdit
}

function Edit({ org }: Props) {
  const form = useForm({
    name: org.name || "",
    email: org.email || "",
    phone: org.phone || "",
    address: org.address || "",
    city: org.city || "",
    region: org.region || "",
    country: org.country || "",
    postal_code: org.postal_code || "",
  })

  function handleSubmit(e: React.FormEvent<HTMLFormElement>) {
    e.preventDefault()
    form.submit("put", `/orgs/${org.id}`)
  }

  function delete_() {
    if (confirm("Are you sure you want to delete this organization?")) {
      router.delete(`/orgs/${org.id}`)
    }
  }

  function restore() {
    if (confirm("Are you sure you want to restore this organization?")) {
      router.put(`/orgs/${org.id}/restore`)
    }
  }

  return (
    <div>
      <Head title={org.name} />
      <h1 className="mb-8 text-3xl font-bold">
        <Link href="/orgs" className="text-indigo-600 hover:text-indigo-700">
          Organizations
        </Link>{" "}
        <span className="font-medium text-indigo-600">/</span> {org.name}
      </h1>
      {org.deleted_at && (
        <TrashedMessage message="This organization has been deleted." onRestore={restore} />
      )}
      <div className="max-w-3xl overflow-hidden rounded bg-white shadow">
        <form onSubmit={handleSubmit}>
          <div className="grid gap-8 p-8 lg:grid-cols-2">
            <FieldGroup label="Name" name="name" error={form.errors.name}>
              <TextInput
                name="name"
                error={form.errors.name}
                value={form.data.name}
                onChange={(e) => form.setData("name", e.target.value)}
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

            <FieldGroup label="Phone" name="phone" error={form.errors.phone}>
              <TextInput
                name="phone"
                error={form.errors.phone}
                value={form.data.phone}
                onChange={(e) => form.setData("phone", e.target.value)}
              />
            </FieldGroup>

            <FieldGroup label="Address" name="address" error={form.errors.address}>
              <TextInput
                name="address"
                error={form.errors.address}
                value={form.data.address}
                onChange={(e) => form.setData("address", e.target.value)}
              />
            </FieldGroup>

            <FieldGroup label="City" name="city" error={form.errors.city}>
              <TextInput
                name="city"
                error={form.errors.city}
                value={form.data.city}
                onChange={(e) => form.setData("city", e.target.value)}
              />
            </FieldGroup>

            <FieldGroup label="Province/State" name="region" error={form.errors.region}>
              <TextInput
                name="region"
                error={form.errors.region}
                value={form.data.region}
                onChange={(e) => form.setData("region", e.target.value)}
              />
            </FieldGroup>

            <FieldGroup label="Country" name="country" error={form.errors.country}>
              <SelectInput
                name="country"
                error={form.errors.country}
                value={form.data.country}
                onChange={(e) => form.setData("country", e.target.value)}
                options={[
                  {
                    value: "",
                    label: "",
                  },
                  {
                    value: "CA",
                    label: "Canada",
                  },
                  {
                    value: "US",
                    label: "United States",
                  },
                ]}
              />{" "}
            </FieldGroup>

            <FieldGroup label="Postal Code" name="postal_code" error={form.errors.postal_code}>
              <TextInput
                name="postal_code"
                error={form.errors.postal_code}
                value={form.data.postal_code}
                onChange={(e) => form.setData("postal_code", e.target.value)}
              />
            </FieldGroup>
          </div>
          <div className="flex items-center border-t border-gray-200 bg-gray-100 px-8 py-4">
            {!org.deleted_at && (
              <DeleteButton onDelete={delete_}>Delete Organization</DeleteButton>
            )}
            <LoadingButton loading={form.processing} type="submit" className="btn ml-auto">
              Update Organization
            </LoadingButton>
          </div>
        </form>
      </div>
      <h2 className="mt-12 mb-6 text-2xl font-bold">Contacts</h2>
      <Table
        columns={[
          { label: "Name", name: "full_name" },
          { label: "City", name: "city" },
          { label: "Phone", name: "phone", colSpan: 2 },
        ]}
        rows={org.contacts.data!}
        getRowDetailsUrl={(row) => `/contacts/${row.id}/edit`}
      />
    </div>
  )
}

Edit.layout = (page: React.ReactNode) => <MainLayout children={page} />

export default Edit
