$(function() {
  $.fn.date_span_selector = function(end_date_id) {
    var start_date_id = $(this).attr("id");
    var onSelected = function(selectedDate) {
      var option = this.id == start_date_id + "_datepicker" ? "minDate" : "maxDate";
      instance = $( this ).data( "datepicker" );
      date = $.datepicker.parseDate(
        instance.settings.dateFormat ||
        $.datepicker._defaults.dateFormat, selectedDate, instance.settings);
      var dates = $("#" + start_date_id + "_datepicker, #" + end_date_id + "_datepicker").datepicker();
      dates.not( this ).datepicker( "option", option, date );
    };

    $("#" + start_date_id).hide();
    $("<input type=\"text\" id=\"" + start_date_id + "_datepicker\"/>")
      .insertAfter("#" + start_date_id)
      .datepicker({
        numberOfMonths: 3,
        altField: "#" + start_date_id,
        altFormat: "yy-mm-dd",
        dateFormat: "DD, MM d, yy",
        autoSize: true,
        changeYear: true,
        onSelect: onSelected
      });
    var start_date = $("#" + start_date_id).val();
    $("#" + start_date_id + "_datepicker").datepicker("setDate",
      $.datepicker.parseDate("yy-mm-dd", start_date));

    $("#" + end_date_id).hide();
    $("<input type=\"text\" id=\"" + end_date_id + "_datepicker\"/>")
      .insertAfter("#" + end_date_id)
      .datepicker({
        numberOfMonths: 3,
        altField: "#" + end_date_id,
        altFormat: "yy-mm-dd",
        dateFormat: "DD, MM d, yy",
        autoSize: true,
        changeYear: true,
        onSelect: onSelected
      });
    var end_date = $("#" + end_date_id).val();
    $("#" + end_date_id + "_datepicker").datepicker("setDate",
      $.datepicker.parseDate("yy-mm-dd", end_date));
  };
});
