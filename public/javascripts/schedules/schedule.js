(function($) {

  var Schedule = function(element, options) {
    var elem = $(element);
    var obj = this;
    this.broadcaster = Broadcaster;
    this.broadcaster(elem);

    var settings = $.extend({
      assignmentTemplate: "#assignment_template",
      headerClass: "ui-widget-header",
      contentClass: "ui-widget-content",
      defaultClass: "ui-state-default",
      highlightClass: "ui-state-highlight",
      hoverClass: "ui-state-hover"
    }, options || {});
    this.headerClass = settings.headerClass;
    this.contentClass = settings.contentClass;
    this.defaultClass = settings.defaultClass;
    this.highlightClass = settings.highlightClass;
    this.hoverClass = settings.hoverClass;

    var initialized = false;
    var highlightingActive = true;
    $(settings.assignmentTemplate).assignment_template();
    var assignment_template = $(settings.assignmentTemplate).
      data("assignment_template");

    var initializeEffects = function() {
      $(".date, .shift_label").addClass(obj.headerClass);
      $("div.person").
        addClass(obj.contentClass).
        live("mouseover", onHighlightActive).
        live("mouseout", onHighlightInactive);
      $("div.assignment").
        addClass(obj.defaultClass).
        live("mouseover", onHoverActive).
        live("mouseout", onHoverInactive);
    };

    //public

    this.assignmentElementFromPerson = function(shift_day, person) {
      return assignment_template.make_view_from_person(shift_day, person);
    };

    this.assignmentElementFromAssignment = function(shift_day, assignment) {
      return assignment_template.make_view_from_assignment(shift_day, assignment);
    };

    this.addShiftDayElement = function(element) {
      $(element).shift_day();
      var shiftDay = $(element).data("shift_day");
      shiftDay.addedToSchedule(obj);
    };

    this.enableShiftDayControls = function() {
      obj.broadcast("enableShiftDayControls");
    };

    this.disableShiftDayControls = function(shiftDayElement) {
      obj.broadcast("disableShiftDayControls");
    };

    this.assignmentDetailsActivatedFor = function(assignment) {
      obj.broadcast("onDeactivateAssignmentDetails");
    };

    this.showAddPersonControls = function() {
      $(settings.peopleSelection).dialog("open");
    };

    // private

    var onHighlightActive = function(event) {
      addHighlight(event.target);
    };

    var onHighlightInactive = function(event) {
      removeHighlight(event.target);
    };

    var onHoverActive = function(event) {
      $(event.currentTarget).addClass(obj.hoverClass);
    };

    var onHoverInactive = function(event) {
      $(event.currentTarget).removeClass(obj.hoverClass);
    };

    var addHighlight = function(element) {
      if (highlightingActive) {
        $(element).addClass(obj.highlightClass);
        return;
      }
      highlightingActive = true;
    };

    var removeHighlight = function(element) {
      $(element).removeClass(obj.highlightClass);
    };

    var toggleHighlight = function(element) {
      if ($(element).hasClass(obj.highlightClass)) {
        removeHighlight(element);
      } else {
        addHighlight(element);
      }
    };

    var onPeopleSelectionDialogClose = function() {
      obj.removeListeners("onPersonSelected");
      obj.broadcast("onPersonDialogClosed");
    };

    var initPeopleSelectionInteraction = function() {
      $(settings.peopleSelection).
        dialog({
          autoOpen: false,
          close: onPeopleSelectionDialogClose
        }).
        tabs();
      // lazy loading
      $(settings.peopleSelection + " .person").live("mouseover", function() {
        $(this).person();
        $(this).data("person").addListener("onSelected", function() {
          obj.broadcast("onPersonSelected", $(this).data("person"));
          $(settings.peopleSelection).dialog("close");
        });
      });
    };

    var initialize = function() {
      if (initialized) return;
      $("td.shift_day").droppable({
        accept: ".assignment",
        over: function(event, ui) {
          // lazy loading
          obj.addShiftDayElement(this);
        },
        drop: function(event, ui) {
          var element = ui.draggable;
          var assignment = element.data("assignment");
          var sourceShiftDay = element.parent().data("shift_day");
          sourceShiftDay.removePersonId(assignment.getPersonId());
          if ($(this).data("shift_day").add_assignment(assignment))
            element.remove();
        }
      });

      $("td.shift_day").delegate("span.person_name", "click", function() {
        toggleHighlight("span:contains('" + $(this).text() + "')");
      });
      initShiftDayInteraction();
      initPeopleSelectionInteraction();
      initializeEffects();
      initialized = true;
    };

    var initShiftDayInteraction = function() {
      // lazy loading
      $("td.shift_day").live("mouseover", function() {
        obj.addShiftDayElement(this);
        $(this).sortable({
          start: function(event, ui) {
            highlightingActive = false;
            obj.disableShiftDayControls();
          },
          stop: function(event, ui) {
            $(this).data("shift_day").update_positions();
            obj.enableShiftDayControls();
          }
        });
        $("div.assignment").mouseover(function() {
          $(this).find("span.notes_icon").show();
        });
        $("div.assignment").mouseout(function() {
          $(this).find("span.notes_icon").hide();
        });
      });
    };

    initialize();
  };

  $.fn.schedule = function(options) {
  
    this.each(function() {
      var element = $(this);
      if (element.data("schedule")) return;
      var schedule = new Schedule(this, options);
      element.data("schedule", schedule);
    });

    return this;
  };
})(jQuery);

$(function() {
  $("table.schedule").schedule({
    peopleSelection: ".groups"
  });
});
