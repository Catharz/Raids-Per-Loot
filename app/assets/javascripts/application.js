// This is a manifest file that'll be compiled into including all the files listed below.
// Add new JavaScript/Coffee code in separate files in this directory and they'll automatically
// be included in the compiled file accessible from http://example.com/assets/application.js
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
//= require jquery
//= require jquery-ui
//= require jquery_ujs
//= require jquery.dataTables
//= require ddsmoothmenu
//= require jquery.jeditable
//= require cocoon
//= require menus
//= require datepickers
//= require selects
//= require buttons
//= require popup
//= require tables
//= require tabs

function hideShowColumn(button_name, table, iCol) {
    var oTable = $(table).dataTable();
    var bVis = oTable.fnSettings().aoColumns[iCol].bVisible;
    oTable.fnSetColumnVis(iCol, bVis ? false : true);
    var button = $(button_name);
    if (bVis) {
        button.removeClass('ui-state-default');
        button.addClass('ui-state-disabled');
    } else {
        button.removeClass('ui-state-disabled');
        button.addClass('ui-state-default');
    }
    return true;
}

function clearFlash() {
    var div;
    div = $('#error');
    if (div.length) {
        div.remove();
    }
    div = $('#notice');
    if (div.length) {
        div.remove();
    }
    return true;
}

function displayFlash(flash, message) {
    clearFlash();
    var divId = '#' + flash;
    if ($(divId).length === 0) {
        $('#content').prepend('<div id=' + flash + '/>');
    }
    $(divId).empty().append('<p style="float:right;">' +
        '<a href="#" onclick="$(\'' + divId + '\').fadeOut(); return false;">X</a></p>' +
        '<p>' + message + '</p>' +
        '<div class="clear"></div>');
    return true;
}

function parseErrors(errors) {
    var error_list, field, message, messages, _i, _len;

    error_list = [];

    for (field in errors) {
        if (errors.hasOwnProperty(field)) {
            messages = errors[field];
            for (_i = 0, _len = messages.length; _i < _len; _i++) {
                message = messages[_i];
                error_list.push(field + ': ' + message);
            }
        }
    }
    return error_list.join("</br>");
}