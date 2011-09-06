(function($) {

  var ShiftTags = function(element) {
    var elem = $(element);
    var obj = this;

    var searchShiftTagsURL = $("#tags_search_url").text();

    var initialize = function() {
      function split(val) {
        return val.split(/,\s*/);
      }
      function extractLast(term) {
        return split(term).pop();
      }

      elem.find("input").autocomplete({
        source: function(request, response) {
          $.getJSON(searchShiftTagsURL, {
            term: extractLast(request.term)
          }, response);
        },
        /*search: function() {
          // custom minLength
          var term = extractLast(this.value);
          if (term.length < 2) {
            return false;
          }
        },*/
        focus: function() {
          // prevent value inserted on focus
          return false;
        },
        select: function(event, ui) {
          var terms = split(this.value);
          // remove the current input
          terms.pop();
          // add the selected item
          terms.push(ui.item.value);
          // add placeholder to get the comma-and-space at the end
          terms.push("");
          this.value = terms.join(", ");
          return false;
        }
      });
    };
      
    initialize();
  };

  $.fn.shift_tags = function() {

    this.each(function() {
      var element = $(this);
      if (element.data("shift_tags")) return;
      var shiftTags = new ShiftTags(this);
      element.data("shift_tags", shiftTags);
    });

    return this;
  };
})(jQuery);

$(function() {
  $(".shift .tags").shift_tags();
});
