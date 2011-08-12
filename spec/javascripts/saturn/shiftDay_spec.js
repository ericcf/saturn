describe("shiftDay", function() {
  var shiftDayModel = new shiftDay({
    shiftDay: {
    }
  });

  beforeEach(function() {
    loadFixtures("../../../../__spec__/javascripts/fixtures/saturn/shiftDay.html");
    $.ajax({
      url: "/saturn/templates/_shiftDayCell.htm",
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

  it("removes the hover style after a mouseout", function() {
    $("td.shiftDay").mouseout();
    expect($("td.shiftDay")).not.toHaveClass("ui-state-hover");
  });

  it("toggles its selection when clicked", function() {
    spyOn(shiftDayModel, "toggleSelected");
    $("td.shiftDay").click();
    expect(shiftDayModel.toggleSelected).toHaveBeenCalled();
  });

  describe("#addAssignment(:assignment)", function() {

    it("sets the date of the assignment to this date", function() {
      var assignmentObj = new assignment({ });
      shiftDayModel.date("the ides of March");
      shiftDayModel.addAssignment(assignmentObj);
      expect(assignmentObj.date()).toEqual("the ides of March");
    });

    it("sets the shift_id of the assignment to this shift_id", function() {
      var assignmentObj = new assignment({ });
      shiftDayModel.shift_id(8);
      shiftDayModel.addAssignment(assignmentObj);
      expect(assignmentObj.shift_id()).toEqual(8);
    });

    it("adds the assignment to the assignments collection", function() {
      var assignmentObj = new assignment({ });
      shiftDayModel.addAssignment(assignmentObj);
      expect(shiftDayModel.assignments()).toContain(assignmentObj);
    });
  });
});
