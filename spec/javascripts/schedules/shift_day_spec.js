describe("shift_day", function() {
  var shift_day;
  var Schedule = function() {this.listeners = []; this.removedListeners = [];};
  Schedule.prototype.addListener = function(eventName, callback) {
    this.listeners.push(eventName);
    return this;
  };
  Schedule.prototype.removeListener = function(eventName, callback) {
    this.removedListeners.push(eventName);
    return this;
  };
  Schedule.prototype.showAddPersonControls = function() {};
  Schedule.prototype.assignmentElementFromAssignment = function(sd, a) {
    return $("<div/>");
  };
  var schedule;

  beforeEach(function() {
    loadFixtures("/__spec__/schedules/shift_day.html");
    $(".shift_day").shift_day();
    shift_day = $(".shift_day").data("shift_day");
    schedule = new Schedule();
    shift_day.addedToSchedule(schedule);
  });

  describe("#addedToSchedule", function() {
    it("adds listeners for [enable|disable]ShiftDayControls", function() {
      expect(schedule.listeners).
        toEqual(["enableShiftDayControls", "disableShiftDayControls"]);
    });
  });

  describe("#getAddPersonButton()", function() {
    it("returns the .assignment_button element", function() {
      var button = shift_day.getAddPersonButton();
      expect(button.hasClass("assignment_button")).toBeTruthy();
    });
  });

  describe("#listenForPerson(:shouldListen)", function() {
    describe("shouldListen is true", function() {
      it("listens for onPersonSelected and onPersonDialogClosed", function() {
        shift_day.listenForPerson(true);
        expect(schedule.listeners.pop()).toEqual("onPersonDialogClosed");
        expect(schedule.listeners.pop()).toEqual("onPersonSelected");
      });
    });

    describe("shouldListen is false", function() {
      it("removes listener from schedule for onPersonSelected", function() {
        shift_day.listenForPerson(false);
        expect(schedule.removedListeners.pop()).toEqual("onPersonSelected");
      });
    });
  });

  describe("#setSelected(:isSelected)", function() {
    describe("isSelected is true", function() {
      it("adds selected class to shift_day element", function() {
        var element = $(".shift_day");
        element.removeClass("selected");
        shift_day.setSelected(true);
        expect(element.hasClass("selected")).toBeTruthy();
      });
    });

    describe("isSelected is false", function() {
      it("removes selected class to shift_day element", function() {
        var element = $(".shift_day");
        element.addClass("selected");
        shift_day.setSelected(false);
        expect($(".shift_day").hasClass("selected")).toBeFalsy();
      });
    });
  });
  
  describe("#getDate()", function() {
    it("returns the date", function() {
      $(".shift_day").addClass("date_2010-01-07");
      expect(shift_day.getDate()).toEqual("2010-01-07");
    });
  });

  describe("#getShiftId()", function() {
    it("returns shift_id", function() {
      $(".shift_day").addClass("shift_id_9");
      expect(shift_day.getShiftId()).toEqual("9");
    });
  });

  describe("#add_assignment()", function() {
    describe("the associated person is not already assigned here", function() {
      it("returns true", function() {
        var Assignment = function() {};
        Assignment.prototype.getPersonId = function() {};
        var assignment = new Assignment();
        spyOn(assignment, "getPersonId").andReturn(1);
        expect(shift_day.add_assignment(assignment)).toBeTruthy();
      });
    });

    describe("the associated person is assigned here", function() {
      it("returns false", function() {
        var Assignment = function() {};
        Assignment.prototype.getPersonId = function() {};
        var assignment = new Assignment();
        spyOn(assignment, "getPersonId").andReturn(1);
        spyOn(shift_day, "hasPerson").andReturn(true);
        expect(shift_day.add_assignment(assignment)).toBeFalsy();
      });
    });
  });

  /*describe("#updateAssignmentPositions()", function() {
    it("sets position values based on the order of the elements", function() {
      $(".shift_day").append(*/
});
