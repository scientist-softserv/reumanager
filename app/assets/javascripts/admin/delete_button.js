(function() {
  $(document).ready(function() {
    $('[data-target="fieldDeleteBtn"]').on('click', function(e) {
      var $btn = $(e.target)
      var $input = $btn.parent().find('input[name*=_destroy]')
      var $container = $btn.closest('fieldset')
      $input.val('1')
      $container.hide()
    })
  })
})()
