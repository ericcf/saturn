var shiftDay = function(attributes) {
    // private
    
    var self = this;
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

    // observables

    this.assignments = ko.observableArray([]);
    this.inSelectedMode = ko.observable(false);
    this.inHoverMode = ko.observable(false);

    // public methods

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

    this.addAssignment = function(assignment) {
        if (self.assignments.indexOf(assignment) != -1) {
            self.assignments.remove(assignment);
            self.assignments.push(assignment);
            return;
        }
        self.assignments.push(assignment);
        assignment.date(self.date());
        assignment.shift_id(self.shift_id());
    };

    this.hasDuplicate = function(assignment) {
        for (var i = 0; i < self.assignments().length; i++) {
            if (self.assignments()[i].physician_id() == assignment.physician_id()) {
                return true;
            }
        }
        return false;
    };

    ko.mapping.fromJS(attributes, mapping, this);
}
