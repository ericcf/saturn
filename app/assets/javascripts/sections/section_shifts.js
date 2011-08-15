(function($) {

  var SectionShifts = function(element) {
    var elem = $(element);
    var obj = this;

    this.defaultClass = "ui-state-default";
    this.iconClass = "ui-icon";
    this.verticalDoubleArrowClass = "ui-icon-arrowthick-2-n-s";

    // public

    // private

    var getShifts = function() {
      return elem.find(".shift");
    };
    
    var onSortUpdate = function() {
      getShifts().each(function(index, shiftElement) {
        $(shiftElement).data("shift").setPosition(index + 1);
      });
    };

    var initialize = function() {
      elem.find("tbody td.control").addClass(obj.defaultClass);
      elem.find("tbody td label.handle").addClass(obj.iconClass).
        addClass(obj.verticalDoubleArrowClass);
      elem.find("tbody").
        sortable({
          axis: 'y',
          handle: 'label.handle',
          update: onSortUpdate
        }).
        disableSelection();
      getShifts().shift();
    };

    initialize();
  };

  $.fn.section_shifts = function() {

    this.each(function() {
      var element = $(this);
      if (element.data("section_shifts")) return;
      var sectionShifts = new SectionShifts(this);
      element.data("section_shifts", sectionShifts);
    });

    return this;
  };
})(jQuery);

$(function() {
  $("table#current_shifts").section_shifts();
});
