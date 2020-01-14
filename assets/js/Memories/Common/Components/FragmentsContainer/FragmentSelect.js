import React, { useState } from 'react'
import { makeStyles } from '@material-ui/core/styles';
import Grid from '@material-ui/core/Grid';
import FormControl from '@material-ui/core/FormControl';
import InputLabel from '@material-ui/core/InputLabel';
import Select from '@material-ui/core/Select';
import MenuItem from '@material-ui/core/MenuItem';
import Button from '@material-ui/core/Button';

const fragmentTypes = {
  link: 'Link'
}
const defaultFragment = Object.keys(fragmentTypes)[0]

const useStyles = makeStyles(theme => ({
  container: {
    margin: theme.spacing(1)
  },
  formControl: {
    margin: theme.spacing(1),
    width: '100%'
  },
  button: {
    margin: theme.spacing(1),
    width: '100%'
  }
}))

export default function FragmentSelect({ onFragmentSelected }) {
  const classes = useStyles()
  const [fragmentType, setFragmentType] = useState(defaultFragment)

  const handleChange = setter => event => {
    setter(event.target.value)
  }

  const fragmentItems = () => {
    return Object.keys(fragmentTypes).map(function (value, index) {
      return (
        <MenuItem
          key={index}
          value={value}>
          {fragmentTypes[value]}
        </MenuItem>
      )
    });
  }

  const handleSelection = () => {
    const fragment = buildFragment(fragmentType)
    onFragmentSelected(fragment)
    setFragmentType(defaultFragment)
  }

  const buildFragment = (type) => {
    switch (type) {
      case 'link':
        return buildLink()
      default:
        console.error(`Invalid fragment type ${type}`)
    }
  }

  const buildLink = () => {
    return {
      type: 'link',
      attributes: {}
    }
  }

  return (
    <Grid
      className={classes.container}
      justify='flex-end'
      container
    >
      <Grid lg={2} xs={12} item>
        <FormControl className={classes.formControl}>
          <InputLabel>Fragment Type</InputLabel>
          <Select
            value={fragmentType}
            onChange={handleChange(setFragmentType)}
            displayEmpty
          >
            {fragmentItems()}
          </Select>
        </FormControl>
      </Grid>
      <Grid lg={2} xs={12} item>
        <Button
          className={classes.button}
          variant='contained'
          onClick={handleSelection}
        >
          Add Fragment
        </Button>
      </Grid>
    </Grid>
  )
}