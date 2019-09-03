import React from 'react'
import Form from './form'

function SectionForm({index, section, data, dispatch, ...props}) {
  var isRepeating = index !== undefined
  var key = section.key

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

  var style = isRepeating ? { width: '80%' } : {}

  var schema = section.schema

  if (isRepeating) {
    schema.title = `${section.singular} ${index + 1}`
  }

  return (
    <div className="section-form" style={style}>
      <Form schema={schema}
        uiSchema={section.ui}
        formData={data}
        onChange={onFormChange}
        onError={onFormError} />
    </div>
  )
}

export default SectionForm
