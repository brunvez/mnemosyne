import React, { Fragment, useState } from 'react'

import FragmentSelect from './FragmentSelect'
import LinkFragment from '../Fragments/Link'

export default function FragmentsContainer() {
  const [fragments, setFragments] = useState([])
  const addNewFragment = (fragment) => {
    console.log(fragment)
    setFragments([...fragments, fragment])
  }

  const renderFragments = () => {
    return fragments.map(renderFragment)
  }

  const renderFragment = (fragment, index) => {
    const { type, attributes } = fragment
    switch (type) {
      case 'link':
        return renderLink({ ...attributes, key: index })
      default:
        console.error(`Invalid fragment type ${type}`)
    }
  }

  const renderLink = attributes => {
    return (<LinkFragment {...attributes}/>)
  }

  return (
    <Fragment>
      <FragmentSelect onFragmentSelected={addNewFragment}/>
      {renderFragments()}
    </Fragment>
  )
}