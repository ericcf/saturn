describe("shifts", function() {
  var sectionShifts;

  beforeEach(function() {
    loadFixtures("__spec__/sections/section_shifts.html");
    $("table#current_shifts").section_shifts();
    sectionShifts = $("table#current_shifts").data("section_shifts");
  });

  it("adds defaultClass to td.control elements", function() {
    expect($("td.control").hasClass(sectionShifts.defaultClass)).
      toEqual(true);
  });

  it("adds iconClass to label.handle elements", function() {
    expect($("label.handle").hasClass(sectionShifts.iconClass)).
      toEqual(true);
  });

  it("adds verticalDoubleArrowClass to label.handle elements", function() {
    expect($("label.handle").hasClass(sectionShifts.verticalDoubleArrowClass)).
      toEqual(true);
  });

  it("makes tbody sortable", function() {
    expect($("tbody").hasClass("ui-sortable")).toEqual(true);
  });

  it("makes tbody unselectable", function() {
    expect($("tbody").attr("unselectable")).toEqual("on");
  });

  it("updates positions of shifts on sort update", function() {
    var MockShift = function(position) { this.position = position; };
    MockShift.prototype.setPosition = function(value) {
      this.position = value;
    };
    $(".shift:first").data("shift", new MockShift(5));
    $(".shift:last").data("shift", new MockShift(3));
    $("tbody").sortable("option", "update").call($("tbody"));
    expect($(".shift:first").data("shift").position).toEqual(1);
    expect($(".shift:last").data("shift").position).toEqual(2);
  });

  it("initializes .shift elements", function() {
    expect($(".shift").data("shift")).toBeDefined();
  });

});
