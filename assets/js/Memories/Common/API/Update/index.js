export default repository => ({ id, ...memory}) => {
  return repository.put(`/memories/${id}`, { memory })
}