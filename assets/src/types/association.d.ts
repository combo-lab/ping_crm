export interface NotLoadedAssoc {
  loaded: false
  data: null
}

export interface LoadedAssoc<T> {
  loaded: true
  data: T | null
}

export type Assoc<T> = NotLoadedAssoc | LoadedAssoc<T>
