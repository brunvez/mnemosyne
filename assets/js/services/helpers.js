import { INVALID_ENTITY, UNAUTHORIZED } from './errorReasons'

function isEmptyObject(object) {
  return Object.keys(object).length === 0 
          && object.constructor === Object
}

function isEmptyString(string) {
  return string === '' || string === null;
}

function formatError(reason, payload) {
  return { payload, reason }
}

function httpStatusToReason(errorCode) {
  switch(errorCode) {
    case 422: return INVALID_ENTITY;
    case 401: return UNAUTHORIZED;
    default: return null
  }
}

export {
  formatError,
  httpStatusToReason,
  isEmptyObject,
  isEmptyString
}
