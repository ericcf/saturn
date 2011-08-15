(function($) {

  var DateSelector = function(element, options) {
    var elem = $(element);
    var obj = this;
    var selected = false;

    this.isSelected = function() {
      return obj.selected;
    };

    var submitForm = function(selectedDate, inst) {
      if (this.id == "date") {
        window.location.href = elem.parent().attr("action") + "?date=" + selectedDate;
      } else {
        var instance = $(this).data("datepicker");
        var date = $.datepicker.parseDate(instance.settings.dateFormat || $.datepicker._defaults.dateFormat, selectedDate, instance.settings);
        $("#" + this.id + "_text").
          html($.datepicker.formatDate(instance.settings.altFormat, date));
        var option = this.id == "start_date" ? "minDate" : "maxDate";
        var otherDate = $("[name=start_date], [name=end_date]").not(this);
        otherDate.datepicker("option", option, date);
        obj.selected = true;
        if (otherDate.data("date_selector").isSelected())
          window.location.href = $(this).closest("form").attr("action") +
            "?start_date=" + $("#start_date").val() +
            "&end_date=" + $("#end_date").val();
      }
    };

    elem.hide();
    elem.datepicker({
      showButtonPanel: true,
      dateFormat: 'yy-mm-dd',
      altFormat: 'MM d, yy',
      changeMonth: true,
      changeYear: true,
      showOn: 'button',
      buttonImage: '/images/calendar.gif',
      buttonImageOnly: true,
      onSelect: submitForm
    });
  };

  $.fn.date_selector = function(options) {
    this.each(function() {
      var element = $(this);
      if (element.data("date_selector")) return;
      var date_selector = new DateSelector(this, options);
      element.data("date_selector", date_selector);
    });

    return this;
  };
})(jQuery);

$(function() {
  $("input[name=date], input[name=start_date], input[name=end_date]").
    date_selector();
});
