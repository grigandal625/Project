$(document).ready(function() {
    $.fn.editable.defaults.mode = 'inline';
    //$.fn.editable.defaults.showbuttons = false;
    $.fn.editable.defaults.type = 'text';
    $.fn.editable.defaults.url = '';
    $.fn.editable.defaults.emptytext = 'Empty';
    $.fn.editable.defaults.inputclass = 'input-sm';

    $('.edit_task').editable();
    $('#level').editable({
        url: '',
        mode: 'popup',
        value: 1,
        source: [{
            value: 0,
            text: 'Легкий'
        }, {
            value: 1,
            text: 'Средний'
        }, {
            value: 2,
            text: 'Сложный'
        }]
    });

    $(document).keydown(function(evt) {
      //var tmp = $('.editable-input textarea');
        if ($('.editable-input textarea').length)
            if (evt.keyCode == 32) {
                //console.log($(this));
                evt.preventDefault();
                var tmp = $('.editable-input textarea').val()
                $('.editable-input textarea').val(tmp + " ");
            }
        if ($('.input-sm').length){
          if (evt.keyCode == 32) {
                //console.log($(this));
                evt.preventDefault();
                var tmp = $('.input-sm').val()
                $('.input-sm').val(tmp + " ");
            }
        }
    });

    $('#hint').editable({
        url: '',
        mode: 'popup',
        title: 'Введите подсказку',
        rows: 5,
        emptytext: 'Введите подсказку'
    });

    $("#add_row").click(function() {
        $("#rows").append(atob('PHRyPjx0ZD48YnV0dG9uIGNsYXNzPSJidG4gYnRuLWRlZmF1bHQgdGFzayI+PHNtYWxsPjxhIGhyZWY9IiMiIGRhdGEtcGs9IjEiIGNsYXNzPSJlZGl0X3Rhc2siIGRhdGEtdHlwZT0idGV4dCIgZGF0YS10aXRsZT0iRGVwYXJ0bWVudCBuYW1lIiBkYXRhLWVtcHR5PSJFbXB0eSIgZGF0YS1uYW1lPSJkZXBhcnRtZW50Ij5UaXRsZTwvYT48L3NtYWxsPjwvYnV0dG9uPjwvdGQ+PHRkPjxjZW50ZXI+PC0tPjwvY2VudGVyPjwvdGQ+PHRkPjxidXR0b24gY2xhc3M9ImJ0biBidG4tZGVmYXVsdCB0YXNrIj48c21hbGw+PGEgaHJlZj0iIyIgZGF0YS1waz0iMSIgY2xhc3M9ImVkaXRfdGFzayIgZGF0YS10eXBlPSJ0ZXh0IiBkYXRhLXRpdGxlPSJEZXBhcnRtZW50IG5hbWUiIGRhdGEtZW1wdHk9IkVtcHR5IiBkYXRhLW5hbWU9ImRlcGFydG1lbnQiPlRpdGxlPC9hPjwvc21hbGw+PC9idXR0b24+PC90ZD48dGQ+PHNtYWxsPjxjZW50ZXI+PGJ1dHRvbiBpZD0icm93X2RlbCIgdHlwZT0iYnV0dG9uIiBjbGFzcz0iYnRuIGJ0bi1kYW5nZXIgYnRuLXhzIiB2YWx1ZT0iMSI+ZGVsPC9idXR0b24+PC9jZW50ZXI+PC9zbWFsbD48L3RkPjwvdHI+'));
        $("#table tbody tr:last .edit_task").editable();
    });

    $("#done").click(function() {
        var data = $(".edit_task");
        //var counter = 1;
        var json = {};
        var left = [];
        var right = [];
        for (var i = 0; i < data.length - 1; i += 2) {
            //console.log((counter++) + ") " + data[i].firstChild.data + ": " + data[i + 1].firstChild.data);
            left.push(data[i].firstChild.data);
            right.push(data[i + 1].firstChild.data);
        }
        json.left = left;
        json.right = right;
        //var tmp = $('#level').editable();
        json.hint = $('#hint')[0].text;
        json.level = $('#level').editable()[0].text; //change this into id
        json.topic_id = $('#select_topic').val();
        $.ajax({
            type: "POST",
            url: "/matching_utz",
            data: json,
            success: function(msg){
                alert( "Задание создано успешно" );
            }
        });
    });

    $('body').on('click', 'button#row_del', function(event) {
        event.preventDefault();
        var id = $(this).attr('value');

        $(this).parent().parent().parent().parent().remove();
    });
});
