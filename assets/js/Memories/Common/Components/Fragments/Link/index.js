import React, { useState } from 'react'
import TextField from '@material-ui/core/TextField';
import { makeStyles } from '@material-ui/core';

const useStyles = makeStyles(theme => ({
  textField: {
    marginLeft: theme.spacing(1),
    marginRight: theme.spacing(1),
    width: '100%'
  }
}));

export default function Link({ editFragment, url, title }) {
  const classes = useStyles()
  const [localUrl, setLocalUrl] = useState(url || '')
  const [localTitle, setLocalTitle] = useState(title || '')

  const setUrl = url => {
    setLocalUrl(url)
    editFragment({ url })
  }
  const setTitle = title => {
    setLocalTitle(title)
    editFragment({ title })
  }
  const handleChange = setter => event => {
    setter(event.target.value)
  }

  return (
    <React.Fragment>
      <TextField
        label='Title'
        value={localTitle}
        onChange={handleChange(setTitle)}
        className={classes.textField}
        margin='normal'
      />
      <TextField
        label='URL'
        value={localUrl}
        onChange={handleChange(setUrl)}
        className={classes.textField}
        margin='normal'
      />
    </React.Fragment>
  )
}