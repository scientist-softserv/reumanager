import React, { useState } from 'react'

export default function ShortTextField({label, value, onChange, required, minLength}) {
  const [errorMessage, setErrorMessage] = useState()
  const validate = (value) => {
    var message = ''
    if (value === '') {
      message += 'This is required.'
    }
    if (minLength !== undefined && value.length <= minLength) {
      message += ` Must be at least ${minLength} characters long`
    }
    if (message === '') {
      setErrorMessage(undefined)
    } else {
      setErrorMessage(message)
    }
  }
  const handleChange = (e) => {
    var value = e.target.value
    validate(value)
    onChange(value)
  }
  return (
    <div className="form-group">
      <label>{label}{required ? '*' : ''}</label>
      <input type="text" className={`form-control ${errorMessage ? 'is-invalid' : ''}`} onChange={handleChange} value={value} />
      {errorMessage !== undefined ? <div className="invalid-feedback">{errorMessage}</div> : null}
    </div>
  )
}
