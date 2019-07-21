import React, { useState, useEffect } from 'react'
import ReactDOM from 'react-dom'

import MemoryForm from '../../Common/Components/Form'
import LoadingContainer from '../../Common/Components/LoadingContainer'
import { getMemory, updateMemory } from '../../Common/API'

function App({ memoryId }) {
  const [memory, setMemory] = useState(null)

  useEffect(() => {
    getMemory(memoryId)
      .then(({ data: memory }) => setMemory(memory))
  }, [])

  return (
    memory ?
      <MemoryForm onSubmit={updateMemory} memory={memory}/> :
      <LoadingContainer/>
  )
}

const root = document.getElementById('root')
const memoryId = root.dataset.memoryId
ReactDOM.render(<App memoryId={memoryId}/>, root)
