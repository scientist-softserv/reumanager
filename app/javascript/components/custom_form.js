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
  var [serverErr, setServerErr] = useState(null)


  var saveFail = (res) => {
    var message
    if (res.message) {
      message = `An Error occured on the server, please pass this message to support: "${res.message}"`
    } else {
      message = 'There was an error saving your information, please try again.  If this error persists, contact support'
    }
    setServerErr(message)
    window.scrollTo({ top: 0, behavior: 'smooth' })
  }

  var onFormSubmit = () => {
    saveData({
      path: path,
      method: method,
      data: { data: state.formData },
      success: (res) => {
        if (res.success) {
          setMsg({ msg: res.message, type: 'success' })
        } else if (res.errors) {
          setMsg({ msg: `${res.message} -- ${res.errors.join(', ')}`, type: 'warning' })
        } else {
          saveFail(res)
        }
        window.scrollTo({ top: 0, behavior: 'smooth' })
      },
      fail: saveFail
    })
  }

  var onFormError = (data) => {
    console.log('Error', data)
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
      <p className="instructions">Be sure to Save Application before navigating away from the current page</p>
      {serverErr ? <div className="alert alert-danger server-error" >{serverErr}</div> : null}
      {msg.msg ? <div className={`app-messages alert alert-${msg.type}`}>{msg.msg}</div> : null}
      {renderSectionForms()}
      <button className="btn btn-info" onClick={onFormSubmit}>Save Application</button>
    </div>
  )
}

export default CustomForm
