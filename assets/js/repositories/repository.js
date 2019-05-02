import axios from 'axios';
import { camelizeKeys, decamelizeKeys } from 'humps';

const baseDomain = 'http://localhost:4000';
const baseURL = `${baseDomain}/api/v1`;

export default axios.create({
  baseURL,
  transformResponse: [
    ...axios.defaults.transformResponse,
    data => camelizeKeys(data)
  ],
  transformRequest: [
    data => decamelizeKeys(data),
    ...axios.defaults.transformRequest
  ]
});
