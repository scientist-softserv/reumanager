import React from 'react'
import ReactDOM from 'react-dom'

class App extends React.Component {
  render() {
    return (
      <div>
        <p>Application form goes here</p>
      </div>
    )
  }
}


document.addEventListener('DOMContentLoaded', () => {
  ReactDOM.render(
    <App />,
    document.querySelector('#applicationForm')
  )
})
