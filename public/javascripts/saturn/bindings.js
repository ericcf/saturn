// The primary purpose of these bindings is to coordinate communication between jQuery
// UI events and Knockout view models

$(function() {
    var currentlyDragging = null;

    $("input#is-published").button();

    function setIsHighlighted(elem, value) {
        if (currentlyDragging == null) {
            if (value) {
                $(elem).addClass("ui-state-highlight");
            } else {
                $(elem).removeClass("ui-state-highlight");
            }
        }
    }

    function setIsActive(elem, value) {
        if (value == true) {
            setIsHighlighted(elem, false);
            $(elem).addClass("ui-state-active");
        } else {
            $(elem).removeClass("ui-state-active");
        }
    }

    ko.bindingHandlers.anchorHref = {
        init: function(element, valueAccessor, allBindingsAccessor, viewModel) {
            var value = valueAccessor();
            $(element).attr("href", "#" + ko.utils.unwrapObservable(value));
        }
    };

    ko.bindingHandlers.elementId = {
        init: function(element, valueAccessor, allBindingsAccessor, viewModel) {
            var value = valueAccessor();
            $(element).attr("id", ko.utils.unwrapObservable(value));
        }
    };

    ko.bindingHandlers.tabsUI = {
        init: function(element, valueAccessor, allBindingsAccessor, viewModel) {
            $(element).tabs();
        }
    };

    ko.bindingHandlers.dateSelectorUI = {
        init: function(element, valueAccessor, allBindingsAccessor, viewModel) {
            $(element).datepicker({
                dateFormat: 'yy-mm-dd',
                changeMonth: true,
                changeYear: true,
                numberOfMonths: 3,
                stepMonths: 2,
                showButtonPanel: true,
                onSelect: function(dateText, inst) {
                    $(element).val(" jump to date...");
                    loadWeeklySchedule(dateText, function(data) {
                        viewModel.updateFromJS(data);
                    });
                    location.hash = "#" + dateText;
                }
            });
        }
    };

    ko.bindingHandlers.shiftDayMousing = {
        init: function(element, valueAccessor, allBindingsAccessor, shiftDay) {
            $(element)
                .bind("mouseover", function() {
                    setIsHighlighted(element, true);
                })
                .bind("mouseout", function() {
                    if (!shiftDay.selected()) {
                        setIsHighlighted(element, false);
                    }
                })
                .click(function() {
                    $("div#physician-groups").dialog("open");
                });
        }
    };
    
    ko.bindingHandlers.shiftDayDropping = {
        init: function(element, valueAccessor, allBindingsAccessor, shiftDay) {
            $(element)
                .bind("drop", function(event, ui) {
                    ui.draggable.hide();
                    shiftDay.addAssignment(currentlyDragging);
                    currentlyDragging.save();
                    if (shiftDay.assignments.indexOf(currentlyDragging) == -1) {
                        ui.draggable.remove();
                    }
                    currentlyDragging = null;
                })
                .droppable({
                    accept: "div.assignment",
                    hoverClass: "ui-state-highlight",
                    activeClass: "ui-state-active"
                });
        }
    };

    ko.bindingHandlers.assignmentDragging = {
        init: function(element, valueAccessor, allBindingsAccessor, assignment) {
            $(element)
                .bind("drag", function(event) {
                    currentlyDragging = assignment;
                })
                .bind("dragstop", function() {
                    currentlyDragging = null;
                    if (viewModel.editingAssignment() == assignment) {
                        assignment.inEditMode(false);
                    }
                })
                .draggable({
                    revert: "invalid",
                    start: function(event, ui) {
                        $(this).data("ignore-click", true);
                        setIsActive(element, true);
                        assignmentDrag = true;
                    },
                    stop: function() {
                        setIsActive(element, false);
                        setIsHighlighted(element, false);
                        assignmentDrag = false;
                    },
                    // the dragging assignment appears above other assignments
                    stack: "div.assignment"
                });
        }
    };

    ko.bindingHandlers.assignmentMousing = {
        init: function(element, valueAccessor, allBindingsAccessor, assignment) {
            $(element)
                .bind("mouseleave", function(event) {
                    if (!assignment.inEditMode()) {
                        setIsHighlighted(element, false);
                    }
                })
                .bind("mouseover", function(event) {
                    if (currentlyDragging == null) {
                        setIsHighlighted(element, true);
                    }
                    if (viewModel.selectedShiftDays().length == 0) {
                        event.stopPropagation();
                        setIsHighlighted("td.shiftDay.ui-state-highlight", false);
                    }
                })
                .click(function(event) {
                    if ($(this).data("ignore-click") != undefined) {
                        $(this).removeData("ignore-click");
                        return;
                    }
                    event.stopPropagation();
                    $("div#assignment-details")
                        .dialog("option", "title", assignment.physician_name()())
                        .dialog('open');
                });
        }
    };

    ko.bindingHandlers.physicianGroupsDialog = {
        init: function(element, valueAccessor, allBindingsAccessor, viewModel) {
            $(element)
                .dialog({
                    autoOpen: false,
                    title: "Select a physician to assign",
                    close: function(event, ui) {
                        viewModel.deselectShiftDays();
                    }
                })
                .find("a").hover(function() {
                    $(this).addClass("ui-state-hover")
                }, function() {
                    $(this).removeClass("ui-state-hover")
                });
        }
    };

    ko.bindingHandlers.assignmentDetailsDialog = {
        init: function(element, valueAccessor, allBindingsAccessor, viewModel) {
            $(element)
                .dialog({
                    autoOpen: false,
                    close: function(event, ui) {
                        viewModel.editingAssignment().inEditMode(false);
                    },
                    buttons: {
                        "Ok": function() { $(this).dialog("close") },
                        "Delete assignment": function() {
                            viewModel.editingAssignment().destroy();
                            $(this).dialog("close");
                        }
                    }
                });
        }
    };
});
