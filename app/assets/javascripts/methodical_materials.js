//= require jquery
//= require bootstrap.min
//= require tooltip

$(function () {
            $("[data-toggle='tooltip']").tooltip();
        });

$("#menu-toggle").click(function(e) {
        e.preventDefault();
        $("#wrapper").toggleClass("toggled");
    });

$("#menu-toggle-2").click(function(e) {
        e.preventDefault();
        $("#wrapper").toggleClass("toggled");
    });

// $( document ).ready(function(){
// 		CKEDITOR.inline("lol");
// });