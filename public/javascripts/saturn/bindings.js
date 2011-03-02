// The primary purpose of these bindings is to coordinate communication between jQuery
// UI events and Knockout view models

$(function() {
    var currentlyReceiving = null;

    ko.bindingHandlers.button = {
        init: function(element, valueAccessor, allBindingsAccessor, viewModel) {
            $(element).button();
        }
    };

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

    ko.bindingHandlers.dateSelector = {
        init: function(element, valueAccessor, allBindingsAccessor, viewModel) {
            $(element)
                .datepicker({
                    dateFormat: 'yy-mm-dd',
                    changeMonth: true,
                    changeYear: true,
                    numberOfMonths: 3,
                    stepMonths: 2,
                    showButtonPanel: true,
                    onSelect: function(dateText, inst) {
                        $(this).val(" select date...");
                        location.hash = "#" + dateText;
                        location.reload();
                    }
                });
        }
    };

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
                    currentlyReceiving = null;
                })
                .bind("dropover", function(event) {
                    if (!shiftDay.hasDuplicate(viewModel.draggingAssignment())) {
                      currentlyReceiving = shiftDay;
                      $(element).addClass("ui-state-highlight");
                    }
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
            function getReceiver(dragging, event) {
                $(dragging).hide();
                var receiverElem = document.elementFromPoint(event.clientX, event.clientY);
                var receiver = $(receiverElem);
                if (!receiver.hasClass("shiftDay")) {
                    receiver = receiver.parents(".shiftDay");
                }
                $(dragging).show();
                return receiver;
            }

            $(element)
                .bind("drag", function(event) {
                    viewModel.startDragging(assignment);
                    var receiver = getReceiver(this, event);
                    if (receiver.hasClass("shiftDay")) {
                        receiver.trigger("dropover");
                    }
                    if (lastReceiver != null && lastReceiver[0] != receiver[0]) {
                        lastReceiver.trigger("dropout");
                    }
                    lastReceiver = receiver;
                })
                .bind("dragstop", function(event) {
                    if (currentlyReceiving && !currentlyReceiving.hasDuplicate(assignment)) {
                        var receiver = getReceiver(this, event);
                        if ($(receiver).hasClass("shiftDay")) {
                            $(this).remove();
                            $(receiver).trigger("drop", element);
                        }
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
