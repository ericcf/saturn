var assignment = function(attributes) {
    var schedule = undefined;
    var skipSaves = false;
    var self = this;

    this.public_note = ko.observable("");
    this.private_note = ko.observable("");
    this.duration = ko.observable(null);
    this.inEditMode = ko.observable(false);
    this.inDraggingMode = ko.observable(false);
    this.inHoveringMode = ko.observable(false);
    this.hasModifiedDuration = ko.dependentObservable(function() {
        return this.duration() != undefined && this.duration() != "Select one...";
    }, this);
    this.noteType = ko.dependentObservable(function() {
        if (self.public_note() && self.private_note())
            return "public-private";
        else if (self.public_note())
            return "public";
        else if (self.private_note())
            return "private";
    }, self);
    this.destroyed = ko.observable(false);
    this.physician_name;

    this.destroy = function() {
        this.destroyed(true);
        this.save();
    };

    ko.mapping.fromJS(attributes.assignment, {}, this);

    this.public_note.subscribe(function(newNote) {
        self.save();
    });

    this.private_note.subscribe(function(newNote) {
        self.save();
    });

    this.startEditing = function() {
        if (schedule == undefined) {
            return;
        }
        schedule.startEditing(this);
    };

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
            _destroy: self.destroyed()
        }
    };

    this.save = function() {
        if (schedule == undefined) {
            return;
        }
        schedule.save({ assignments: [self.serialize()] });
    };

    this.setSchedule = function(model) {
        schedule = model;
        schedule.editingAssignment.subscribe(function(newAssignment) {
            if (newAssignment != self) {
                self.inEditMode(false);
            }
        });
        var physician = schedule.findPhysician(this.physician_id());
        if (physician != undefined) {
            this.physician_name = physician.short_name();
        }
    };
}
