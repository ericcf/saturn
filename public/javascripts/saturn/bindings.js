// The primary purpose of these bindings is to coordinate communication between jQuery
// UI events and Knockout view models

$(function() {
    var currentlyDragging = null;
    var currentlyReceiving = null;

    $("#is-published").button();

    $("#physician-groups")
        .dialog({
            autoOpen: false,
            title: "Select a physician to assign",
            open: function(event, ui) {
            },
            close: function(event, ui) {
                viewModel.deselectShiftDays();
            }
        })
        .delegate("a.physician-name", "hover", function() {
            $(this).toggleClass("ui-state-hover");
        })
        .delegate("a.physician-name", "click", function() {
            $("#physician-groups").dialog("close");
        });

    $("#assignment-details")
        .dialog({
            autoOpen: false,
            close: function(event, ui) {
                viewModel.stopEditing();
            },
            buttons: {
                "Ok": function() { $(this).dialog("close") },
                "Delete assignment": function() {
                    viewModel.editingAssignment().destroy();
                    $(this).dialog("close");
                }
            }
        });

    $("#date-selector")
        .datepicker({
            dateFormat: 'yy-mm-dd',
            changeMonth: true,
            changeYear: true,
            numberOfMonths: 3,
            stepMonths: 2,
            showButtonPanel: true,
            onSelect: function(dateText, inst) {
                $(this).val(" select date...");
                loadWeeklySchedule(dateText, function(data) {
                    viewModel.updateFromJS(data);
                });
                location.hash = "#" + dateText;
            }
        });

    function openDetailsDialog(options) {
        $("#assignment-details")
            .dialog("option", "title", options.title)                   
            .dialog('open');
    }

    function openDirectoryDialog() {
                $("#physician-groups").tabs("destroy");
                $("#physician-groups").tabs();
        if ($("#physician-groups").dialog("isOpen")) return;
        $("#physician-groups").dialog("open");
    }

    function closeDirectoryDialog() {
        if (!$("#physician-groups").dialog("isOpen")) return;
        $("#physician-groups").dialog("close");
    }

    ko.bindingHandlers.ajaxLifecycle = {
        init: function(element, valueAccessor, allBindingsAccessor, viewModel) {
            $(element).ajaxSend(function() {
                viewModel.ajaxStatus("sending");
            });
            $(element).ajaxComplete(function() {
                viewModel.ajaxStatus("complete");
            });
        }
    };

    ko.bindingHandlers.showFlash = {
        init: function(element, valueAccessor, allBindingsAccessor, shiftDay) {
            $.fn.showFlashMessage();
        },
        update: function(element, valueAccessor, allBindingsAccessor, shiftDay) {
            $.fn.showFlashMessage();
        }
    };

    ko.bindingHandlers.openDirectoryDialog = {
        update: function(element, valueAccessor, allBindingsAccessor, shiftDay) {
            var value = valueAccessor();
            var shiftDayIsSelected = ko.utils.unwrapObservable(value);
            if (shiftDayIsSelected == true) {
                openDirectoryDialog();
            }
        }
    };

    ko.bindingHandlers.directoryDialogVisibility = {
        update: function(element, valueAccessor, allBindingsAccessor, viewModel) {
            var value = valueAccessor();
            var selectedShiftDays = ko.utils.unwrapObservable(value);
            if (selectedShiftDays.length == 0) {
                closeDirectoryDialog();
            } else {
                openDirectoryDialog();
            }
        }
    };

    ko.bindingHandlers.shiftDayDropping = {
        init: function(element, valueAccessor, allBindingsAccessor, shiftDay) {
            $(element)
                .bind("drop", function(event, assignmentElement) {
                    assignmentElement.style.display = "none";
                    viewModel.assignmentDroppedOn(shiftDay);
                })
                .bind("dropover", function(event) {
                    currentlyReceiving = shiftDay;
                    $(element).addClass("ui-state-highlight");
                })
                .bind("dropout", function(event) {
                    if (currentlyReceiving == shiftDay) {
                        currentlyReceiving = null;
                    }
                    $(element).removeClass("ui-state-highlight");
                });
        }
    };

    ko.bindingHandlers.assignmentDragging = {
        init: function(element, valueAccessor, allBindingsAccessor, assignment) {
            var lastReceiver = null;
            $(element)
                .bind("drag", function(event) {
                    viewModel.startDragging(assignment);
                    $(this).hide();
                    var receiver = document.elementFromPoint(event.clientX, event.clientY);
                    if ($(receiver).hasClass("shiftDay")) {
                        $(receiver).trigger("dropover");
                    }
                    $(this).show();
                    if (lastReceiver != null && lastReceiver != receiver) {
                        $(lastReceiver).trigger("dropout");
                    }
                    lastReceiver = receiver;
                })
                .bind("dragstop", function(event) {
                    $(this).remove();
                    var receiver = document.elementFromPoint(event.clientX, event.clientY);
                    if ($(receiver).hasClass("shiftDay")) {
                        $(receiver).trigger("drop", element);
                    } else {
                        $(this).show();
                    }
                    viewModel.stopDragging(assignment);
                    if (viewModel.editingAssignment() == assignment) {
                        assignment.inEditMode(false);
                    }
                })
                .draggable({
                    revert: function(wookiee) {
                        return currentlyReceiving == null;
                    },
                    start: function(event, ui) {
                        $(this).data("ignore-click", true);
                    },
                    // the dragging assignment appears above other assignments
                    stack: "div.assignment"
                });
        }
    };

    ko.bindingHandlers.openDetailsDialog = {
        update: function(element, valueAccessor, allBindingsAccessor, assignment) {
            var value = valueAccessor();
            var assignmentIsInEditMode = ko.utils.unwrapObservable(value);
            if (assignmentIsInEditMode == true) {
                openDetailsDialog({ title: assignment.physician_name });
            }
        }
    };

    ko.bindingHandlers.mouseover = {
        init: function(element, valueAccessor, allBindingsAccessor, viewModel) {
            var callback = valueAccessor();
            $(element).mouseover(function(event) {
                callback(event);
            });
        }
    };

    ko.bindingHandlers.mouseout = {
        init: function(element, valueAccessor, allBindingsAccessor, viewModel) {
            var callback = valueAccessor();
            $(element).mouseout(function(event) {
                callback(event);
            });
        }
    };

    ko.bindingHandlers.focus = {
        init: function(element, valueAccessor, allBindingsAccessor, viewModel) {
            var callback = valueAccessor();
            $(element).focus(function(event) {
                callback(event);
            });
        }
    };

    ko.bindingHandlers.blur = {
        init: function(element, valueAccessor, allBindingsAccessor, viewModel) {
            var callback = valueAccessor();
            $(element).blur(function(event) {
                callback(event);
            });
        }
    };
});
