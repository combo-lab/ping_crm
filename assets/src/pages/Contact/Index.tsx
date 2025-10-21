import { ContactCompact, PaginationMeta } from "@/types"

import { Link } from "@inertiajs/react"
import MainLayout from "@/layouts/MainLayout"
import SearchBar from "@/components/SearchBar"
import Table from "@/components/Table"
import Pagination from "@/components/Pagination"
import { Trash2 } from "lucide-react"

interface IndexProps {
  contacts: ContactCompact[]
  pagination_meta: PaginationMeta
}

function Index({ contacts, pagination_meta }: IndexProps) {
  return (
    <div>
      <h1 className="mb-8 text-3xl font-bold">Contacts</h1>
      <div className="mb-6 flex items-center justify-between">
        <SearchBar filters={["status"]} />
        <Link className="btn focus:outline-none" href="/contacts/new">
          <span>Create</span>
          <span className="hidden md:inline"> Contact</span>
        </Link>
      </div>
      <Table
        columns={[
          {
            label: "Name",
            name: "name",
            renderCell: (row) => (
              <>
                {row.full_name}
                {row.deleted_at && <Trash2 size={16} className="ml-2 text-gray-400" />}
              </>
            ),
          },
          { label: "Organization", name: "org.data.name" },
          { label: "City", name: "city" },
          { label: "Phone", name: "phone", colSpan: 2 },
        ]}
        rows={contacts}
        getRowDetailsUrl={(row) => `/contacts/${row.id}/edit`}
      />
      <Pagination {...pagination_meta} />
    </div>
  )
}

Index.layout = (page: React.ReactNode) => <MainLayout title="Contacts" children={page} />

export default Index
