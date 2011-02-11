describe("shiftDay", function() {
  var shiftDayModel = new shiftDay({
    shiftDay: {
    }
  });

  beforeEach(function() {
    loadFixtures("saturn/shiftDay.html");
    $.ajax({
      url: "/public/javascripts/saturn/templates/_shiftDayCell.htm",
      aync: false,
      success: function(template) {
        $("#shiftDay-fixture").append(template);
        ko.applyBindings(shiftDayModel);
      }
    });
    waits(100);
  });

  it("shows the hover style during a mouseover", function() {
    $("td.shiftDay").mouseover();
    expect($("td.shiftDay")).toHaveClass("ui-state-hover");
  });

  it("toggles its selection when clicked", function() {
    spyOn(shiftDayModel, "toggleSelected");
    $("td.shiftDay").click();
    expect(shiftDayModel.toggleSelected).toHaveBeenCalled();
  });
});
