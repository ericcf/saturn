var ruleConflicts = function(attributes) {
    var schedule;
    var self = this;

    this.setSchedule = function(model) {
        schedule = model;
    }

    ko.mapping.fromJS(attributes, {}, this);
};
