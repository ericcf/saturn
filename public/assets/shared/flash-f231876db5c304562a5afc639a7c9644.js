(function($) {
$.fn.showFlashMessage = function() {
  var flash = $(".flash").hide();
  var message = flash.html();
  if (message != null && message != "") {
    var type = null;
    if (flash.hasClass("error")) {
      type = "error";
    } else if (flash.hasClass("alert")) {
      type = "warning";
    }
    $.jnotify(message, type);
  }
};
})(jQuery);

$(function() {
  $.fn.showFlashMessage();
});
