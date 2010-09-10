describe("person", function() {
  var person;

  beforeEach(function() {
    loadFixtures("/__spec__/schedules/person.html");
    $(".person").person();
    person = $(".person").data("person");
  });

  it("returns name", function() {
    $(".person .name").text("O. Henry");
    expect(person.name()).toEqual("O. Henry");
  });

  it("returns id", function() {
    $(".person").attr("id", "person_42");
    expect(person.id()).toEqual("42");
  });
});
