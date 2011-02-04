var assignment = function(attributes, schedule) {
    var schedule = schedule;
    var skipSaves = false;
    var self = this;

    this.public_note = ko.observable("");
    this.private_note = ko.observable("");
    this.duration = ko.observable(null);

    this._destroy = false;
    this.destroy = function() {
        this._destroy = true;
        self.save();
    };

    ko.mapping.fromJS(attributes.assignment, {}, this);
    var physicianName = undefined;
    this.physician_name = function() {
        if (physicianName == undefined) {
            var physician = schedule.findPhysician(self.physician_id());
            if (physician != undefined) {
                physicianName = physician.short_name;
            }
        }
        return physicianName;
    };

    this.inEditMode = ko.observable(false);

    this.noteType = ko.dependentObservable(function() {
        if (self.public_note() && self.private_note())
            return "public-private";
        else if (self.public_note())
            return "public";
        else if (self.private_note())
            return "private";
    }, self);

    this.public_note.subscribe(function(newNote) {
        self.save();
    });

    this.private_note.subscribe(function(newNote) {
        self.save();
    });

    var lastDuration = this.duration();
    this.duration.subscribe(function(newDuration) {
        if (newDuration != lastDuration) {
            lastDuration = newDuration;
            self.save();
        }
    });

    this.serialize = function() {
        return {
            id: self.id(),
            physician_id: self.physician_id(),
            date: self.date(),
            shift_id: self.shift_id(),
            public_note: self.public_note(),
            private_note: self.private_note(),
            duration: self.duration() == undefined ? null : self.duration(),
            _destroy: self._destroy
        }
    };

    this.save = function() {
        if (skipSaves) return;
        var postUrl = location.href.replace("/edit", ".json");
        schedule.ajaxStatus("sending");
        ko.utils.postJson(postUrl,
            schedule.serialize({ assignments: [self.serialize()] }),
            {
                "submitter": function(form) {
                    $.ajax({
                        type: "POST",
                        url: postUrl,
                        data: $(form).serialize(),
                        success: function(data) {
                            skipSaves = true;
                            ko.mapping.updateFromJS(schedule, data.weekly_schedule);
                            skipSaves = false;
                            schedule.ajaxStatus("complete");
                        },
                        dataType: "json",
                        error: function(x, t, e) {
                            alert(t);
                        }
                    })
                }
            });
    }

    schedule.editingAssignment.subscribe(function(newAssignment) {
        if (newAssignment != self) {
            self.inEditMode(false);
        }
    });
}
