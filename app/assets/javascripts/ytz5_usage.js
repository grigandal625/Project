$(document).ready(function() {
    $.fn.editable.defaults.mode = 'inline';
    $.fn.editable.defaults.url = '';
    $.fn.editable.defaults.emptytext = 'Empty';
    $.fn.editable.defaults.inputclass = 'input-sm';

    $('.editable').editable();
});