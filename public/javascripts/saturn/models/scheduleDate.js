var scheduleDate = function(attributes) {
    ko.mapping.fromJS(attributes, {}, this);

    // private

    var shortDays = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"];

    // observables

    this.shortDate = ko.dependentObservable(function() {
        var date = new Date(this.year(), this.month()-1, this.day());
        return shortDays[date.getDay()] + " " + (date.getMonth()+1) + "/" + date.getDate();
    }, this);
};
