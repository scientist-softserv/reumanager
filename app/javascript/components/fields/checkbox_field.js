import React from 'react';

export default function Checkbox ({label,value,onChange,props}) {
  const handleChange = (e) => {
    var value = e.target.value
    onChange(value)
    props(value)
  }
  return (
    <div className = 'form-group'>
        <label> {label} </label>
      <input 
      type = {'checkbox'}
      onChange = {handleChange} 
      value = {value}
      props = {false}
      />
    </div>
  )
}