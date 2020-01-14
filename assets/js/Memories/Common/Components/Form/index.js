import React, { useState } from 'react'
import { connect } from 'react-redux'
import alertify from 'alertifyjs'
import { makeStyles } from '@material-ui/core/styles'
import TextField from '@material-ui/core/TextField'
import Button from '@material-ui/core/Button'
import FragmentsContainer from '../FragmentsContainer'
import DescriptionInput from './DescriptionInput'
import TagsInput from './TagsInput'
import { editMemory } from '../../actions/memoriesActions';

const useStyles = makeStyles(theme => ({
  container: {
    display: 'flex',
    flexWrap: 'wrap'
  },
  textField: {
    marginLeft: theme.spacing(1),
    marginRight: theme.spacing(1),
    width: '100%'
  }
}));

function Form({ onSubmit, memory, editMemory, fragments }) {
  const classes = useStyles()
  const setTitle = title => editMemory({ title })
  const setDescription = description => editMemory({ description })
  const setTags = tags => editMemory({ tags: tags })
  const addTag = tag => setTags([...memory.tags, tag])
  const removeTag = tagIndex => {
    const newTags = [
      ...memory.tags.filter((_, index) => index < tagIndex),
      ...memory.tags.filter((_, index) => index > tagIndex)
    ]
    setTags(newTags)
  }

  const handleChange = setter => event => {
    setter(event.target.value)
  }

  const triggerSubmit = () => {
    const memoryParams = {
      ...memory,
      fragments: fragments.map(({ identifier, ...params }) => params)
    }
    onSubmit(memoryParams)
      .then(redirectToMemoryUrl)
      .catch(showErrors)
  }

  const showErrors = ({ errors }) => {
    Object.keys(errors).forEach(errorAttribute => {
      alertify.error(`${errorAttribute} ${errors[errorAttribute][0]}`)
    })
  }

  const redirectToMemoryUrl = ({ memoryUrl }) => {
    window.location.replace(memoryUrl)
  }

  return (
    <form className={classes.container} noValidate autoComplete="off">
      <TextField
        label='Title'
        value={memory.title}
        onChange={handleChange(setTitle)}
        className={classes.textField}
        margin='normal'
      />
      <DescriptionInput
        value={memory.description}
        setValue={setDescription}
      />
      <FragmentsContainer
      />
      <TagsInput
        tags={memory.tags}
        addTag={addTag}
        removeTag={removeTag}
      />
      <Button
        onClick={triggerSubmit}
        variant='contained'
        color='primary'
        fullWidth
      >
        Submit
      </Button>
    </form>
  )
}

const mapStateToProps = ({ memories: state, fragments }) => {
  return {
    fragments,
    memory: state.memory
  }
}

const mapDispatchToProps = dispatch => {
  return {
    editMemory: changes => dispatch(editMemory(changes))
  }
}

export default connect(mapStateToProps, mapDispatchToProps)(Form)