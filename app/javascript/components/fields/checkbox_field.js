import React from 'react';

export default function Checkbox ({label,value,onChange}) {
  return (
    <div className='form-group'>
      <label>{label}</label>
      <input
        type='checkbox'
        onChange={(e) => { onChange(e.target.checked) }}
        checked={value}
      />
    </div>
  )
}
