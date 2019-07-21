import React from 'react'
import { Grid, makeStyles } from '@material-ui/core';
import CircularProgress from '@material-ui/core/CircularProgress';

const useStyles = makeStyles(theme => ({
  container: {
    minHeight: 300
  }
}));

export default function LoadingContainer() {
  const classes = useStyles()
  return (
    <Grid justify='center' alignItems='center' className={classes.container} container>
      <CircularProgress />
    </Grid>
  )
}