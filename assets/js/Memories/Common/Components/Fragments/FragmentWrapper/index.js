import React from 'react'
import Grid from '@material-ui/core/Grid';
import DeleteIcon from '@material-ui/icons/Delete'
import Button from '@material-ui/core/Button';
import Paper from '@material-ui/core/Paper';
import { makeStyles } from '@material-ui/core';

const useStyles = makeStyles(theme => ({
  container: {
    padding: theme.spacing(3, 2),
    marginBottom: theme.spacing(3),
    width: '100%'
  },
  button: {
    margin: theme.spacing(1)
  },
  rightIcon: {
    marginLeft: theme.spacing(1)
  }
}))

export default function FragmentWrapper({ children, removeFragment }) {
  const classes = useStyles()

  return (
    <Paper className={classes.container}>
      <Grid
        justify='flex-end'
        container
      >
        <Button
          variant="contained"
          color="secondary"
          className={classes.button}
          onClick={removeFragment}
        >
          Delete
          <DeleteIcon className={classes.rightIcon}/>
        </Button>
      </Grid>
      {children}
    </Paper>
  )
}