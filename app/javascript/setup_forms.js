import React from 'react'
import ReactDOM from 'react-dom'
import ApplicationForm from './components/application_form'
import RecommenderForm from './components/recommender_form'

function setupDefaultState() {
  var dataEl = document.querySelector('.form-data')
  var s = {}
  s.sections = dataEl.dataset.schema ? JSON.parse(dataEl.dataset.schema).sections : {}
  s.formData = dataEl.dataset.data ? JSON.parse(dataEl.dataset.data) : {}
  s.path = dataEl.dataset.path ? dataEl.dataset.path : ''
  s.method = dataEl.dataset.method ? dataEl.dataset.method : 'patch'
  return s
}

var initialState

document.addEventListener('DOMContentLoaded', () => {
  var appMount = document.querySelector('#applicationForm')
  var recMount = document.querySelector('#recommenderForm')
  if (appMount) {
    initialState = setupDefaultState()
    ReactDOM.render((
      <ApplicationForm
        sections={initialState.sections}
        formData={initialState.formData}
        path={initialState.path}
        method={initialState.method}
      />
    ), appMount) }
  else if (recMount) {
    initialState = setupDefaultState()
    ReactDOM.render((
      <RecommenderForm
        sections={initialState.sections}
        formData={initialState.formData}
        path={initialState.path}
        method={initialState.method}
      />
    ), recMount) }
})
