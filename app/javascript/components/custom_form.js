import React, { useState, useReducer } from 'react'
import SectionForm from './section_form'
// import { debounce } from '../shared/debounce'
import { saveData } from '../shared/save_data'
import RepeatingSectionForm from './repeating_section_form'
import formReducer from '../reducers/form_reducer'

// const saveForm = debounce(saveData, 3000)

function CustomForm({sections, formData, path, method}) {
  var initialState = { formData: formData || {}, path, method }
  var [state, dispatch] = useReducer(formReducer, initialState)
  var [msg, setMsg] = useState({ msg: null, type: '' })

  var onFormSubmit = () => {
    saveData({
      path: path,
      method: method,
      data: { data: state.formData },
      success: (res) => {
        if (res.success) {
          setMsg({ msg: res.message, type: 'success' })
        } else {
          setMsg({ msg: `${res.message} -- ${res.errors.join(', ')}`, type: 'danger' })
        }
        window.scrollTo({ top: 0, behavior: 'smooth' })
      },
      fail: (res) => {
        var message = res.message ? res.message : 'There was an error saving your information'
        setMsg({ msg: message, type: 'danger' })
        window.scrollTo({ top: 0, behavior: 'smooth' })
      }
    })
  }
  var onFormError = (data) => {
    console.log('Error', data)
  }
  var renderMessage = () => {
    if (msg.msg) {
      return (
        <div className={'alert alert-' + msg.type} >
          {msg.msg}
        </div>
      )
    } else {
      return null
    }
  }
  var renderSectionForms = () => {
    return sections.map((section) => {
      if (section.isRepeating) {
        return (
          <RepeatingSectionForm key={section.id}
            section={section}
            dispatch={dispatch}
            data={state.formData[section.key]}
            onFormError={onFormError} />
        )
      } else {
        return (
          <SectionForm key={section.id}
            section={section}
            data={state.formData[section.key]}
            dispatch={dispatch}
            onFormError={onFormError} />
        )
      }
    })
  }

  return (
    <div>
      {renderMessage()}
      {renderSectionForms()}
      <button className="btn btn-info" onClick={onFormSubmit}>Submit</button>
    </div>
  )
}

export default CustomForm
