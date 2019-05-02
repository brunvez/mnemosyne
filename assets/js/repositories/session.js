import repository from './repository';

const resource = '/session';

export default {
  createSession(payload) {
    return repository.post(resource, payload);
  }
}
