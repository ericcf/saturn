var shiftWeek = function(attributes, viewModel) {
    var schedule = viewModel;;
    var mapping = {
        "shift_days": {
            create: function(options) {
                  return new shiftDay(options.data, schedule);
            }
        }
    };
    ko.mapping.fromJS(attributes, mapping, this);
}
