import { createAction } from 'redux-starter-kit'
import { getMemory as getMemoryApiCall } from '../API'
import { loadFragments } from './fragmentsActions'

export const createMemory = createAction('memories/create')
export const editMemory = createAction('memories/edit')
export const memoryLoading = createAction('memories/loading')
export const memoryError = createAction('memories/error')
export const getMemorySuccess = createAction('memories/get/success')

export const getMemory = memoryId => dispatch => {
  dispatch(memoryLoading())
  getMemoryApiCall(memoryId)
    .then(({ data: { fragments, ...memory } }) => {
      dispatch(getMemorySuccess(memory))
      dispatch(loadFragments(fragments))
    })
    .catch(console.error)
}