(function($) {

  var Report = function(element) {
    var elem = $(element);
    var obj = this;

    elem.find("th.group").
      addClass("clickable").
      append("<span class='ui-icon ui-icon-triangle-1-e'/>").
      click(function() {
        var groupTitle = $(this).find("span.title").text();
        var state = $("body").data(groupTitle)
        if (state == null) {
          state = "expanded";
          $("body").data(groupTitle, state);
        }
        if (state == "expanded") {
          $("." + groupTitle).hide();
          $("body").data(groupTitle, "collapsed");
        } else {
          $("." + groupTitle).show();
          $("body").data(groupTitle, "expanded");
        }
        $("th.group:has(span.title:contains(" + groupTitle + ")) span.ui-icon").
          toggleClass("ui-icon-triangle-1-e").
          toggleClass("ui-icon-triangle-1-s");
      });
  };

  $.fn.report = function() {

    this.each(function() {
      var element = $(this);
      if (element.data("report")) return;
      var report = new Report(this);
      element.data("report", report);
    });

    return this;
  };
})(jQuery);

$(function() {
  $("table").report();
});
