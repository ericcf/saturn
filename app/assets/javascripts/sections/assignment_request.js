$(function() {
  var onSelected = function(selectedDate) {
    var option = this.id == "assignment_request_start_date_datepicker" ? "minDate" : "maxDate";
    instance = $( this ).data( "datepicker" );
    date = $.datepicker.parseDate(
      instance.settings.dateFormat ||
      $.datepicker._defaults.dateFormat, selectedDate, instance.settings);
    var dates = $("#assignment_request_start_date_datepicker, #assignment_request_end_date_datepicker").datepicker();
    dates.not( this ).datepicker( "option", option, date );
  };

  $("#assignment_request_start_date").hide();
  $("<input type=\"text\" id=\"assignment_request_start_date_datepicker\"/>").
  insertAfter("#assignment_request_start_date").
  datepicker({
    numberOfMonths: 3,
    minDate: new Date(),
    altField: "#assignment_request_start_date",
    altFormat: "yy-mm-dd",
    dateFormat: "DD, MM d, yy",
    autoSize: true,
    onSelect: onSelected
  });
  var start_date = $("#assignment_request_start_date").val();
  $("#assignment_request_start_date_datepicker").datepicker("setDate",
    $.datepicker.parseDate("yy-mm-dd", start_date));
  $("#assignment_request_end_date").hide();
  $("<input type=\"text\" id=\"assignment_request_end_date_datepicker\"/>").
  insertAfter("#assignment_request_end_date").
  datepicker({
    numberOfMonths: 3,
    minDate: new Date(),
    altField: "#assignment_request_end_date",
    altFormat: "yy-mm-dd",
    dateFormat: "DD, MM d, yy",
    autoSize: true,
    onSelect: onSelected
  });
  var end_date = $("#assignment_request_end_date").val();
  $("#assignment_request_end_date_datepicker").datepicker("setDate",
    $.datepicker.parseDate("yy-mm-dd", end_date));
});
