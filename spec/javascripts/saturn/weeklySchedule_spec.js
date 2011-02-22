describe("weeklySchedule", function() {
  var schedule;

  beforeEach(function() {
    schedule = new weeklySchedule({
      weekly_schedule: {
        dates: [{ year: 2011, month: 12, day: 31 }]
      }
    });
  });

  describe(".longDate()", function() {

    it("returns the formatted date", function() {
      schedule.date.year(2011);
      schedule.date.month(12)
      schedule.date.day(31);
      expect(schedule.longDate()).toEqual("December 31, 2011");
    });
  });

  describe(".longLastUpdate()", function() {

    it("returns the formatted last update timestamp", function() {
      schedule.last_update.year(2011);
      schedule.last_update.month(12)
      schedule.last_update.day(31);
      schedule.last_update.hour(23)
      schedule.last_update.minute(59);
      expect(schedule.longLastUpdate())
        .toEqual("2011 December 31, 23:59");
    });
  });

  describe(".publishAction()", function() {

    it("returns the available publish action", function() {
      schedule.is_published(true);
      expect(schedule.publishAction()).toEqual("Unpublish");
      schedule.is_published(false);
      expect(schedule.publishAction()).toEqual("Publish");
    });
  });

  describe(".previousWeekDate()", function() {

    it("returns the date one week ago", function() {
      schedule.date.year(2011);
      schedule.date.month(12)
      schedule.date.day(31);
      expect(schedule.previousWeekDate()).toEqual("2011-12-24");
    });
  });

  describe(".nextWeekDate()", function() {

    it("returns the date in one week", function() {
      schedule.date.year(2011);
      schedule.date.month(12)
      schedule.date.day(31);
      expect(schedule.nextWeekDate()).toEqual("2012-1-7");
    });
  });

  describe(".startEditing(assignment)", function() {

    describe("when shift days are selected", function() {

      it("does not set the currently editing assignment", function() {
        schedule.selectedShiftDays(["mock shift day"]);
        schedule.startEditing("mock assignment");
        expect(schedule.editingAssignment()).not.toBeDefined();
      });
    });

    describe("when no shift days are selected", function() {

      it("sets the currently editing assignment", function() {
        schedule.selectedShiftDays([]);
        var stubAssignment = new assignment();
        spyOn(stubAssignment, 'inEditMode');
        schedule.startEditing(stubAssignment);
        expect(schedule.editingAssignment()).toEqual(stubAssignment);
        expect(stubAssignment.inEditMode).toHaveBeenCalledWith(true);
      });
    });
  });

  describe(".stopEditing()", function() {

    it("removes the currently editing assignment", function() {
      var stubAssignment = new assignment();
      spyOn(stubAssignment, 'inEditMode');
      schedule.editingAssignment(stubAssignment);
      schedule.stopEditing();
      expect(schedule.editingAssignment()).not.toBeDefined();
      expect(stubAssignment.inEditMode).toHaveBeenCalledWith(false);
    });
  });

  describe(".toggleSelectedShiftDay(shiftDay)", function() {
    var stubShiftDay = new shiftDay();

    describe("when editing an assignment", function() {

      it("does not change the shift day selection", function() {
        schedule.editingAssignment("mock assignment");
        spyOn(stubShiftDay, 'inSelectedMode');
        schedule.toggleSelectedShiftDay(stubShiftDay);
        expect(stubShiftDay.inSelectedMode).not.toHaveBeenCalled();
      });
    });

    describe("when dragging an assignment", function() {

      it("does not change the shift day selection", function() {
        schedule.draggingAssignment("mock assignment");
        spyOn(stubShiftDay, 'inSelectedMode');
        schedule.toggleSelectedShiftDay(stubShiftDay);
        expect(stubShiftDay.inSelectedMode).not.toHaveBeenCalled();
      });
    });

    describe("when not editing or dragging an assignment", function() {

      it("toggles the shift day selection", function() {
        spyOn(stubShiftDay, 'inSelectedMode');

        schedule.toggleSelectedShiftDay(stubShiftDay);
        expect(schedule.selectedShiftDays()).toContain(stubShiftDay);
        expect(stubShiftDay.inSelectedMode).toHaveBeenCalledWith(true);

        schedule.toggleSelectedShiftDay(stubShiftDay);
        expect(schedule.selectedShiftDays()).not.toContain(stubShiftDay);
        expect(stubShiftDay.inSelectedMode).toHaveBeenCalledWith(false);
      });
    });
  });

  describe(".startDragging(assignment)", function() {

    it("sets the currently dragging assignment", function() {
      var stubAssignment = new assignment();
      spyOn(stubAssignment, 'inDraggingMode');
      schedule.startDragging(stubAssignment);
      expect(schedule.draggingAssignment()).toEqual(stubAssignment);
      expect(stubAssignment.inDraggingMode).toHaveBeenCalledWith(true);
    });
  });

  describe(".stopDragging(assignment)", function() {

    it("unsets the currently dragging assignment", function() {
      var stubAssignment = new assignment();
      spyOn(stubAssignment, 'inDraggingMode');
      schedule.draggingAssignment(stubAssignment);
      schedule.stopDragging(stubAssignment);
      expect(schedule.draggingAssignment()).not.toBeDefined();
      expect(stubAssignment.inDraggingMode).toHaveBeenCalledWith(false);
    });
  });

  describe(".assignmentDroppedOn(shiftDay)", function() {

    it("adds the currently dragging assignment to the shift day and saves the assignment", function() {
      var stubAssignment = new assignment();
      var stubShiftDay = new shiftDay();
      spyOn(stubAssignment, 'save');
      spyOn(stubShiftDay, 'addAssignment');
      schedule.draggingAssignment(stubAssignment);
      schedule.assignmentDroppedOn(stubShiftDay);
      expect(stubShiftDay.addAssignment).toHaveBeenCalledWith(stubAssignment);
      expect(stubAssignment.save).toHaveBeenCalled();
    });
  });

  describe(".assignPhysician(physicianId)", function() {

    it("adds a new assignment to each selected shift day, deselects the shift day, and saves the assignments", function() {
      var stubAssignment = new assignment();
      spyOn(window, 'assignment').andReturn(stubAssignment);
      var stubShiftDay = new shiftDay();
      spyOn(stubAssignment, 'setSchedule');
      spyOn(stubShiftDay, 'addAssignment');
      spyOn(stubShiftDay, 'inSelectedMode');
      spyOn(schedule, 'saveAssignments');
      schedule.selectedShiftDays([stubShiftDay]);

      schedule.assignPhysician(1);
      expect(stubAssignment.setSchedule).toHaveBeenCalledWith(schedule);
      expect(stubShiftDay.addAssignment).toHaveBeenCalledWith(stubAssignment);
      expect(stubShiftDay.inSelectedMode).toHaveBeenCalledWith(false);
      expect(schedule.saveAssignments).toHaveBeenCalledWith([stubAssignment]);
    });
  });

  describe(".deselectShiftDays()", function() {

    it("deselects selected shift days", function() {
      var stubShiftDay = new shiftDay();
      spyOn(stubShiftDay, 'inSelectedMode');
      schedule.selectedShiftDays([stubShiftDay]);
      schedule.deselectShiftDays();
      expect(stubShiftDay.inSelectedMode).toHaveBeenCalledWith(false);
      expect(schedule.selectedShiftDays().length).toEqual(0);
    });
  });
});
