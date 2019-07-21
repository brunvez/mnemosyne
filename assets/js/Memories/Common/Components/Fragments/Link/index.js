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

export default function Link({ url = '' }) {
  const classes = useStyles()
  const [localUrl, setUrl] = useState(url)

  const handleChange = setter => event => {
    setter(event.target.value)
  }

  return (
    <TextField
      label='Link Fragment'
      placeholder='URL'
      value={localUrl}
      onChange={handleChange(setUrl)}
      className={classes.textField}
      margin='normal'
    />
  )
}