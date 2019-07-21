export default repository => memory => {
  return repository.post('/memories', { memory })
}