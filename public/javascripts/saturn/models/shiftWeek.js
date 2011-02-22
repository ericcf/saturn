var shiftWeek = function(attributes) {
    var self = this;
    var schedule = undefined;
    var mapping = {
        "shift_days": {
            create: function(options) {
                return new shiftDay(options.data);
            },
            key: function(data) {
                return ko.utils.unwrapObservable(data.date);
            }
        }
    };

    this.shift_week_note = {
        text: ko.observable(undefined),
        shift_id: ko.observable(undefined)
    };

    this.setSchedule = function(model) {
        schedule = model;
        for (var i = 0; i < this.shift_days().length; i++) {
            this.shift_days()[i].setSchedule(schedule);
        }
    };

    this.removeShiftDays = function() {
        this.shift_days.remove(function(shiftDay) {
            shiftDay.assignments.removeAll();
            return true;
        });
    };

    this.serialize = function() {
        var serialized = {
            shift_id: self.shift_week_note.shift_id(),
            text: self.shift_week_note.text(),
            _destroy: self.shift_week_note.text() == ""
        };
        if (self.shift_week_note.id != undefined) {
            serialized.id = self.shift_week_note.id();
        }
        return serialized;
    };

    this.save = function() {
        schedule.save({ shift_week_notes_attributes: [self.serialize()] });
    };

    ko.mapping.fromJS(attributes, mapping, this);

    if (this.shift_week_note.text() == "") {
        this.shift_week_note.text("add note...");
    }
    var lastNote = this.shift_week_note.text();
    this.shift_week_note.text.subscribe(function(newNote) {
        if (newNote == "add note..." || newNote == lastNote || newNote == "" && self.shift_week_note.id == undefined) {
            lastNote = newNote;
            if (newNote == "") {
                self.shift_week_note.text("add note...");
            }
            return;
        }
        lastNote = newNote;
        self.save();
        if (newNote == "") {
            self.shift_week_note.text("add note...");
        }
    });
};
