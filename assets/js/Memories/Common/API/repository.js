import axios from 'axios'
import { camelizeKeys, decamelizeKeys } from 'humps'

const instance = axios.create({
  baseURL: '/api/v1',
  transformResponse: [
    ...axios.defaults.transformResponse,
    camelizeKeys
  ],
  transformRequest: [
    decamelizeKeys,
    ...axios.defaults.transformRequest
  ]
})
instance.interceptors.response.use(
  response => response.data,
  error => {
    if (error.response.status === 422) {
      return Promise.reject(error.response.data)
    } else {
      return Promise.reject(error);
    }
  })

export default instance
