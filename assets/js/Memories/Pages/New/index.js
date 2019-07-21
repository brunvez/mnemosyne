import React from 'react'
import ReactDOM from 'react-dom'

import MemoryForm from '../../Common/Components/Form'
import { createMemory } from '../../Common/API'

function App() {
  return (
    <MemoryForm onSubmit={createMemory}/>
  )
}

const root = document.getElementById('root')
ReactDOM.render(<App/>, root)
