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

  it("is hidden and saved to the server when destroyed", function() {
    spyOn(assignmentModel, "save");
    assignmentModel.destroy();
    expect($("div.assignment")).toBeHidden();
    expect(assignmentModel.save).toHaveBeenCalled();
  });

  it("is saved to the server when public_note is modified", function() {
    spyOn(assignmentModel, "save");
    assignmentModel.public_note("foo");
    expect(assignmentModel.save).toHaveBeenCalled();
  });

  it("is saved to the server when private_note is modified", function() {
    spyOn(assignmentModel, "save");
    assignmentModel.private_note("foo");
    expect(assignmentModel.save).toHaveBeenCalled();
  });

  it("is saved to the server the first time duration is modified", function() {
    spyOn(assignmentModel, "save");
    assignmentModel.duration("1.0");
    expect(assignmentModel.save).toHaveBeenCalled();
    assignmentModel.duration("1.0");
    expect(assignmentModel.save.callCount).toEqual(1);
  });
});
