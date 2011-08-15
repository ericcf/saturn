// enables forgery protection to work with Rails 3.0.4 and jQuery 1.5
$.ajaxSetup({
  headers: {
    "X-CSRF-Token": $("meta[name='csrf-token']").attr('content')
  }
});

$(function() {
  // make buttons look nice with jQuery UI
  $(".pagination a, button, a.button, .button a, input.button, input[type='submit']").button();
});
