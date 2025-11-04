import { UserCompact, PaginationMeta } from "@/types"

import { Link } from "@inertiajs/react"
import MainLayout from "@/layouts/MainLayout"
import SearchBar from "@/components/SearchBar"
import Table from "@/components/Table"
import Pagination from "@/components/Pagination"
import { Trash2 } from "lucide-react"

interface Props {
  users: UserCompact[]
  pagination_meta: PaginationMeta
}

function Index({ users, pagination_meta }: Props) {
  return (
    <div>
      <h1 className="mb-8 text-3xl font-bold">Users</h1>
      <div className="mb-6 flex items-center justify-between">
        <SearchBar filters={["role", "status"]} />
        <Link className="btn focus:outline-none" href="/users/new">
          <span>Create</span>
          <span className="hidden md:inline"> User</span>
        </Link>
      </div>
      <Table
        columns={[
          {
            label: "Name",
            name: "name",
            renderCell: (row) => (
              <>
                {row.photo && (
                  <img
                    src={row.photo}
                    alt={row.full_name}
                    className="mr-2 h-5 w-5 rounded-full"
                  />
                )}
                <span>{row.full_name}</span>
                {row.deleted_at && <Trash2 size={16} className="ml-2 text-gray-400" />}
              </>
            ),
          },
          {
            label: "Email",
            name: "email",
          },
          {
            label: "Role",
            name: "role",
            colSpan: 2,
            renderCell: (row) => ({ owner: "Owner", user: "User" })[row.role],
          },
        ]}
        rows={users}
        getRowDetailsUrl={(row) => `/users/${row.id}/edit`}
      />
      <Pagination {...pagination_meta} />
    </div>
  )
}

Index.layout = (page: React.ReactNode) => <MainLayout title="Users" children={page} />

export default Index
