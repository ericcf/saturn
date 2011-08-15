$(function() {
  $(".check_all_boxes").click(function() {
    $(this)
      .parent()
      .find("input[type='checkbox']:not([disabled='disabled'])")
      .attr('checked', true);
    return false;
  });
  $(".uncheck_all_boxes").click(function() {
    $(this)
      .parent()
      .find("input[type='checkbox']:not([disabled='disabled'])")
      .attr('checked', false);
    return false;
  });
});
