var ruleConflicts = function(attributes) {
    // private attributes

    var schedule;
    var self = this;

    // public attributes

    // public methods

    this.setSchedule = function(model) {
        schedule = model;
    }

    ko.mapping.fromJS(attributes, {}, this);
};
