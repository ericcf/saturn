var weeklySchedule = function(attributes) {
    var self = this;
    var skipSaves = false;
    var mapping = {
        "dates": {
            create: function(options) {
                return new scheduleDate(options.data);
            }
        },
        "shift_weeks": {
            create: function(options) {
                var newShiftWeek = new shiftWeek(options.data);
                newShiftWeek.setSchedule(self);
                return newShiftWeek;
            }
        },
        "rules_conflicts": {
            create: function(options) {
                var newRuleConflicts = new ruleConflicts(options.data);
                newRuleConflicts.setSchedule(self);
                return newRuleConflicts;
            }
        }
    };

    this.rules_conflicts = ko.observableArray([]);

    this.last_update = {
        year: ko.observable(undefined),
        month: ko.observable(undefined),
        day: ko.observable(undefined),
        hour: ko.observable(undefined),
        minute: ko.observable(undefined)
    };
    this.editingAssignment = ko.observable(undefined);
    this.draggingAssignment = undefined;
    this.selectedShiftDays = ko.observableArray([]);
    this.date = {
        year: ko.observable((new Date()).getFullYear()),
        month: ko.observable((new Date()).getMonth()+1),
        day: ko.observable((new Date()).getDate())
    };
    this.longDate = ko.dependentObservable(function() {
        return jQuery.datepicker.formatDate('MM d, yy', new Date(this.date.year(), this.date.month()-1, this.date.day()));
    }, this);
    this.longLastUpdate = ko.dependentObservable(function() {
        if (this.last_update.year() == undefined) return "never";
        var dateObj = new Date(this.last_update.year(), this.last_update.month()-1, this.last_update.day(), this.last_update.hour(), this.last_update.minute());
        var minutesPad = dateObj.getMinutes() < 10 ? "0" : "";
        return jQuery.datepicker.formatDate("" + dateObj.getHours() + ':' + minutesPad + dateObj.getMinutes() + ' MM d, yy ', dateObj);
    }, this);
    this.ajaxStatus = ko.observable(undefined);
    this.is_published = ko.observable(undefined);
    this.publishAction = ko.dependentObservable(function() {
        return this.is_published() ? "Unpublish" : "Publish";
    }, this);

    this.toggleSelectedShiftDay = function(shiftDay) {
        if (this.editingAssignment() != undefined || this.draggingAssignment != undefined) {
            return;
        }
        if (this.selectedShiftDays.remove(shiftDay).length > 0) {
            shiftDay.inSelectedMode(false);
        } else {
            this.selectedShiftDays.push(shiftDay);
            shiftDay.inSelectedMode(true);
        }
    };

    this.deselectShiftDays = function() {
        var shiftDay;
        while (shiftDay = this.selectedShiftDays.pop()) {
            shiftDay.inSelectedMode(false);
        }
    };

    this.startEditing = function(assignment) {
        if (this.selectedShiftDays().length > 0) {
            return;
        }
        this.editingAssignment(assignment);
        assignment.inEditMode(true);
    };

    this.stopEditing = function() {
        if (this.editingAssignment() != undefined) {
            this.editingAssignment().inEditMode(false);
            this.editingAssignment(undefined);
        }
    };

    this.startDragging = function(assignment) {
        assignment.inDraggingMode(true);
        this.draggingAssignment = assignment;
    };

    this.stopDragging = function(assignment) {
        assignment.inDraggingMode(false);
        this.draggingAssignment = undefined;
    };

    this.assignmentDroppedOn = function(shiftDay) {
        if (this.draggingAssignment != undefined) {
            shiftDay.addAssignment(this.draggingAssignment);
            this.draggingAssignment.save();
        }
    };

    this.assignPhysician = function(physicianId) {
        var shiftDay;
        var newAssignments = [];
        while (shiftDay = this.selectedShiftDays.pop()) {
            var newAssignment = new assignment({ "assignment": {
                "physician_id": physicianId,
                "date": null,
                "shift_id": null,
                "id": null
            } });
            newAssignment.setSchedule(this);
            shiftDay.addAssignment(newAssignment);
            shiftDay.inSelectedMode(false);
            newAssignments.push(newAssignment);
        }
        this.saveAssignments(newAssignments);
    };

    this.saveAssignments = function(assignments) {
        var serializedAssignments = [];
        for (var i = 0; i < assignments.length; i++) {
            serializedAssignments.push(assignments[i].serialize());
        }
        self.save({ assignments: serializedAssignments });
    };  

    this.previousWeekDate = function() {
      var lastWeek = new Date(this.date.year(), this.date.month()-1, this.date.day());
      lastWeek.setDate(lastWeek.getDate()-7);
      return "" + lastWeek.getFullYear() + "-" + (lastWeek.getMonth()+1) + "-" + lastWeek.getDate();
    };

    this.nextWeekDate = function() {
      var nextWeek = new Date(this.date.year(), this.date.month()-1, this.date.day());
      nextWeek.setDate(nextWeek.getDate()+7);
      return "" + nextWeek.getFullYear() + "-" + (nextWeek.getMonth()+1) + "-" + nextWeek.getDate();
    };

    this.findPhysician = function(physicianId) {
        for (var i = 0; i < self.groups().length; i++) {
            var physicians = self.groups()[i].physicians();
            for (var j = 0; j < physicians.length; j++) {
                if (physicians[j].physician.id() == physicianId) {
                    return physicians[j].physician;
                }
            }
        }
    };

    var physicianNames = {};
    this.physicianName = function(physicianId) {
        if (physicianNames[physicianId] == undefined) {
            var physician = self.findPhysician(physicianId);
            if (physician == undefined) {
                physicianNames[physicianId] = "unknown";
            } else {
                physicianNames[physicianId] = physician.short_name;
            }
        }
        return physicianNames[physicianId];
    };

    var lastIsPublished;
    this.is_published.subscribe(function(newValue) {
        if (lastIsPublished == undefined) {
            lastIsPublished = newValue;
            return;
        }
        if (newValue != lastIsPublished) {
            lastIsPublished = newValue;
            self.save();
        }
    });

    this.serialize = function(optionalParams) {
        var serialized = {
              weekly_schedule: {
                  is_published: self.is_published(),
                  date: "" + self.date.year() + "-" + self.date.month() + "-" + self.date.day()
              }
        };
        if (self.id) {
            serialized.id = self.id();
        }
        if (typeof optionalParams == "object") {
            for (var key in optionalParams) {
                serialized.weekly_schedule[key] = optionalParams[key];
            }
        }
        return serialized;
    };

    this.updateFromJS = function(data) {
        ko.mapping.updateFromJS(self, data.weekly_schedule);
    };

    this.save = function(optionalParams) {
        if (skipSaves) return;
        var postUrl = location.href.replace("/edit", ".json");
        ko.utils.postJson(postUrl,
            self.serialize(optionalParams),
            {
                "submitter": function(form) {
                    $.post(postUrl, $(form).serialize(), function(data) {
                        skipSaves = true;
                        self.updateFromJS(data);
                        skipSaves = false;
                    }, "json")
                }
            }
        )
    };

    ko.mapping.fromJS(attributes.weekly_schedule, mapping, this);
};
