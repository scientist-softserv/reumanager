
export function saveData(data) {
  $.ajax({
    url: this.state.path,
    method: this.state.method,
    data: data,
    headers: {
      'X-CSRF-Token': getCookie('X-CSRF-Token')
    },
    success: (res) => {
      this.setState({ msg: 'Information has been saved', msgType: 'success' })
      setTimeout(_ => { this.setState({msg: null}) }, 4000)
    },
    fail: (err) => {
      this.setState({ msg: 'An error occured while trying to save your information', msgType: 'danger' })
      setTimeout(_ => { this.setState({msg: null}) }, 4000)
    }
  })
}

export function getCookie(cname) {
  var name = cname + "=";
  var decodedCookie = decodeURIComponent(document.cookie);
  var ca = decodedCookie.split(';');
  for(var i = 0; i <ca.length; i++) {
    var c = ca[i];
    while (c.charAt(0) == ' ') {
      c = c.substring(1);
    }
    if (c.indexOf(name) == 0) {
      return c.substring(name.length, c.length);
    }
  }
  return "";
}
