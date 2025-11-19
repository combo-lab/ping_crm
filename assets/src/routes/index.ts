type PathParam = string | number

type Params = {
  [key: string]: string | number | boolean
}

function appendParams(url_or_path: string, params?: Params): string {
  return url_or_path
}

/* user_session_path */

export function user_session_path(action: ":show", params?: Params): string
export function user_session_path(action: ":create", params?: Params): string
export function user_session_path(action: ":delete", params?: Params): string
export function user_session_path(action: string, ...args: any[]): string {
  switch (action) {
    case ":show":
      return user_session_path_show(...args)

    case ":create":
      return user_session_path_create(...args)

    case ":delete":
      return user_session_path_delete(...args)

    default:
      throw `unknown action ${action}`
  }
}

function user_session_path_show(params = {}) {
  return appendParams("/login", params)
}

function user_session_path_create(params = {}) {
  return appendParams("/login", params)
}

function user_session_path_delete(params = {}) {
  return appendParams("/logout", params)
}

/* profile_path */

export function profile_path(action: ":edit", params?: Params): string
export function profile_path(action: ":update", params?: Params): string
export function profile_path(action: string, ...args: any[]): string {
  switch (action) {
    case ":edit":
      return profile_path_edit(...args)

    case ":update":
      return profile_path_update(...args)

    default:
      throw `unknown action ${action}`
  }
}

export function profile_path_edit(params = {}) {
  return appendParams("/profile", params)
}

export function profile_path_update(params = {}) {
  return appendParams("/profile", params)
}

/* dashboard_path */

export function dashboard_path(action: ":index", params?: Params): string
export function dashboard_path(action: string, ...args: any[]): string {
  switch (action) {
    case ":index":
      return dashboard_path_index(...args)

    default:
      throw `unknown action ${action}`
  }
}

export function dashboard_path_index(params = {}) {
  return appendParams("/", params)
}

/* user_path */

export function user_path(action: ":index", params?: Params): string
export function user_path(action: ":new", params?: Params): string
export function user_path(action: ":create", params?: Params): string
export function user_path(action: ":edit", id: PathParam, params?: Params): string
export function user_path(action: ":update", id: PathParam, params?: Params): string
export function user_path(action: ":delete", id: PathParam, params?: Params): string
export function user_path(action: ":restore", id: PathParam, params?: Params): string
export function user_path(action: string, ...args: any[]): string {
  switch (action) {
    case ":index":
      return user_path_index(...args)

    case ":new":
      return user_path_new(...args)

    case ":create":
      return user_path_create(...args)

    case ":edit":
      return user_path_edit(args[0], args[1])

    case ":update":
      return user_path_update(...(args as [PathParam, Params?]))

    case ":delete":
      return user_path_delete(...(args as [PathParam, Params?]))

    case ":restore":
      return user_path_restore(...(args as [PathParam, Params?]))

    default:
      throw `unknown action ${action}`
  }
}

function user_path_index(params?: Params) {
  return appendParams("/orgs", params)
}

function user_path_new(params?: Params) {
  return appendParams("/orgs/new", params)
}

function user_path_create(params?: Params) {
  return appendParams("/orgs", params)
}

function user_path_edit(id: PathParam, params?: Params) {
  return appendParams(`/orgs/${id}/edit`, params)
}

function user_path_update(id: PathParam, params?: Params) {
  return appendParams(`/orgs/${id}`, params)
}

function user_path_delete(id: PathParam, params?: Params) {
  return appendParams(`/orgs/${id}`, params)
}

function user_path_restore(id: PathParam, params?: Params) {
  return appendParams(`/orgs/${id}/restore`, params)
}

/* org_path */

export function org_path(action: ":index", params?: Params): string
export function org_path(action: ":new", params?: Params): string
export function org_path(action: ":create", params?: Params): string
export function org_path(action: ":edit", id: PathParam, params?: Params): string
export function org_path(action: ":update", id: PathParam, params?: Params): string
export function org_path(action: ":delete", id: PathParam, params?: Params): string
export function org_path(action: ":restore", id: PathParam, params?: Params): string
export function org_path(action: string, ...args: any[]): string {
  switch (action) {
    case ":index":
      return org_path_index(...args)

    case ":new":
      return org_path_new(...args)

    case ":create":
      return org_path_create(...args)

    case ":edit":
      return org_path_edit(args[0], args[1])

    case ":update":
      return org_path_update(...(args as [PathParam, Params?]))

    case ":delete":
      return org_path_delete(...(args as [PathParam, Params?]))

    case ":restore":
      return org_path_restore(...(args as [PathParam, Params?]))

    default:
      throw `unknown action ${action}`
  }
}

function org_path_index(params?: Params) {
  return appendParams("/orgs", params)
}

function org_path_new(params?: Params) {
  return appendParams("/orgs/new", params)
}

function org_path_create(params?: Params) {
  return appendParams("/orgs", params)
}

function org_path_edit(id: PathParam, params?: Params) {
  return appendParams(`/orgs/${id}/edit`, params)
}

function org_path_update(id: PathParam, params?: Params) {
  return appendParams(`/orgs/${id}`, params)
}

function org_path_delete(id: PathParam, params?: Params) {
  return appendParams(`/orgs/${id}`, params)
}

function org_path_restore(id: PathParam, params?: Params) {
  return appendParams(`/orgs/${id}/restore`, params)
}

/* contact_path */

export function contact_path(action: ":index", params?: Params): string
export function contact_path(action: ":new", params?: Params): string
export function contact_path(action: ":create", params?: Params): string
export function contact_path(action: ":edit", id: PathParam, params?: Params): string
export function contact_path(action: ":update", id: PathParam, params?: Params): string
export function contact_path(action: ":delete", id: PathParam, params?: Params): string
export function contact_path(action: ":restore", id: PathParam, params?: Params): string
export function contact_path(action: string, ...args: any[]): string {
  switch (action) {
    case ":index":
      return contact_path_index(...args)

    case ":new":
      return contact_path_new(...args)

    case ":create":
      return contact_path_create(...args)

    case ":edit":
      return contact_path_edit(args[0], args[1])

    case ":update":
      return contact_path_update(...(args as [PathParam, Params?]))

    case ":delete":
      return contact_path_delete(...(args as [PathParam, Params?]))

    case ":restore":
      return contact_path_restore(...(args as [PathParam, Params?]))

    default:
      throw `unknown action ${action}`
  }
}

function contact_path_index(params?: Params) {
  return appendParams("/orgs", params)
}

function contact_path_new(params?: Params) {
  return appendParams("/orgs/new", params)
}

function contact_path_create(params?: Params) {
  return appendParams("/orgs", params)
}

function contact_path_edit(id: PathParam, params?: Params) {
  return appendParams(`/orgs/${id}/edit`, params)
}

function contact_path_update(id: PathParam, params?: Params) {
  return appendParams(`/orgs/${id}`, params)
}

function contact_path_delete(id: PathParam, params?: Params) {
  return appendParams(`/orgs/${id}`, params)
}

function contact_path_restore(id: PathParam, params?: Params) {
  return appendParams(`/orgs/${id}/restore`, params)
}

/* report_path */

export function report_path(action: ":index", params?: Params): string
export function report_path(action: string, ...args: any[]): string {
  switch (action) {
    case ":index":
      return report_path_index(...args)

    default:
      throw `unknown action ${action}`
  }
}

function report_path_index(params?: Params) {
  return appendParams("/reports", params)
}
