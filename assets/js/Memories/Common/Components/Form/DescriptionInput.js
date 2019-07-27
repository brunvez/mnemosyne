import React from 'react'
import SimpleMDE from 'react-simplemde-editor'
import FormControl from '@material-ui/core/FormControl';
import { makeStyles } from '@material-ui/core';

const useStyles = makeStyles(theme => ({
  container: {
    margin: theme.spacing(1)
  }
}));

export default function DescriptionInput({ value, setValue }) {
  const classes = useStyles()

  return (
    <React.Fragment>
      <FormControl
        className={classes.container}
        fullWidth
      >
        <SimpleMDE
          label='Description'
          value={value}
          onChange={setValue}
          options={{
            toolbar: false,
            status: false,
            spellChecker: false
          }}
        />
      </FormControl>
    </React.Fragment>
  )
}