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
//= require jquery.hoverIntent
//= require lootPopup
//= require_self

$(function () {
    // Sorting and pagination links.
    $('#player_list th a, #player_list .pagination a').live('click',
        function () {
            $.getScript(this.href);
            return false;
        }
    );
    $('#player_stats th a, #player_stats .pagination a').live('click',
        function () {
            $.getScript(this.href);
            return false;
        }
    );

    // Search form.
    $('#players_search').submit(function () {
            $.get(this.action, $(this).serialize(), null, 'script');
            return false;
        }
    );
});