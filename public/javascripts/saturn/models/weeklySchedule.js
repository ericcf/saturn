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
                return new shiftWeek(options.data, self);
            }
        },
        "rules_conflicts": {
            create: function(options) {
                return new ruleConflicts(options.data, self);
            }
        }
    };

    this.last_update = {
        year: ko.observable(undefined),
        month: ko.observable(undefined),
        day: ko.observable(undefined),
        hour: ko.observable(undefined),
        minute: ko.observable(undefined)
    };

    this.editingAssignment = ko.observable(undefined);

    this.selectedShiftDays = ko.observableArray([]);

    this.toggleSelectedShiftDay = function(shiftDay) {
        if (this.selectedShiftDays.remove(shiftDay).length > 0) {
            shiftDay.selected(false);
        } else {
            this.selectedShiftDays.push(shiftDay);
            shiftDay.selected(true);
        }
    };

    this.deselectShiftDays = function() {
        var shiftDay;
        while (shiftDay = this.selectedShiftDays.pop()) {
            shiftDay.selected(false);
        }
    };

    this.assignPhysician = function(physicianId) {
        var shiftDay;
        var newAssignments = [];
        while (shiftDay = this.selectedShiftDays.pop()) {
            var newAssignment = new assignment({ "assignment": {
                "physician_id": physicianId,
                "public_note": "",
                "private_note": "",
                "duration": null,
                "date": null,
                "shift_id": null,
                "id": null
            } }, self);
            shiftDay.addAssignment(newAssignment);
            shiftDay.selected(false);
            newAssignments.push(newAssignment);
        }
        self.saveAssignments(newAssignments);
    };

    this.saveAssignments = function(assignments) {
        var serializedAssignments = [];
        for (var i = 0; i < assignments.length; i++) {
            serializedAssignments.push(assignments[i].serialize());
        }
        self.save({ assignments: serializedAssignments });
    };  

    this.physicians = ko.observableArray([]);

    ko.mapping.fromJS(attributes.weekly_schedule, mapping, this);

    this.longDate = ko.dependentObservable(function() {
        return jQuery.datepicker.formatDate('MM d, yy', new Date(this.date.year(), this.date.month()-1, this.date.day()));
    }, this);

    this.longLastUpdate = ko.dependentObservable(function() {
        if (this.last_update.year() == undefined) return "never";
        var dateObj = new Date(this.last_update.year(), this.last_update.month()-1, this.last_update.day(), this.last_update.hour(), this.last_update.minute());
        var minutesPad = dateObj.getMinutes() < 10 ? "0" : "";
        return jQuery.datepicker.formatDate("" + dateObj.getHours() + ':' + minutesPad + dateObj.getMinutes() + ' MM d, yy ', dateObj);
    }, this);

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
            for (var j = 0; j < self.physicians().length; j++) {
                if (self.physicians()[j].physician.id() == physicianId) {
                    return self.physicians()[j].physician;
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

    this.ajaxStatus = ko.observable(null);

    this.publishAction = ko.dependentObservable(function() {
        return this.is_published() ? "Unpublish" : "Publish";
    }, this);

    var lastIsPublished = this.is_published();
    this.is_published.subscribe(function(newValue) {
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
        self.ajaxStatus("sending");
        ko.utils.postJson(postUrl,
            self.serialize(optionalParams),
            {
                "submitter": function(form) {
                    $.post(postUrl, $(form).serialize(), function(data) {
                        skipSaves = true;
                        self.updateFromJS(data);
                        skipSaves = false;
                        self.ajaxStatus("complete");
                    }, "json")
                }
            }
        )
    };
};
