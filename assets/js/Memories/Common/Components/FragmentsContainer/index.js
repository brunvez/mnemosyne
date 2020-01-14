import React, { Fragment } from 'react'
import { connect } from 'react-redux';

import FragmentSelect from './FragmentSelect'
import FragmentWrapper from '../Fragments/FragmentWrapper'
import LinkFragment from '../Fragments/Link'
import { addFragment, editFragment, removeFragment } from '../../actions/fragmentsActions'

let latestIdentifier = 0

function FragmentsContainer({ addFragment, editFragment, removeFragment, fragments }) {
  const addNewFragment = (fragment) => {
    addFragment({ ...fragment, identifier: latestIdentifier,  })
    ++latestIdentifier
  }

  const renderFragments = () => {
    return fragments.map((fragment, index) => {
      return (
        <FragmentWrapper key={index} removeFragment={removeFragment(fragment.identifier)}>
          {renderFragment(fragment)}
        </FragmentWrapper>
      );
    })
  }

  const renderFragment = fragment => {
    const { type, attributes, identifier } = fragment
    switch (type) {
      case 'link':
        return renderLink({
          ...attributes,
          editFragment: editFragment(identifier)
        })
      default:
        console.error(`Invalid fragment type ${type}`)
    }
  }

  const renderLink = attributes => {
    return (
      <LinkFragment
        {...attributes}
      />
    )
  }

  return (
    <Fragment>
      <FragmentSelect onFragmentSelected={addNewFragment}/>
      {renderFragments()}
    </Fragment>
  )
}

const mapStateToProps = ({ fragments }) => ({ fragments })
const mapDispatchToProps = dispatch => {
  return {
    addFragment: fragment => dispatch(addFragment(fragment)),
    editFragment: identifier => attributes => dispatch(editFragment({ identifier, attributes })),
    removeFragment: identifier => () => dispatch(removeFragment({ identifier }))
  }
}

export default connect(mapStateToProps, mapDispatchToProps)(FragmentsContainer)