//= require jquery
//= require jquery_ujs
//= require bootstrap.min
//= require bootstrap_custom
//= require bootstrap-editable
//= require sortable
//= require jquery.remotipart

//TODO: вынести в отдельный js
$.fn.editable.defaults.mode = 'inline';
$.fn.editable.defaults.ajaxOptions = {type: "put"};
$.fn.editable.defaults.emptytext = 'Нет';

//TODO: вынести в отдельный js
$(document).on('ready', function() {
    $('.x-editable').editable();
   
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