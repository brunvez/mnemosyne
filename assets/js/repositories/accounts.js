import repository from './repository';

const resource = '/users';

export default {
  createAccount(payload) {
    return repository.post(resource, payload);
  }
}
