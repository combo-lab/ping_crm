import { OrgName } from "@/types"

import { useForm, Link } from "@inertiajs/react"
import MainLayout from "@/layouts/MainLayout"
import FieldGroup from "@/components/form/FieldGroup"
import TextInput from "@/components/form/TextInput"
import SelectInput from "@/components/form/SelectInput"
import LoadingButton from "@/components/button/LoadingButton"

interface NewProps {
  org_names: OrgName[]
}

function New({ org_names }: NewProps) {
  const form = useForm({
    first_name: "",
    last_name: "",
    org_id: "",
    email: "",
    phone: "",
    address: "",
    city: "",
    region: "",
    country: "",
    postal_code: "",
  })

  function handleSubmit(e: React.FormEvent<HTMLFormElement>) {
    e.preventDefault()
    form.submit("post", "/contacts")
  }

  return (
    <div>
      <h1 className="mb-8 text-3xl font-bold">
        <Link href="/contacts" className="text-indigo-600 hover:text-indigo-700">
          Contacts
        </Link>{" "}
        <span className="font-medium text-indigo-600">/</span> Create
      </h1>
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

            <FieldGroup label="Organization" name="org_id" error={form.errors.org_id}>
              <SelectInput
                name="org_id"
                error={form.errors.org_id}
                value={form.data.org_id}
                onChange={(e) => form.setData("org_id", e.target.value)}
                options={[
                  { label: "", value: "" },
                  ...org_names.map(({ id, name }) => ({ label: name, value: id })),
                ]}
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
                  { label: "", value: "" },
                  { label: "Canada", value: "CA" },
                  { label: "United States", value: "US" },
                ]}
              />
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
          <div className="flex items-center border-t border-gray-100 bg-gray-50 px-8 py-4">
            <LoadingButton loading={form.processing} type="submit" className="btn ml-auto">
              Create Contact
            </LoadingButton>
          </div>
        </form>
      </div>
    </div>
  )
}

New.layout = (page: React.ReactNode) => <MainLayout title="Create Contact" children={page} />

export default New
