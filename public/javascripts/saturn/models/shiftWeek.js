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

    this.shift_note.subscribe(function(newNote) {
        self.save();
    });

    this.serialize = function() {
        return {
            shift_id: self.shift_id(),
            text: self.shift_note()
        }
    };

    this.save = function() {
        schedule.save({ shift_week_notes_attributes: [self.serialize()] });
    };
}
