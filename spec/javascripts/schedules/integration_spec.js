describe("edit weekly section schedule", function() {
  function initializeShiftDays() {
    $("td.shift_day").trigger("mouseover");
  }

  beforeEach(function() {
    loadFixtures("__spec__/schedules/edit_weekly_section.html");
    $("table.schedule").schedule({ peopleSelection: ".groups" });
  });

  afterEach(function() {
    $(".ui-dialog").remove();
    $(".groups").remove();
    $(".details").remove();
  });

  describe("object graph initialization", function() {

    it("should have initialized a Schedule on table.schedule", function() {
      expect($("table.schedule").data("schedule")).toBeDefined();
    });
  });

  describe("global control interaction", function() {

    beforeEach(function() {
      initializeShiftDays();
    });

    describe("when an assignment .button is clicked", function() {

      it("assignment details dialog opens", function() {
        $(".assignment .button:first").trigger("click");
        expect($(".details:first").dialog("isOpen")).toEqual(true);
      });
    });

    describe("when an .assignment_button is clicked", function() {

      beforeEach(function() {
        $(".assignment_button:first").trigger("click");
      });

      it("people selection dialog opens", function() {
        expect($(".groups").dialog("isOpen")).toEqual(true);
      });

      it("the shift day cell has .selected added", function() {
        expect($(".shift_day:first").hasClass("selected")).toBeTruthy();
      });
    });

    describe("when the people selection dialog closes", function() {

      it("removes .selected from shift day cells", function() {
        $(".assignment_button:first").trigger("click");
        $(".assignment_button:first").trigger("click");
        expect($(".shift_day").hasClass("selected")).toBeFalsy();
      });
    });

    describe("when a person is selected", function() {
    
      it("an assignment is added to the listening shift days", function() {
        var previousAssignments = $(".shift_day .assignment").length;
        $(".assignment_button:first").trigger("click");
        $(".person:first").trigger("mouseover");
        $(".person:first").data("person").broadcast("onSelected");
        expect($(".shift_day .assignment").length).
          toEqual(previousAssignments+1);
      });
    });
  });

  describe("widget display", function() {

    describe(".assignment element", function() {

      it("has .ui-state-hover added on mouseover", function() {
        $(".assignment:first").trigger("mouseover");
        expect($(".assignment:first").hasClass("ui-state-hover")).toBeTruthy();
      });

      it("has .ui-state-hover removed on mouseout", function() {
        $(".assignment:first").addClass("ui-state-hover").
          trigger("mouseout");
        expect($(".assignment:first").hasClass("ui-state-hover")).toBeFalsy();
      });
    });
  });
});
