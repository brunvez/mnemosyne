import { createAction } from 'redux-starter-kit'

export const addFragment = createAction('fragments/add')
export const editFragment = createAction('fragments/edit')
export const removeFragment = createAction('fragments/remove')
export const loadFragments = createAction('fragments/load')
