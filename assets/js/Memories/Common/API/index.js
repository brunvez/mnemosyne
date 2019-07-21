import repository from './repository'
import create from './Create'
import get from './Get'
import update from './Update'

export const createMemory = create(repository)
export const getMemory = get(repository)
export const updateMemory = update(repository)