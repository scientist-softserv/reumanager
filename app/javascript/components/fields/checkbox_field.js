import React from 'react';

export default function Checkbox ({label,value,onChange}) {
  const handleChange = (e) => {
    console.log(value)
    onChange(e.target.checked)
  }
  return (
    <div className = 'form-group'>
        <label> {label} </label>
      <input 
        type = 'checkbox'
        onChange = {handleChange} 
        checked = {value}
      />
    </div>
  )
}