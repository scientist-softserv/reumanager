import React from 'react'
import ReactDOM from 'react-dom'
import Form from "react-jsonschema-form"
import { debounce } from '../shared/debounce'
import { saveData } from '../shared/save_data'

function setupDefaultState() {
  var dataEl = document.querySelector('.form-data')
  var s = {}
  s.schema = dataEl.dataset.schema ? JSON.parse(dataEl.dataset.schema) : {}
  s.ui = dataEl.dataset.ui ? JSON.parse(dataEl.dataset.ui) : {}
  s.formData = dataEl.dataset.data ? JSON.parse(dataEl.dataset.data) : {}
  s.path = dataEl.dataset.path ? dataEl.dataset.path : ''
  s.method = dataEl.dataset.method ? dataEl.dataset.method : 'patch'
  s.msg = null
  s.msgType = 'info'
  return s
}

class App extends React.Component {
  constructor(props) {
    super(props)
    var dataEl = document.querySelector('.form-data')
    this.state = setupDefaultState()
    console.log(this.state)
  }

  saveForm = saveData.bind(this)

  saveFormD = debounce(saveData.bind(this), 1000)

  onFormChange = (data) => { 
    this.setState({ formData: data.formData })
    this.saveFormD({ data: data.formData })
  }

  onFormSubmit = (data) => {
    this.setState({ formData: data.formData })
    this.saveForm({ data: data.formData })
  }

  onFormError = (data) => {
    console.log('Error', data)
  }

  renderMessage() {
    if (this.state.msg) {
      var classes = 'alert alert-' + this.state.msgType
      return <div className={classes}>{this.state.msg}</div>
    } else {
      return null
    }
  }

  render() {
    return (
      <div>
        {this.renderMessage()}
        <Form schema={this.state.schema}
              uiSchema={this.state.ui}
              formData={this.state.formData}
              onChange={this.onFormChange}
              onSubmit={this.onFormSubmit}
              onError={this.onFormSubmit} />
      </div>
    )
  }
}


document.addEventListener('DOMContentLoaded', () => {
  var mount = document.querySelector('#applicationForm')
  if (mount) { ReactDOM.render(<App />, mount) }
})
