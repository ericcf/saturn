/*
 * depends on jquery ui dialog widget
 */

(function($) {

  var Assignment = function(element) {
    var elem = $(element);
    var obj = this;
    this.broadcaster = Broadcaster;
    this.broadcaster(elem);
    var schedule;

    elem.find(".person_name").
      attr("title", "Click to highlight identical; drag to change order or shift");
    elem.find(".button").
      attr("title", "Click to edit or delete");

    // public
    
    this.addedToSchedule = function(sched) {
      if (schedule) return;
      schedule = sched;
      schedule.addListener("onDeactivateAssignmentDetails",
        onDetailsDeactivated);
    };

    this.appendToElement = function(newElement) {
      return elem.append(newElement);
    };

    this.detailsActivated = function() {
      schedule.assignmentDetailsActivatedFor(obj);
    };

    this.destroy = function() {
      schedule.removeListener("onDeactivateAssignmentDetails",
        onDetailsDeactivated);
      elem.trigger("onDetailsDeactivated");
      obj.setDestroy("true");
      elem.hide();
      elem.trigger("onAssignmentDestroyed");
    };

    this.setDestroy = function(value) {
      elem.find("input[name*='[_destroy]']").val(value);
    };

    this.getPersonName = function() {
      return elem.find(".person_name").text();
    };

    this.getPersonId = function() {
      return elem.find("input[name*=physician_id]").val();
    };

    this.getId = function() {
      return elem.find("input[name*='[id]']").val();
    };

    this.getPosition = function() {
      return elem.find("input[name*=position]").val();
    };

    this.setPosition = function(value) {
      elem.find("input[name*=position]").val(value);
    };

    this.getPublicNote = function() {
      return elem.find("textarea[name*=public_note]").val();
    };

    this.getPrivateNote = function() {
      return elem.find("textarea[name*=private_note]").val();
    };

    this.getDuration = function() {
      return elem.find("select[name*=duration]").val();
    };

    this.getDetailsFields = function() {
      return elem.find(".details");
    };

    this.getDeleteLink = function() {
      return elem.find("a.destructive");
    };

    this.getDetailsButton = function() {
      return elem.find(".button");
    };

    this.addHighlight = function() {
      elem.addClass("ui-state-highlight");
    };

    this.removeHighlight = function() {
      elem.removeClass("ui-state-highlight");
    };

    // private

    var onDetailsDeactivated = function(event) {
      if (event.target == elem) return;
      elem.trigger("onDetailsDeactivated");
    };
  };

  var AssignmentControls = function() {
    var obj = this;
    var details_dialog;
    var dialog_options = {
      autoOpen: false,
      draggable: false,
      modal: true,
      close: function(event, ui) {
        assignment.removeHighlight();
      }
    };
    var assignment;

    // public

    this.addedToAssignment = function(model) {
      assignment = model;
      assignment.getDetailsButton().bind("click", onActivateDetails);
      assignment.getDetailsFields().bind("dialogclose", onDetailsDeactivated);
      assignment.getDeleteLink().bind("click", onDestroyAssignment);
      assignment.addListener("onDetailsDeactivated", onDetailsDeactivated);
      update_details_button();
    };

    // private

    var openDetailsDialog = function(options, xPos, yPos) {
      if (details_dialog == undefined) {
        var fields = assignment.getDetailsFields();
        details_dialog = fields.dialog(options);
        // hack to keep fields inside form element
        assignment.appendToElement(fields.parent());
      }
      details_dialog.dialog("option", "title", "Assignment details").
        dialog("option", "position", [xPos, yPos]).
        dialog("open");
    };

    var onActivateDetails = function(event) {
      assignment.detailsActivated();
      assignment.addHighlight();
      openDetailsDialog(dialog_options, event.pageX, event.pageY);
    };
    
    var onDetailsDeactivated = function() {
      update_details_button();
      if (details_dialog && details_dialog.dialog("isOpen")) {
        details_dialog.dialog("close");
      }
    };

    var onDestroyAssignment = function() {
      assignment.destroy();
      return false;
    };

    var update_details_button = function() {
      var notes_class = assignment.getPublicNote() == "" ? "" : "public";
      notes_class += assignment.getPrivateNote() == "" ? "" : "private";
      assignment.getDetailsButton().find(".notes_icon").
        attr("class", "notes_icon " + notes_class);
      var duration_class = assignment.getDuration() == "Select..." ? "" : "ui-icon ui-icon-clock";
      assignment.getDetailsButton().find(".duration_icon").
        attr("class", "duration_icon " + duration_class);
    };
  };

  var AssignmentTemplate = function(element) {
    var elem = $(element);
    var obj = this;

    this.make_view_from_assignment = function(shift_day, assignment) {
      var cloned_template = elem.children().clone();
      cloned_template.
        find("[name*='[id]']").val(assignment.getId());
      cloned_template.
        find(".person_name").text(assignment.getPersonName());
      cloned_template.
        find("input[name*=shift_id]").val(shift_day.getShiftId());
      cloned_template.
        find("input[name*=physician_id]").val(assignment.getPersonId());
      cloned_template.
        find("input[name*=position]").val(assignment.getPosition());
      cloned_template.
        find("input[name*=date]").val(shift_day.getDate());
      cloned_template.
        find("textarea[name*=public_note]").val(assignment.getPublicNote());
      cloned_template.
        find("textarea[name*=private_note]").val(assignment.getPrivateNote());
      cloned_template.
        find("select[name*=duration]").val(assignment.getDuration());
      return cloned_template;
    };

    this.make_view_from_person = function(shift_day, person) {
      var cloned_template = elem.children().clone();
      cloned_template.find(".person_name").text(person.name());
      cloned_template.find("input[name*=physician_id]").val(person.id());
      cloned_template.
        find("input[name*=shift_id]").val(shift_day.getShiftId());
      cloned_template.
        find("input[name*=date]").val(shift_day.getDate());
      return cloned_template;
    };
  };

  $.fn.assignment = function() {

    this.each(function() {
      var element = $(this);
      if (element.data("assignment")) return;
      var assignment = new Assignment(this);
      element.data("assignment", assignment);
      var controls = new AssignmentControls();
      controls.addedToAssignment(assignment);
      element.data("assignment_controls", controls);
    });

    return this;
  };

  $.fn.assignment_template = function() {

    this.each(function() {
      var element = $(this);
      if (element.data("assignment_template")) return;
      var assignment_template = new AssignmentTemplate(this);
      element.data("assignment_template", assignment_template);
    });

    return this;
  };

})(jQuery);
