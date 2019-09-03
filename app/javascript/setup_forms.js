import React from 'react'
import ReactDOM from 'react-dom'
import ApplicationForm from './components/application_form'

function setupDefaultState() {
  var dataEl = document.querySelector('.form-data')
  var s = {}
  s.sections = dataEl.dataset.schema ? JSON.parse(dataEl.dataset.schema).sections : {}
  s.formData = dataEl.dataset.data ? JSON.parse(dataEl.dataset.data) : {}
  s.path = dataEl.dataset.path ? dataEl.dataset.path : ''
  s.method = dataEl.dataset.method ? dataEl.dataset.method : 'patch'
  return s
}

document.addEventListener('DOMContentLoaded', () => {
  var mount = document.querySelector('#applicationForm')
  if (mount) {
    var initialState = setupDefaultState()
    ReactDOM.render((
      <ApplicationForm
        sections={initialState.sections}
        formData={initialState.formData}
        path={initialState.path}
        method={initialState.method}
      />
    ), mount) }
})
