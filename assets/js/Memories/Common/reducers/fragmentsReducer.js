import * as actions from '../actions/fragmentsActions'
import { createReducer } from 'redux-starter-kit';

const initialState = []

const reducer = createReducer(initialState, {
  [actions.addFragment]: (state, { payload: fragment }) => {
    state.push(fragment)
  },
  [actions.editFragment]: (state, { payload }) => {
    const { identifier, attributes } = payload
    const fragment = state.find(fragment => fragment.identifier === identifier)
    fragment.attributes = { ...fragment.attributes, ...attributes }
  },
  [actions.removeFragment]: (state, { payload: { identifier } }) => {
    return state.filter(fragment => fragment.identifier !== identifier)
  },
  [actions.loadFragments]: (_state, { payload: fragments }) => (
    fragments.map(({ type, ...attributes }, index) => (
      {
        identifier: index,
        attributes,
        type,
      }
    ))
  ),
})

export default reducer