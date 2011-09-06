(function($) {

  var Shift = function(element) {
    var elem = $(element);
    var obj = this;

    // public

    this.getTitle = function() {
      return elem.find("[name*='[label]']").val();
    };

    this.setTitle = function(value) {
      elem.find("[name*='[label]']").val(value);
      return obj;
    };

    this.getPosition = function() {
      return elem.find("[name*='[position]']").val();
    };

    this.setPosition = function(value) {
      elem.find("[name*='[position]']").val(value);
      return obj;
    };

    // private

  };

  $.fn.shift = function() {

    this.each(function() {
      var element = $(this);
      if (element.data("shift")) return;
      var shift = new Shift(this);
      element.data("shift", shift);
    });

    return this;
  };
})(jQuery);
