$(document).ready(function() {
    $.fn.editable.defaults.mode = 'inline';
    //$.fn.editable.defaults.showbuttons = false;
    $.fn.editable.defaults.type = 'text';
    $.fn.editable.defaults.url = '';
    $.fn.editable.defaults.emptytext = 'Empty';
    $.fn.editable.defaults.inputclass = 'input-sm';

    $('.edit_task').editable();

    $("#add_row").click(function() {
        $("#rows").append(atob('PHRyIGNsYXNzPSJhbnN3ZXIiPjx0ZD48Y2VudGVyPjxpbnB1dCB0eXBlPSJjaGVja2JveCIgYXJpYS1sYWJlbD0iLi4uIj48L2NlbnRlcj48L3RkPjx0ZD48YnV0dG9uIGNsYXNzPSJidG4gYnRuLWRlZmF1bHQgdGFzayI+PHNtYWxsPjxhIGhyZWY9IiMiIGRhdGEtcGs9IjEiIGNsYXNzPSJlZGl0X3Rhc2siIGRhdGEtdHlwZT0idGV4dCIgZGF0YS10aXRsZT0iRGVwYXJ0bWVudCBuYW1lIiBkYXRhLWVtcHR5PSJFbXB0eSIgZGF0YS1uYW1lPSJkZXBhcnRtZW50Ij48L2E+PC9zbWFsbD48L2J1dHRvbj48L3RkPjx0ZD48c21hbGw+PGNlbnRlcj48YnV0dG9uIGlkPSJyb3dfZGVsIiB0eXBlPSJidXR0b24iIGNsYXNzPSJidG4gYnRuLWRhbmdlciBidG4teHMgZGVsIiBzdHlsZT0iZGlzcGxheTogaW5saW5lLWJsb2NrOyIgdmFsdWU9IjEiPmRlbDwvYnV0dG9uPjwvY2VudGVyPjwvc21hbGw+PC90ZD48L3RyPg=='));
        $("#table tbody tr:last .edit_task").editable();
    });

    $('body').on('click', 'button#row_del', function(event) {
        event.preventDefault();
        var id = $(this).attr('value');

        $(this).parent().parent().parent().parent().remove();
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

    $("#done").click(function() {
        var q = $("#question");
        var rows = $(".answer");
        //var counter = 1;
        var json = {};
        var answers = [];
        json.question = q[0].firstChild.data;

        for (var i = 0; i < rows.length; ++i) {
            //console.log((counter++) + ") " + data[i].firstChild.data + ": " + data[i + 1].firstChild.data);
            var answer = {}
            answer.correct = rows[i].children[0].children[0].children[0].checked;
            answer.text = rows[i].children[1].children[0].innerText;
            answers.push(answer);
        }
        json.answers = answers;
        //var tmp = $('#level').editable();
        //json.hint = $('#hint')[0].text;
        //json.level = $('#level').editable()[0].text; //change this into id
        $.ajax({
            type: "POST",
            url: "/test_utz_questions",
            data: json,
            success: function(msg){
                alert( "Task was successfully created" );
            }
        });
    });

});
