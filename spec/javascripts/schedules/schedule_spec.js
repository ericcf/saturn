describe("schedule", function() {
  var schedule;

  beforeEach(function() {
    loadFixtures("/__spec__/schedules/schedule.html");
    $(".schedule").schedule({ peopleSelection: ".groups" });
    schedule = $(".schedule").data("schedule");
  });

  it("initializes the assignment template", function() {
    expect($("#assignment_template").data("assignment_template")).
      toBeDefined();
  });

  it("adds header class to .date and .shift_label elements", function() {
    expect($(".date").hasClass(schedule.headerClass)).toBeTruthy();
    expect($(".shift_label").hasClass(schedule.headerClass)).toBeTruthy();
  });

  it("adds content class to div.person elements", function() {
    expect($("div.person").hasClass(schedule.contentClass)).toBeTruthy();
  });

  it("adds highlight class to div.person on mouseover", function() {
    $("div.person").
      removeClass(schedule.highlightClass).
      trigger("mouseover");
    expect($("div.person").hasClass(schedule.highlightClass)).toBeTruthy();
  });

  it("removes highlight class from div.person on mouseout", function() {
    $("div.person").
      addClass(schedule.highlightClass).
      trigger("mouseout");
    expect($("div.person").hasClass(schedule.highlightClass)).toBeFalsy();
  });

  it("adds default class to div.assignment", function() {
    expect($("div.assignment").hasClass(schedule.defaultClass)).toBeTruthy();
  });

  it("adds hover class to div.assignment on mouseover", function() {
    $("div.assignment").
      removeClass(schedule.hoverClass).
      trigger("mouseover");
    expect($("div.assignment").hasClass(schedule.hoverClass)).toBeTruthy();
  });

  it("removes hover class from div.assignment on mouseout", function() {
    $("div.assignment").
      addClass(schedule.hoverClass).
      trigger("mouseout");
    expect($("div.assignment").hasClass(schedule.hoverClass)).toBeFalsy();
  });

  describe("#assignmentElementFromPerson(:shift_day, :person)", function() {
    it("delegates to the assignment template", function() {
      var shiftDay = {};
      var person = {};
      var template = $("#assignment_template").data("assignment_template");
      var element = {};
      spyOn(template, "make_view_from_person").andReturn(element);
      expect(schedule.assignmentElementFromPerson(shiftDay, person)).
        toEqual(element);
      expect(template.make_view_from_person).
        toHaveBeenCalledWith(shiftDay, person);
    });
  });

  describe("#assignmentElementFromAssignment(:shift_day, :assignment)", function() {
    it("delegates to the assignment template", function() {
      var shiftDay = jasmine.createSpy();
      var assignment = jasmine.createSpy();
      var template = $("#assignment_template").data("assignment_template");
      var element = jasmine.createSpy();
      spyOn(template, "make_view_from_assignment").andReturn(element);
      expect(schedule.assignmentElementFromAssignment(shiftDay, assignment)).
        toEqual(element);
      expect(template.make_view_from_assignment).
        toHaveBeenCalledWith(shiftDay, assignment);
    });
  });

  describe("#addShiftDayElement(:element)", function() {
    it("converts the specified element to a shift day", function() {
      schedule.addShiftDayElement($(".shift_day"));
      expect($(".shift_day").data("shift_day")).toBeDefined();
    });
  });

  describe("#enableShiftDayControls()", function() {
    it("broadcasts enableShiftDayControls", function() {
      var callback = jasmine.createSpy();
      schedule.addListener("enableShiftDayControls", callback);
      schedule.enableShiftDayControls();
      expect(callback).toHaveBeenCalled();
    });
  });

  describe("#disableShiftDayControls()", function() {
    it("broadcasts disableShiftDayControls", function() {
      var callback = jasmine.createSpy();
      schedule.addListener("disableShiftDayControls", callback);
      schedule.disableShiftDayControls();
      expect(callback).toHaveBeenCalled();
    });
  });

  describe("#assignmentDetailsActivatedFor(:assignment)", function() {
    it("broadcasts onDeactivateAssignmentDetails", function() {
      var callback = jasmine.createSpy();
      schedule.addListener("onDeactivateAssignmentDetails", callback);
      schedule.assignmentDetailsActivatedFor("foo");
      expect(callback).toHaveBeenCalled();
    });
  });

  describe("#showAddPersonControls()", function() {
    it("opens the add person dialog", function() {
      $(".groups").dialog("close");
      schedule.showAddPersonControls();
      expect($(".groups").dialog("isOpen")).toBeTruthy();
    });
  });
});
