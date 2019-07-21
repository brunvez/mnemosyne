import React, { useState } from 'react'
import { makeStyles } from '@material-ui/core/styles';
import TextField from '@material-ui/core/TextField';
import FragmentsContainer from '../FragmentsContainer'
import Button from '@material-ui/core/Button';

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

const emptyMemory = {
  id: null,
  title: '',
  description: '',
  tags: []
}

export default function Form({ onSubmit, memory = emptyMemory }) {
  const classes = useStyles()
  const [title, setTitle] = useState(memory.title)
  const [description, setDescription] = useState(memory.description || '')
  const [tags, setTags] = useState(memory.tags.join(','))
  const [errors, setErrors] = useState({
    title: false
  })

  const handleChange = setter => event => {
    setter(event.target.value)
  }

  const triggerSubmit = () => {
    const memoryParams = {
      id: memory.id,
      title,
      description,
      tags: tagsToArray(tags)
    }
    onSubmit(memoryParams)
      .then(redirectToMemoryUrl)
      .catch(showErrors)
  }

  const tagsToArray = tags => {
    return tags
      .split(',')
      .map(tag => tag.trim())
      .filter(tag => tag !== '')
  }

  const redirectToMemoryUrl = ({ memoryUrl }) => {
    window.location.replace(memoryUrl)
  }

  const showErrors = ({ errors: requestErrors }) => {
    const updatedErrors = Object.keys(errors).reduce((newErrors, errorKey) => {
      const error = requestErrors[errorKey] ? requestErrors[errorKey][0] : false
      return { ...newErrors, [errorKey]: error }
    }, {})
    setErrors(updatedErrors)
  }

  return (
    <form className={classes.container} noValidate autoComplete="off">
      <TextField
        label='Title'
        value={title}
        onChange={handleChange(setTitle)}
        className={classes.textField}
        margin='normal'
        helperText={errors.title}
        error={!!errors.title}
      />
      <TextField
        label='Description'
        value={description}
        onChange={handleChange(setDescription)}
        className={classes.textField}
        margin='normal'
        multiline
      />
      <FragmentsContainer/>
      <TextField
        label='Tags'
        value={tags}
        onChange={handleChange(setTags)}
        className={classes.textField}
        margin='normal'
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