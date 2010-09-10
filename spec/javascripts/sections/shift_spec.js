describe("Shift", function() {

  var shift;

  beforeEach(function() {
    loadFixtures("__spec__/sections/shift.html");
    $("tr.shift").shift();
    shift = $("tr.shift").data("shift");
  });

  describe("#setPosition(:value) and #getPosition()", function() {

    it("set and get the position value", function() {
      shift.setPosition(15);
      expect(shift.getPosition()).toEqual("15");
    });
  });

  describe("#setTitle(:value) and #getTitle()", function() {

    it("set and get the title value", function() {
      shift.setTitle("Green Eggs and Ham");
      expect(shift.getTitle()).toEqual("Green Eggs and Ham");
    });
  });
});
