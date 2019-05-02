function updateKey(object, key, initialValue, callback) {
  if (key in object) {
    callback(object[key], object);
  } else {
    object[key] = initialValue;
  }
}

export {
  updateKey
}
