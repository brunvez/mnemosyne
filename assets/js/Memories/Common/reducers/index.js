import { combineReducers } from 'redux-starter-kit'
import memories from './memoriesReducer'
import fragments from './fragmentsReducer'

export default combineReducers({
  memories,
  fragments
})