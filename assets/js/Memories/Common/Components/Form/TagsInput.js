import React, { useState } from 'react'
import { makeStyles } from '@material-ui/core/styles'
import Chip from '@material-ui/core/Chip'
import Paper from '@material-ui/core/Paper'
import InputBase from '@material-ui/core/InputBase'

const useStyles = makeStyles(theme => ({
  root: {
    display: 'flex',
    flexWrap: 'wrap',
    width: '100%',
    padding: theme.spacing(0.5),
    margin: theme.spacing(3, 1)
  },
  chip: {
    margin: theme.spacing(0.5)
  },
  textField: {
    margin: theme.spacing(0, 1)
  }
}))

export default function TagsInput({ tags, addTag, removeTag }) {
  const classes = useStyles()
  const [currentTag, setCurrentTag] = useState('')

  const handleDelete = (tagIndex) => {
    return () => removeTag(tagIndex)
  }

  const renderTags = () => {
    return tags.map((tag, index) => {
      return (
        <Chip
          key={index}
          label={tag}
          onDelete={handleDelete(index)}
          className={classes.chip}
        />
      )
    })
  }

  const handleKeyPress = (event) => {
    if (event.key === 'Enter') {
      addTag(currentTag)
      setCurrentTag('')
    }
  }

  const handleChange = (event) => {
    const value = event.target.value
    setCurrentTag(value.replace(',', ''))
  }

  return (
    <Paper className={classes.root}>
      {renderTags()}
      <InputBase
        className={classes.textField}
        placeholder="New tag"
        value={currentTag}
        onChange={handleChange}
        onKeyPress={handleKeyPress}
      />
    </Paper>
  )
}