var shiftDay = function(attributes, viewModel) {
    var schedule = viewModel;
    var mapping = {
        "assignments": {
            create: function(options) {
                return new assignment(options.data, schedule);
            },
            key: function(data) {
                return ko.utils.unwrapObservable(data.id);
            }
        }
    };
    ko.mapping.fromJS(attributes, mapping, this);

    this.selected = ko.observable(false);

    var self = this;
    this.addAssignment = function(assignment) {
        if (self.assignments.indexOf(assignment) != -1) {
            self.assignments.remove(assignment);
            self.assignments.push(assignment);
            assignment.inEditMode(false);
            return;
        }
        self.assignments.push(assignment);
        assignment.date(self.date());
        assignment.shift_id(self.shift_id());
    }
}
