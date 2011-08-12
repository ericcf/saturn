describe("shiftWeek", function() {
  var shiftWeekModel = new shiftWeek({
    shiftWeek: {
    }
  });

  beforeEach(function() {
    loadFixtures("../../../../__spec__/javascripts/fixtures/saturn/shiftWeek.html");
    $.ajax({
      url: "/saturn/templates/_shiftWeekRow.htm",
      aync: false,
      success: function(template) {
        $("#shiftWeek-fixture").append(template);
        ko.applyBindings(shiftWeekModel);
      }
    });
    waits(100);
  });

  it("hides the default input value on focus", function() {
    $(".shift-week-note").focus();
    expect($(".shift-week-note")).toHaveValue("");
  });

  it("shows the default input value on blur", function() {
    $(".shift-week-note").blur();
    expect($(".shift-week-note")).toHaveValue(shiftWeekModel.defaultNote);
  });
});
