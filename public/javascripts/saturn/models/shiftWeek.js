var shiftWeek = function(attributes, viewModel) {
    var self = this;
    var schedule = viewModel;
    var mapping = {
        "shift_days": {
            create: function(options) {
                return new shiftDay(options.data, schedule);
            }
        }
    };

    ko.mapping.fromJS(attributes, mapping, this);

    if (this.shift_week_note.text() == "") {
        this.shift_week_note.text("add note...");
    }

    var lastNote = this.shift_week_note.text();
    this.shift_week_note.text.subscribe(function(newNote) {
        if (newNote == "add note..." || newNote == lastNote) {
            return;
        }
        lastNote = newNote;
        self.save();
        if (newNote == "") {
            self.shift_week_note.text("add note...");
        }
    });

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
}
