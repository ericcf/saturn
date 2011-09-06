$(function() {
  $("tbody tr").mouseover(function() {
    $(this).addClass("hover");
  }).mouseout(function() {
    $(this).removeClass("hover");
  });

  $("tbody td, thead th, tfoot th").mouseover(function() {
    var colNumber = $(this).index() + 1;
    $("tr :nth-child(" + colNumber + ")").addClass("hover");
  }).mouseout(function() {
    var colIndex = $(this).index();
    $("td").removeClass("hover");
  });
});
