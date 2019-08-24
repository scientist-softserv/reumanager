import React from 'react'
import ReactDOM from 'react-dom'
import ApplicationForm from './components/application_form'


document.addEventListener('DOMContentLoaded', () => {
  var mount = document.querySelector('#applicationForm')
  if (mount) { ReactDOM.render(<ApplicationForm />, mount) }
})
