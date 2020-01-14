import React, { useEffect } from 'react'
import ReactDOM from 'react-dom'
import { Provider, connect } from 'react-redux'

import MemoryForm from '../../Common/Components/Form'
import LoadingContainer from '../../Common/Components/LoadingContainer'
import store from '../../Common/store'
import { getMemory } from '../../Common/actions/memoriesActions';
import { updateMemory } from '../../Common/API'

function App({ memoryId, getMemory, loading }) {
  useEffect(() => {
    getMemory(memoryId)
  }, [])

  return (
    loading ?
      <LoadingContainer/> :
      <MemoryForm onSubmit={updateMemory}/>
  )
}

const mapStateToProps = ({ memories: state }) => {
  return {
    loading: state.loading
  }
}

const mapDispatchToProps = dispatch => {
  return {
    getMemory: memoryId => {
      dispatch(getMemory(memoryId))
    }
  }
}
const ConnectedApp = connect(mapStateToProps, mapDispatchToProps)(App)

const root = document.getElementById('root')
const memoryId = root.dataset.memoryId
ReactDOM.render(
  <Provider store={store}>
    <ConnectedApp memoryId={memoryId}/>
  </Provider>, root)
