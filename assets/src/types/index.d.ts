import { LoadedAssoc } from "./association"

export type PageProps<T extends Record<string, unknown> = Record<string, unknown>> = T & {
  auth: {
    user: UserAuth
  }
  route: {
    path: string
  }
  flash: {
    info: string | null
    success: string | null
    error: string | null
    warning: string | null
  }
}

/* Accounts */

export interface Account {
  id: string
  name: string
}

/* Users */

interface UserAuth {
  id: string
  first_name: string
  last_name: string
  email: string
  role: UserRole
  account: LoadedAssoc<Account>
}

export interface UserCompact {
  id: string
  full_name: string
  email: string
  role: UserRole
  photo: string | null
  deleted_at: string | null
}

export interface UserEdit {
  id: string
  first_name: string
  last_name: string
  full_name: string
  email: string
  role: UserRole
  photo: string | null
  deleted_at: string | null
}

export type UserRole = "owner" | "user"

/* Orgs */

export interface OrgCompact {
  id: string
  name: string
  phone: string
  city: string
  deleted_at: string | null
}

export interface OrgEdit {
  id: string
  name: string
  email: string
  phone: string
  address: string
  city: string
  region: string
  country: string
  postal_code: string
  deleted_at: string | null
  contacts: LoadedAssoc<ContactAssoc[]>
}

export interface OrgAssoc {
  id: string
  name: string
}

export interface OrgName {
  id: string
  name: string
}

/* Contacts */

export interface ContactCompact {
  id: string
  full_name: string
  phone: string
  city: string
  deleted_at: string | null
  org: LoadedAssoc<OrgAssoc>
}

export interface ContactEdit {
  id: string
  first_name: string
  last_name: string
  full_name: string
  email: string
  phone: string
  address: string
  city: string
  region: string
  country: string
  postal_code: string
  deleted_at: string | null
  org_id: string | null
}

export interface ContactAssoc {
  id: string
  full_name: string
  phone: string
  city: string
}

/* Pagination */

export interface PaginationMeta {
  page: number
  page_size: number
  total_count: number
  total_pages: number
  has_prev_page: boolean
  has_next_page: boolean
}
