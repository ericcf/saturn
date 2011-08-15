(function($) {

  var Button = function(element, options) {
    var elem = $(element);
    var obj = this;
    this.broadcaster = Broadcaster;
    this.broadcaster(elem);
    var state = "up";

    var settings = $.extend({
      classes: [],
      title: "",
      toggle: false
    }, options || {});

    for (var i=0;i<settings.classes.length;i++) {
      elem.addClass(settings.classes[i]);
    };
    elem.attr("title", settings.title);

    this.show = function() {
      elem.show();
    };

    this.hide = function() {
      elem.hide();
    };

    this.press = function() {
      if (settings.toggle)
        state = state == "up" ? "down" : "up";
    };

    this.getState = function() {
      return state;
    };
  };

  // renamed from "button()" to avoid jQuery UI conflict
  $.fn.s_button = function(options) {
    this.each(function() {
      var element = $(this);
      if (element.data("button")) return;
      var button = new Button(this, options);
      element.data("button", button);
    });

    return this;
  };
})(jQuery);
