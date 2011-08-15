$(function() {
  // hide the form controls to be used when JS is disabled
  $("#date-selector select, #date-selector input[type=submit]").hide();
  // add the dynamic form controls
  $("<input name=\"date\" type=\"text\" value=\"select date...\"/>")
    .appendTo("#date-selector")
    .datepicker({
      onSelect: function(dateText, inst) {
        var date = $(this).datepicker("getDate");
        var href = $("#date-selector").attr("action")
          .replace(/\/?\d{4}\/\d{1,2}\/\d{1,2}(\??)/, "$1");
        location.href = href.replace(/\/?(\?.*)?$/, "/" + date.getFullYear() + "/" + (date.getMonth()+1) + "/" + date.getDate() + "$1");
      }
    });
});
