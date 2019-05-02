import { accountsRepository } from 'Repositories';
import { INVALID_ENTITY } from './errorReasons';
import { updateKey } from 'Helpers/object';
import {
  formatError,
  isEmptyObject,
  httpStatusToReason,
  isEmptyString } from './helpers';

async function createAccount(email, password, passwordConfirmation) {
  const errors = validateInput(email, password, passwordConfirmation);
  if (errorsFound(errors)) {
    throw formatError(INVALID_ENTITY, errors);
  }
  const payload = createPayload(email, password, passwordConfirmation);
  try {
    const response = await accountsRepository.createAccount(payload);
    return response.data;
  } catch (error) {
    const reason = httpStatusToReason(error.response.status);
    throw formatError(reason, error.response.data.errors);
  }
}

function errorsFound(error) {
  return !isEmptyObject(error);
}

function validateInput(email, password, passwordConfirmation) {
  const errors = {}

  if(isEmptyString(email)) {
    errors['email'] = ["can't be blank"]
  }

  if(isEmptyString(password)) {
    errors['password'] = ["can't be blank"]
  }

  if(isEmptyString(passwordConfirmation)) {
    errors['passwordConfirmation'] = ["can't be blank"]
  }

  if(password != passwordConfirmation) {
    const errorMessage = "doesn't match password";
    updateKey(
      errors,
      'passwordConfirmation',
      [errorMessage],
      (prevErrors) => prevErrors.push(errorMessage)
    );
  }

  return errors;
}

function createPayload(email, password, passwordConfirmation) {
  return {
    user: {
      email,
      password,
      passwordConfirmation
    }
  }
}

export {
  createAccount
};
