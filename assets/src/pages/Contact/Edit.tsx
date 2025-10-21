import { ContactEdit, OrgName } from "@/types"

import { Head, Link, useForm, router } from "@inertiajs/react"
import MainLayout from "@/layouts/MainLayout"
import FieldGroup from "@/components/form/FieldGroup"
import TextInput from "@/components/form/TextInput"
import SelectInput from "@/components/form/SelectInput"
import LoadingButton from "@/components/button/LoadingButton"
import DeleteButton from "@/components/button/DeleteButton"
import TrashedMessage from "@/components/message/TrashedMessage"

interface EditProps {
  contact: ContactEdit
  org_names: OrgName[]
}

function Edit({ contact, org_names }: EditProps) {
  const form = useForm({
    first_name: contact.first_name || "",
    last_name: contact.last_name || "",
    org_id: contact.org_id || "",
    email: contact.email || "",
    phone: contact.phone || "",
    address: contact.address || "",
    city: contact.city || "",
    region: contact.region || "",
    country: contact.country || "",
    postal_code: contact.postal_code || "",
  })

  const { data, setData, errors, processing } = form

  function handleSubmit(e: React.FormEvent<HTMLFormElement>) {
    e.preventDefault()
    form.submit("put", `/contacts/${contact.id}`)
  }

  function destroy() {
    if (confirm("Are you sure you want to delete this contact?")) {
      router.delete(`/contacts/${contact.id}`)
    }
  }

  function restore() {
    if (confirm("Are you sure you want to restore this contact?")) {
      router.put(`/contacts/${contact.id}/restore`)
    }
  }

  return (
    <div>
      <Head title={contact.full_name} />
      <h1 className="mb-8 text-3xl font-bold">
        <Link href="/contacts" className="text-indigo-600 hover:text-indigo-700">
          Contacts
        </Link>{" "}
        <span className="mx-2 font-medium text-indigo-600">/</span>
        {contact.full_name}
      </h1>
      {contact.deleted_at && (
        <TrashedMessage message="This contact has been deleted." onRestore={restore} />
      )}
      <div className="max-w-3xl overflow-hidden rounded bg-white shadow">
        <form onSubmit={handleSubmit}>
          <div className="grid gap-8 p-8 lg:grid-cols-2">
            <FieldGroup label="First Name" name="first_name" error={errors.first_name}>
              <TextInput
                name="first_name"
                error={errors.first_name}
                value={data.first_name}
                onChange={(e) => setData("first_name", e.target.value)}
              />
            </FieldGroup>

            <FieldGroup label="Last Name" name="last_name" error={errors.last_name}>
              <TextInput
                name="last_name"
                error={errors.last_name}
                value={data.last_name}
                onChange={(e) => setData("last_name", e.target.value)}
              />
            </FieldGroup>

            <FieldGroup label="Organization" name="org_id" error={errors.org_id}>
              <SelectInput
                name="org_id"
                error={errors.org_id}
                value={data.org_id}
                onChange={(e) => setData("org_id", e.target.value)}
                options={[
                  { label: "", value: "" },
                  ...org_names.map((org) => ({ label: org.name, value: org.id })),
                ]}
              />
            </FieldGroup>

            <FieldGroup label="Email" name="email" error={errors.email}>
              <TextInput
                name="email"
                type="email"
                error={errors.email}
                value={data.email}
                onChange={(e) => setData("email", e.target.value)}
              />
            </FieldGroup>

            <FieldGroup label="Phone" name="phone" error={errors.phone}>
              <TextInput
                name="phone"
                error={errors.phone}
                value={data.phone}
                onChange={(e) => setData("phone", e.target.value)}
              />
            </FieldGroup>

            <FieldGroup label="Address" name="address" error={errors.address}>
              <TextInput
                name="address"
                error={errors.address}
                value={data.address}
                onChange={(e) => setData("address", e.target.value)}
              />
            </FieldGroup>

            <FieldGroup label="City" name="city" error={errors.city}>
              <TextInput
                name="city"
                error={errors.city}
                value={data.city}
                onChange={(e) => setData("city", e.target.value)}
              />
            </FieldGroup>

            <FieldGroup label="Province/State" name="region" error={errors.region}>
              <TextInput
                name="region"
                error={errors.region}
                value={data.region}
                onChange={(e) => setData("region", e.target.value)}
              />
            </FieldGroup>

            <FieldGroup label="Country" name="country" error={errors.country}>
              <SelectInput
                name="country"
                error={errors.country}
                value={data.country}
                onChange={(e) => setData("country", e.target.value)}
                options={[
                  { label: "", value: "" },
                  { label: "Canada", value: "CA" },
                  { label: "United States", value: "US" },
                ]}
              />
            </FieldGroup>

            <FieldGroup label="Postal Code" name="postal_code" error={errors.postal_code}>
              <TextInput
                name="postal_code"
                error={errors.postal_code}
                value={data.postal_code}
                onChange={(e) => setData("postal_code", e.target.value)}
              />
            </FieldGroup>
          </div>
          <div className="flex items-center border-t border-gray-100 bg-gray-50 px-8 py-4">
            {!contact.deleted_at && (
              <DeleteButton onDelete={destroy}>Delete Contact</DeleteButton>
            )}
            <LoadingButton loading={processing} type="submit" className="btn ml-auto">
              Update Contact
            </LoadingButton>
          </div>
        </form>
      </div>
    </div>
  )
}

Edit.layout = (page: React.ReactNode) => <MainLayout children={page} />

export default Edit
