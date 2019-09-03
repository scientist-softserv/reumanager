import React from 'react'
import SectionForm from './section_form'

function RepeatingSectionForm({ dispatch, section, data, ...props }) {
  var key = section.key
  var formData = data || []

  var handleAddForm = () => {
    dispatch({
      type: 'new',
      key: key,
      data: {}
    })
  }

  var removeForm = (index) => {
    return () => {
      dispatch({
        type: 'remove',
        key: key,
        index: index
      })
    }
  }

  var forms = formData.map((form, index) => {
    return (
      <div className="d-flex justify-content-between" key={index}>
        <SectionForm
          index={index}
          section={section}
          dispatch={dispatch}
          data={form}
          schema={section.schema}
          uiSchema={section.ui}
          onFormError={props.onFormError} />
        <button type="button" className="btn btn-danger btn-sm" style={{ height: '30px' }} onClick={removeForm(index)}>Remove</button>
      </div>
    )
  })

  return (
    <div className="repeating-section-form d-flex flex-column">
      <div className="d-flex justify-content-between mb-2">
        <h3>{section.title}</h3>
        <button className="btn btn-info btn-sm" onClick={handleAddForm}>Add {section.singular}</button>
      </div>
      {forms}
    </div>
  )
}

export default RepeatingSectionForm
