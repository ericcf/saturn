describe("assignment", function() {
  var assignment;
  var Schedule = function() { this.listeners = []; this.removedListeners=[]; };
  Schedule.prototype.addListener = function(eventName, callback) {
    this.listeners.push(eventName);
  };
  Schedule.prototype.removeListener = function(eventName, callback) {
    this.removedListeners.push(eventName);
  };
  Schedule.prototype.assignmentDetailsActivatedFor = function(model) {};
  var schedule = new Schedule();

  beforeEach(function() {
    loadFixtures("/__spec__/schedules/assignment.html");
    $(".assignment").assignment();
    assignment = $(".assignment").data("assignment");
  });

  it("adds a title to .person_name", function() {
    expect($(".person_name").attr("title")).
      toEqual("Click to highlight identical; drag to change order or shift");
  });

  it("adds a title to .button", function() {
    expect($(".button").attr("title")).toEqual("Click to edit or delete");
  });

  describe("#addedToSchedule(:sched)", function() {
    it("adds a listener for onDeactivateAssignmentDetails", function() {
      assignment.addedToSchedule(schedule);
      expect(schedule.listeners.pop()).
        toEqual("onDeactivateAssignmentDetails");
    });
  });

  describe("#appendToElement(:newElement)", function() {
    it("appends newElement to the dom element", function() {
      assignment.appendToElement("<span id=\"foo\"></span>");
      expect($(".assignment #foo").length).toEqual(1);
    });
  });

  describe("#detailsActivated()", function() {
    it("notifies the schedule", function() {
      assignment.addedToSchedule(schedule);
      spyOn(schedule, "assignmentDetailsActivatedFor");
      assignment.detailsActivated();
      expect(schedule.assignmentDetailsActivatedFor).
        toHaveBeenCalledWith(assignment);
    });
  });

  describe("#destroy()", function() {
    beforeEach(function() {
      assignment.addedToSchedule(schedule);
    });

    it("removes onDeactivateAssignmentDetails listener", function() {
      assignment.destroy();
      expect(schedule.removedListeners.pop()).
        toEqual("onDeactivateAssignmentDetails");
    });

    it("triggers an onDetailsDeactivated event", function() {
      var callback = jasmine.createSpy();
      assignment.addListener("onDetailsDeactivated", callback);
      assignment.destroy();
      expect(callback).toHaveBeenCalled();
    });

    it("sets its destroy field to true", function() {
      assignment.destroy();
      expect($("input[name*=[_destroy]]").val()).toBeTruthy();
    });

    it("hides itself", function() {
      $(".assignment").show();
      assignment.destroy();
      expect($(".assignment:visible").length).toEqual(0);
    });

    it("triggers an onAssignmentDestroyed event", function() {
      var callback = jasmine.createSpy();
      assignment.addListener("onAssignmentDestroyed", callback);
      assignment.destroy();
      expect(callback).toHaveBeenCalled();
    });
  });

  describe("#setDestroy(:value)", function() {
    it("sets the destroy field value", function() {
      assignment.setDestroy("foo");
      expect($("[name*=[_destroy]]").val()).toEqual("foo");
    });
  });

  describe("#getPersonName()", function() {
    it("returns person's name", function() {
      $(".assignment .person_name").text("O. Henry");
      expect(assignment.getPersonName()).toEqual("O. Henry");
    });
  });

  describe("#getPersonId()", function() {
    it("returns physician_id", function() {
      $("[name*=physician_id]").val(42);
      expect(assignment.getPersonId()).toEqual("42");
    });
  });

  describe("#getId()", function() {
    it("returns id", function() {
      $("[name*=[id]]").val(1);
      expect(assignment.getId()).toEqual("1");
    });
  });

  describe("#getPosition()", function() {
    it("returns position", function() {
      $("[name*=position]").val(4);
      expect(assignment.getPosition()).toEqual("4");
    });
  });

  describe("#setPosition()", function() {
    it("sets position", function() {
      assignment.setPosition(8);
      expect(assignment.getPosition()).toEqual("8");
    });
  });

  describe("#getPublicNote()", function() {
    it("returns public_note", function() {
      $("[name*=public_note]").val("It was the best of times...");
      expect(assignment.getPublicNote()).toEqual("It was the best of times...");
    });
  });

  describe("#getPrivateNote()", function() {
    it("returns private_note", function() {
      $("[name*=private_note]").val("It was the worst of times...");
      expect(assignment.getPrivateNote()).toEqual("It was the worst of times...");
    });
  });

  describe("#getDuration()", function() {
    it("returns duration", function() {
      $("[name*=duration]").
        append("<option val=\"long\">long</option>").
        append("<option val=\"short\">short</option>").
        val("short");
      expect(assignment.getDuration()).toEqual("short");
    });
  });

  describe("#getDeleteLink()", function() {
    it("returns delete link", function() {
      expect(assignment.getDeleteLink().hasClass("destructive")).toBeTruthy();
    });
  });

  describe("#getDetailsButton()", function() {
    it("returns details button", function() {
      expect(assignment.getDetailsButton().hasClass("button")).toBeTruthy();
    });
  });

  describe("#addHighlight()", function() {
    it("adds a highlight", function() {
      assignment.addHighlight();
      expect($(".assignment").hasClass("ui-state-highlight")).toBeTruthy();
    });
  });

  describe("#removeHighlight()", function() {
    it("removes a highlight", function() {
      $(".assignment").addClass("ui-state-highlight");
      assignment.removeHighlight();
      expect($(".assignment").hasClass("ui-state-highlight")).toBeFalsy();
    });
  });
});

describe("assignment template", function() {

  var template;

  var ShiftDay = function() {};
  var shift_day;
  ShiftDay.prototype.getShiftId = function() { return "2"; };
  ShiftDay.prototype.getDate = function() { return "2010-08-09"; };

  beforeEach(function() {
    loadFixtures("/__spec__/schedules/assignment.html");
    $(".assignment_template select[name*=duration]").
      append("<option value='12'>12</option>");
    $(".assignment_template").assignment_template();
    template = $(".assignment_template").data("assignment_template");
    shift_day = new ShiftDay();
  });

  describe("#make_view_from_assignment", function() {
    var Assignment = function() {};
    Assignment.prototype.getId = function() { return "33"; };
    Assignment.prototype.getPersonName = function() { return "Foo"; };
    Assignment.prototype.getPersonId = function() { return "1"; };
    Assignment.prototype.getPosition = function() { return "9"; };
    Assignment.prototype.getPublicNote = function() { return "Bar"; };
    Assignment.prototype.getPrivateNote = function() { return "Baz"; };
    Assignment.prototype.getDuration = function() { return "12"; };
    var assignment = new Assignment();
    var view;

    beforeEach(function() {
      view = template.make_view_from_assignment(shift_day, assignment);
    });

    it("sets id from assignment", function() {
      expect(view.find("[name*=[id]]").val()).
        toEqual(assignment.getId());
    });

    it("sets person_name from assignment", function() {
      expect(view.find(".person_name").text()).
        toEqual(assignment.getPersonName());
    });

    it("sets shift_id from shift day", function() {
      expect(view.find("[name*=shift_id]").val()).
        toEqual(shift_day.getShiftId());
    });

    it("sets physician_id from assignment", function() {
      expect(view.find("[name*=physician_id]").val()).
        toEqual(assignment.getPersonId());
    });

    it("sets date from shift_day", function() {
      expect(view.find("[name*=date]").val()).
        toEqual(shift_day.getDate());
    });

    it("sets position from assignment", function() {
      expect(view.find("[name*=position]").val()).
        toEqual(assignment.getPosition());
    });

    it("sets public_note from assignment", function() {
      expect(view.find("[name*=public_note]").val()).
        toEqual(assignment.getPublicNote());
    });

    it("sets private_note from assignment", function() {
      expect(view.find("[name*=private_note]").val()).
        toEqual(assignment.getPrivateNote());
    });

    it("sets duration from assignment", function() {
      expect(view.find("[name*=duration]").val()).
        toEqual(assignment.getDuration());
    });
  });

  describe("#make_view_from_person", function() {
    var Person = function() {};
    Person.prototype.name = function() { return "Boo"; };
    Person.prototype.id = function() { return "17"; };
    var person = new Person();
    var view;

    beforeEach(function() {
      view = template.make_view_from_person(shift_day, person);
    });

    it("sets person_name from person", function() {
      expect(view.find(".person_name").text()).
        toEqual(person.name());
    });

    it("sets physician_id from person", function() {
      expect(view.find("[name*=physician_id]").val()).
        toEqual(person.id());
    });

    it("sets shift_id from shift day", function() {
      expect(view.find("[name*=shift_id]").val()).
        toEqual(shift_day.getShiftId());
    });

    it("sets date from shift day", function() {
      expect(view.find("[name*=date]").val()).
        toEqual(shift_day.getDate());
    });
  });
});
