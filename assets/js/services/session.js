import { sessionRepository } from 'Repositories';
import { INVALID_ENTITY } from './errorReasons';
import {
  formatError,
  isEmptyObject,
  httpStatusToReason,
  isEmptyString } from './helpers';

async function createSession(email, password) {
  const errors = validateInput(email, password);
  if (errorsFound(errors)) {
    throw formatError(INVALID_ENTITY, errors);
  }
  const payload = createPayload(email, password);
  try {
    const response = await sessionRepository.createSession(payload);
    return response.data;
  } catch (error) {
    const reason = httpStatusToReason(error.response.status);
    throw formatError(reason, error.response.data.errors);
  }
}

function errorsFound(error) {
  return !isEmptyObject(error);
}

function validateInput(email, password) {
  const errors = {}

  if(isEmptyString(email)) {
    errors['email'] = ["can't be blank"]
  }

  if(isEmptyString(password)) {
    errors['password'] = ["can't be blank"]
  }
  return errors;
}

function createPayload(email, password) {
  return {
    login: {
      email,
      password
    }
  }
}

export {
  createSession
};
