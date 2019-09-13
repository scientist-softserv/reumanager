/* eslint-disable no-unused-vars */

function formReducer(state, action) {
  var initial, newState, obj = {}
  switch(action.type) {
    case 'update':
      obj[action.key] = action.data
      newState = {
        ...state,
        formData: {
          ...state.formData,
          ...obj
        }
      }
      break;
    case 'updateWithIndex':
      initial = state.formData[action.key] || []
      obj[action.key] = replaceItemInArray(initial, action)
      newState = {
        ...state,
        formData: {
          ...state.formData,
          ...obj
        }
      }
      break;
    case 'new':
      initial = state.formData[action.key] || []
      obj[action.key] = [...initial, action.data]
      newState = {
        ...state,
        formData: {
          ...state.formData,
          ...obj
        }
      }
      break;
    case 'remove':
      initial = state.formData[action.key] || []
      obj[action.key] = removeItem(initial, action)
      newState = {
        ...state,
        formData: {
          ...state.formData,
          ...obj
        }
      }
      break;
    case 'save':
      break;
    default:
      throw new Error('invalid action')
  }
  // console.log(action, state, newState)
  return newState
}

function replaceItemInArray(array, action) {
  return array.map((item, index) => {
    if (index !== action.index) {
      return item
    }
    return action.data
  })
}

function updateObjectInArray(array, action) {
  return array.map((item, index) => {
    if (index !== action.index) {
      // This isn't the item we care about - keep it as-is
      return item
    }
    // Otherwise, this is the one we want - return an updated value
    return {
      ...item,
      ...action.data
    }
  })
}

function insertItem(array, action) {
  return [
      ...array.slice(0, action.index),
      action.data,
      ...array.slice(action.index)
    ]
}

function removeItem(array, action) {
  return [
    ...array.slice(0, action.index),
    ...array.slice(action.index + 1)
  ]
}

export default formReducer
