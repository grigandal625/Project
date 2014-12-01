//= require jquery
//= require jquery_ujs
//= require bootstrap.min
//= require bootstrap_custom
//= require bootstrap-editable
//= require sortable
//= require tiltedpage-scroll
//= require jquery.remotipart

//TODO: вынести в отдельный js
$.fn.editable.defaults.mode = 'inline';
$.fn.editable.defaults.ajaxOptions = {type: "put"};
$.fn.editable.defaults.emptytext = 'Нет';

//TODO: вынести в отдельный js
$(document).on('ready', function() {
    $('.x-editable').editable();
    $("#pt_show_questionss").tiltedpage_scroll({
        sectionContainer: "section",     // In case you don't want to use <section> tag, you can define your won CSS selector here
        angle: 50,                         // You can define the angle of the tilted section here. Change this to false if you want to disable the tilted effect. The default value is 50 degrees.
        opacity: true,                     // You can toggle the opacity effect with this option. The default value is true
        scale: true,                       // You can toggle the scaling effect here as well. The default value is true.
        outAnimation: true                 // In case you do not want the out animation, you can toggle this to false. The defaul value is true.
    });
    $('.priority').sortable({
        itemSelector: '.list-group-item',
        placeholder: '<a class="list-group-item active">Переместить сюда</a>'
    });
    $('#pt_test_submit').click( function() {
        $form = $("#pt_show_questions");
        if (!$form[0].checkValidity()) {
            $('<input type="submit">').hide().appendTo($form).click().remove();
        }
        else {
            if (confirm("Вы уверены, что хотите завершить тест?")) {
                $form.submit();
            }
        }
    })
});