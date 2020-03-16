import React, { useState } from 'react'
import ShortTextField from './fields/short_text_field'
import LongTextField from './fields/long_text_field'
import Checkbox from './fields/checkbox_field'

export default function FormWrapper() {
  const [data1, setData1] = useState('')
  const [data2, setData2] = useState('')
  const [data3, setData3] = useState('')

  const changeData1 = (value) => {
    console.log(value)
    setData1(value)
  }
  const changeData2 = (value) => {
    console.log(value)
    setData2(value)
  } 
  const changeData3 = (value) => {
    console.log(value)
    setData3(value)
  }

  return (
    <div>
    <pre>{data1}</pre>
     <ShortTextField
       label = "First name"
       value = {data1}
       onChange = {changeData1}
       required
       minLength = {3}
       />

      <pre>{data2}</pre>
     <ShortTextField
       label = "Last name"
       value = {data2}
       onChange = {changeData2}
       required
       minLength = {3}
       /> 

      <pre>{data3}</pre>
      <LongTextField
        label = "Short Essay"
        value = {data3}
        onChange = {changeData3}
        required
        minLength={5}
        />

      <Checkbox
        label = "click here. ▷  "
        name = {"Checkbox"}
        value = {false}
      />
   </div>
  )
}