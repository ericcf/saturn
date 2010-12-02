(function($) {

  var ShiftDay = function(element) {
    var elem = $(element);
    var obj = this;
    this.broadcaster = Broadcaster;
    this.broadcaster(elem);
    var people_ids = new Array();
    var schedule;
    var enabled = true;

    // public
    
    this.addedToSchedule = function(sched) {
      if (schedule) return;
      schedule = sched;
      schedule.
        addListener("enableShiftDayControls", onEnabled).
        addListener("disableShiftDayControls", onDisabled);
      initializeAssignments();
    };

    this.getAddPersonButton = function() {
      return elem.find(".assignment_button");
    };

    this.listenForPerson = function(shouldListen) {
      if (shouldListen) {
        schedule.
          addListener("onPersonSelected", onPersonAdded).
          addListener("onPersonDialogClosed", function() {
            obj.setSelected(false);
          }).
          showAddPersonControls();
      } else {
        schedule.removeListener("onPersonSelected", onPersonAdded);
      }
      return obj;
    };

    this.isEnabled = function() {
      return enabled;
    };

    this.setSelected = function(isSelected) {
      if (isSelected)
        elem.addClass("selected");
      else
        elem.removeClass("selected");
    };

    this.getDate = function() {
      return elem.attr("class").match(/date_([\d-]+)/)[1];
    };

    this.getShiftId = function() {
      return elem.attr("class").match(/shift_id_(\d+)/)[1];
    };

    this.add_assignment = function(assignment) {
      if (!obj.hasPerson(assignment.getPersonId())) {
        var element = schedule.assignmentElementFromAssignment(obj, assignment);
        append_assignment_element(element);
        return true;
      }
      return false;
    };

    this.update_positions = function() {
      elem.find(".assignment").each(function(index, assignment_element) {
        $(assignment_element).data("assignment").setPosition(index+1);
      });
    };
    
    this.hasPerson = function(id) {
      for (var i=0; i<people_ids.length; i++) {
        if (people_ids[i] == id) return true;
      }
      return false;
    };

    this.removePersonId = function(id) {
      var index = 0;
      for (; index<people_ids.length; index++) {
        if (people_ids[index] == id) break;
      }
      people_ids.splice(index, 1);
    };


    // private

    var onPersonAdded = function(event, person) {
      obj.broadcast("onPersonAdded");
      if (!obj.hasPerson(person.id())) {
        var element = schedule.assignmentElementFromPerson(obj, person);
        append_assignment_element(element);
        return true;
      }
      return false;
    };
    
    var onEnabled = function() {
      enabled = true;
    };

    var onDisabled = function() {
      enabled = false;
    };

    var initializeAssignments = function() {
      elem.find(".assignment").each(function(index, assignment_elem) {
        append_assignment_element(assignment_elem);
      });
    };

    var append_assignment_element = function(element) {
      elem.append(element);
      $(element).assignment();
      var assignment = $(element).data("assignment");
      people_ids.push(assignment.getPersonId());
      assignment.setPosition(people_ids.length);
      assignment.addedToSchedule(schedule);
      assignment.addListener("onAssignmentDestroyed", onAssignmentDestroyed);
    };
    
    var onAssignmentDestroyed = function(event) {
      var assignment = $(event.target).data("assignment");
      obj.removePersonId(assignment.getPersonId());
    };
  };

  var ShiftDayControls = function(model) {
    var shiftDay = model;
    var buttonElement = shiftDay.getAddPersonButton().button({
      classes: ["ui-icon", "ui-icon-person"],
      title: "Assign a person",
      toggle: true
    });
    var addPersonButton = buttonElement.data("button");
    addPersonButton.addListener("click", function() {
      addPersonButton.press();
      if (addPersonButton.getState() == "up") {
        shiftDay.
          listenForPerson(false).
          setSelected(false);
      } else {
        shiftDay.
          listenForPerson(true).
          setSelected(true);
      }
    });
    shiftDay.
      addListener("mousemove", function() {
        showControls();
      }).
      addListener("mouseout", function() {
        hideControls();
      }).
      addListener("onPersonAdded", function() {
        shiftDay.
          listenForPerson(false).
          setSelected(false);
      });
    var showControls = function() {
      if (shiftDay.isEnabled())
        addPersonButton.show();
    };
    var hideControls = function() {
      addPersonButton.hide();
    };
  };

  $.fn.shift_day = function() {

    this.each(function() {
      var element = $(this);
      if (element.data("shift_day")) return;
      var shift_day = new ShiftDay(this);
      element.data("shift_day", shift_day);
      var controls = new ShiftDayControls(shift_day);
      element.data("shift_day_controls", controls);
    });

    return this;
  };

})(jQuery);
