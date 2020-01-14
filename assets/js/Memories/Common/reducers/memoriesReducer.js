import * as actions from '../actions/memoriesActions'
import { createReducer } from 'redux-starter-kit';

const initialState = {
  memory: {
    id: null,
    title: '',
    description: '',
    tags: []
  },
  loading: false
}

const reducer = createReducer(initialState, {
  [actions.getMemorySuccess]: (state, { payload }) => {
    state.loading = false
    state.memory = payload
  },
  [actions.editMemory]: (state, { payload }) => {
    state.memory = { ...state.memory, ...payload }
  },
  [actions.memoryLoading]: (state) => {
    state.loading = true
  }
})

export default reducer