var shiftDay = function(attributes) {
    var schedule = undefined;
    var mapping = {
        "assignments": {
            create: function(options) {
                return new assignment(options.data);
            },
            key: function(data) {
                return ko.utils.unwrapObservable(data.date) + ko.utils.unwrapObservable(data.physician_id) + ko.utils.unwrapObservable(data.shift_id);
            }
        }
    };

    this.assignments = ko.observableArray([]);
    this.inSelectedMode = ko.observable(false);
    this.inHoverMode = ko.observable(false);

    this.toggleSelected = function() {
        if (schedule == undefined) {
            return;
        }
        schedule.toggleSelectedShiftDay(this);
    };

    this.setSchedule = function(model) {
        schedule = model;
        for (var i = 0; i < this.assignments().length; i++) {
            this.assignments()[i].setSchedule(schedule);
        }
    };

    var self = this;
    this.addAssignment = function(assignment) {
        if (self.assignments.indexOf(assignment) != -1) {
            self.assignments.remove(assignment);
            self.assignments.push(assignment);
            return;
        }
        self.assignments.push(assignment);
        assignment.date(self.date());
        assignment.shift_id(self.shift_id());
    }

    ko.mapping.fromJS(attributes, mapping, this);
}
