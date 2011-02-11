describe("assignment", function() {
  var assignmentModel = new assignment({
    assignment: {
    }
  });

  beforeEach(function() {
    loadFixtures("saturn/assignment.html");
    $.ajax({
      url: "/public/javascripts/saturn/templates/_assignment.htm",
      aync: false,
      success: function(template) {
        $("#assignment-fixture").append(template);
        ko.applyBindings(assignmentModel);
      }
    });
    waits(100);
  });

  it("shows the hover style during a mouseover", function() {
    $("div.assignment").mouseover();
    expect($("div.assignment")).toHaveClass("ui-state-hover");
  });

  it("starts editing when clicked", function() {
    spyOn(assignmentModel, "startEditing");
    $("div.assignment").click();
    expect(assignmentModel.startEditing).toHaveBeenCalled();
  });
});
