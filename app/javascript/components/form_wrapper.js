import React, { useState } from 'react'
import ShortTextField from './fields/short_text_field'

export default function FormWrapper() {
  const [data, setData] = useState('john')
  const changeData = (value) => {
    console.log(value)
    setData(value)
  }
  return (
    <div>
      <pre>{data}</pre>
      <ShortTextField
        label="first name"
        value={data}
        onChange={changeData}
        required
        minLength={3}
        />
    </div>
  )
}
