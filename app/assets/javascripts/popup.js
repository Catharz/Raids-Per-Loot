$(document).ready(function () {
    var hideDelay = 500;
    var currentID;
    var hideTimer = null;
    var ajaxCall = null;

    // One instance that's re-used to show info for the current process
    var container = $('<div id="popupContainer">'
        + '<table width="" border="0" cellspacing="0" cellpadding="0" align="center" class="popupPopup">'
        + '<tr>'
        + '   <td class="corner topLeft"></td>'
        + '   <td class="top"></td>'
        + '   <td class="corner topRight"></td>'
        + '</tr>'
        + '<tr>'
        + '   <td class="left">&nbsp;</td>'
        + '   <td><div id="popupContent"></div></td>'
        + '   <td class="right">&nbsp;</td>'
        + '</tr>'
        + '<tr>'
        + '   <td class="corner bottomLeft">&nbsp;</td>'
        + '   <td class="bottom">&nbsp;</td>'
        + '   <td class="corner bottomRight"></td>'
        + '</tr>'
        + '</table>'
        + '</div>');

    $('body').append(container);

    $('.itemPopupTrigger').live('mouseover', function () {
        if (ajaxCall) {
            ajaxCall.abort();
            ajaxCall = null;
        }

        currentID = this.id;
        // If no guid in url rel tag, don't popup blank
        if (currentID == '')
            return;

        if (hideTimer)
            clearTimeout(hideTimer);

        var pos = $(this).offset();
        var width = $(this).width();
        container.css({
            left:(pos.left + width) + 'px',
            top:(pos.top - 5) + 'px'
        });

        $('#popupContent').html('&nbsp;');

        ajaxCall = $.ajax({
            type:'GET',
            url:'items/' + currentID + '/info',
            beforeSend: function () {
              $("#popupContent").prepend('<p class="loading-text">Loading item details...</p>');
            },
            success:function (data) {
                // Verify that we're pointed to a page that returned the expected results.
                if (data.indexOf('itemPopupResult') < 0) {
                    $('#popupContent').html('<span >Did not return a valid result for item id ' + currentID + '.  Please have your administrator check the error log.</span>');
                }

                // Verify requested item is this item since we could have multiple ajax
                // requests out if the server is taking a while.
                if (data.indexOf(currentID) > 0) {
                    $("#popupContent").empty();
                    $("#popupContent").append(data);
                }
            },
            complete: function () {
              $('.loading-text').remove();
            }
        });

        container.css('display', 'block');
    });

    $('.itemPopupTrigger').live('mouseout', function () {
        if (hideTimer)
            clearTimeout(hideTimer);
        hideTimer = setTimeout(function () {
            container.css('display', 'none');
        }, hideDelay);
    });

    $('.characterPopupTrigger').live('mouseover', function () {
        if (ajaxCall) {
            ajaxCall.abort();
            ajaxCall = null;
        }

        currentID = this.id;
        // If no guid in url rel tag, don't popup blank
        if (currentID == '')
            return;

        if (hideTimer)
            clearTimeout(hideTimer);

        var pos = $(this).offset();
        var width = $(this).width();
        container.css({
            left:(pos.left + width) + 'px',
            top:(pos.top - 5) + 'px'
        });

        $('#popupContent').html('&nbsp;');

        ajaxCall = $.ajax({
            type:'GET',
            url:'characters/' + currentID + '/info',
            beforeSend:function () {
                $("#popupContent").prepend('<p class="loading-text">Loading character details...</p>');
            },
            success:function (data) {
                // Verify that we're pointed to a page that returned the expected results.
                if (data.indexOf('characterPopupResult') < 0) {
                    $('#popupContent').html('<span >Did not return a valid result for character ' + currentID + '.  Please have your administrator check the error log.</span>');
                }

                // Verify requested character is this character since we could have multiple ajax
                // requests out if the server is taking a while.
                if (data.indexOf(currentID) > 0) {
                    $("#popupContent").empty();
                    $("#popupContent").append(data);
                }
            },
            complete:function () {
                $('.loading-text').remove();
            }
        });

        container.css('display', 'block');
    });

    $('.characterPopupTrigger').live('mouseout', function () {
        if (hideTimer)
            clearTimeout(hideTimer);
        hideTimer = setTimeout(function () {
            container.css('display', 'none');
        }, hideDelay);
    });

    // Allow mouse over of data without hiding data
    $('#popupContainer').mouseover(function () {
        if (hideTimer)
            clearTimeout(hideTimer);
    });

    // Hide after mouseout
    $('#popupContainer').mouseout(function () {
        if (hideTimer)
            clearTimeout(hideTimer);
        hideTimer = setTimeout(function () {
            container.css('display', 'none');
        }, hideDelay);
    });
});