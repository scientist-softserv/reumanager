import React from 'react'
import Form from './form'

function SectionForm({index, section, data, dispatch, ...props}) {
  var isRepeating = index !== undefined
  var key = section.key
  var style = isRepeating ? { width: '80%' } : {}
  var schema = section.schema

  var onFormChange = (data) => {
    // console.log('on change', isRepeating, key, data.formData, index)
    var values = Object.values(data.formData).filter(e => e !== undefined)
    if (values.length === 0) {
      return
    }
    if (isRepeating) {
      dispatch({
        type: 'updateWithIndex',
        key: key,
        data: data.formData,
        index: index
      })
    } else {
      dispatch({
        type: 'update',
        key: key,
        data: data.formData
      })
    }
  }

  var onFormError = (data) => {
    props.onFormError(section, data)
  }

  if (isRepeating) {
    schema.title = `${section.singular} ${index + 1}`
  }

  return (
    <div className="section-form" style={style}>
      <FormValidation data={data} validations={section.validations} />
      <Form schema={schema}
        uiSchema={section.ui}
        formData={data}
        onChange={onFormChange}
        onError={onFormError} />
    </div>
  )
}

export default SectionForm


function FormValidation({data, validations}) {
  var validationMsgs = []

  Object.keys(validations).forEach((key, index) => {
    let value = data[key]
    if (validations[key].required) {
      if (value === '' || value === undefined) {
        validationMsgs.push(<p key={key + index}>{validations[key].required}</p>)
      }
    }
  })

  if (validationMsgs.length > 0) {
    return (
      <div className="alert alert-danger mb-3">
        <h5 className="alert-header">Errors</h5>
        <hr />
        {validationMsgs}
      </div>
    )
  } else {
    return null
  }
}
