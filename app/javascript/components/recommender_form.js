import React, { useState, useReducer } from 'react'
import SectionForm from './section_form'
import { saveData } from '../shared/save_data'
import RepeatingSectionForm from './repeating_section_form'
import applicationFormReducer from '../reducers/application_form_reducer'


function RecommenderForm({sections, formData, path, method}) {
  var initialState = { formData: formData || {}, path, method }
  var [state, dispatch] = useReducer(applicationFormReducer, initialState)
  var [msg, setMsg] = useState({ msg: null, type: '' })

  var onFormSubmit = () => {
    saveData({
      path: path,
      method: method,
      data: { data: state.formData },
      success: () => {
        setMsg({ msg: 'successfully saved information', type: 'success' })
        setTimeout(() => {
          setMsg({ msg: null, type: '' })
        }, 5000)
      },
      fail: () => {
        setMsg({ msg: 'Failed to save information', type: 'danger' })
        setTimeout(() => {
          setMsg({ msg: null, type: '' })
        }, 5000)
      }
    })
  }
  var onFormError = (data) => {
    console.log('Error', data)
  }
  var renderMessage = () => {
    if (msg.msg) {
      var classes = 'alert alert-' + msg.type
      return (
        <div className={classes}
          style={{position: "fixed", top: '30px'}}>
          {msg.msg}
        </div>
      )
    } else {
      return null
    }
  }
  var renderSectionForms = () => {
    return sections.map((section, index) => {
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

export default RecommenderForm
