export default repository => memoryId => {
  return repository.get(`/memories/${memoryId}`)
}