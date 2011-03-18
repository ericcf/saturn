$(function() {
  $(".color_picker").hide();
  $("<span/>").appendTo($(".color_picker").parent()).each(function() {
    $(this).colorPicker({
      color: ["#FF7400", "#11CC11", "#006E2E", "#4096EE", "#356AA0",
        "#FF0000", "#B02B2C", "#000000"],
      defaultColor: $(this).parent().find("input").val(),
      click: function(color, picker) {
        picker.parent().parent().parent().find("input").val(color);
      }
    });
  });
});
