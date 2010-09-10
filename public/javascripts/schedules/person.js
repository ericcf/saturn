(function($) {

  var Person = function(element) {
    var elem = $(element);
    var obj = this;
    this.broadcaster = Broadcaster;
    this.broadcaster(elem);

    this.name = function() {
      return elem.find(".name").text();
    };

    this.id = function() {
      return elem.attr("id").match(/person_([^"]+)/)[1];
    };

    elem.bind("click", function() {
      elem.trigger("onSelected");
    });
  };

  $.fn.person = function() {

    this.each(function() {
      var element = $(this);
      if (element.data("person")) return;
      var person = new Person(this);
      element.data("person", person);
    });

    return this;
  };

})(jQuery);
