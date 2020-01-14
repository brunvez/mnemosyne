import React from 'react'
import ReactDOM from 'react-dom'

import MemoryForm from '../../Common/Components/Form'
import { createMemory } from '../../Common/API'
import store from '../../Common/store';
import { Provider } from 'react-redux';

function App() {
  return (
    <MemoryForm onSubmit={createMemory}/>
  )
}

const root = document.getElementById('root')
ReactDOM.render(
  <Provider store={store}>
    <App/>
  </Provider>, root)
