$(document).ready(function () {
    //to create new event
    $(document).on('click', 'td.events', function () {
        if ($('div', this).length == 0) { //true if $(this) dont include divs
            newEvent($(this).data('date'), $(this).parent().data('timetable'));
            $('#addTo').removeAttr('id'); // must be only one 'addTo'
            $(this).attr('id', 'addTo'); // save td to add div.events
        }
    });
    $('div.events').draggable({
        containment: 'table',
        revert: 'invalid'
    });
    $('td.events').droppable({
        accept: 'div.events',
        tolerance: 'intersect',
        drop: function (event, ui) {
            if ($('div', this).length == 0) {
                $div = $(ui.draggable);
                $div.appendTo($(this));
                var event_id = $div.data('event');
                var date = $(this).data('date');
                var timetable_id = $(this).parent().data('timetable');
                moveEvent(event_id, date, timetable_id);
                $div.css({
                    'top': '0px',
                    'left': '0px'
                });
            } else {
                $(ui.draggable).animate({top: 0, left: 0}, 'slow'); //revert
            }
        }
    });
    //to edit event
    $(document).on('click', 'span.edit', function () {
        $('#upd').removeAttr('id');
        $(this).parent().parent().parent().attr('id', 'upd');

    });
    //to show groups_form with checkboxes
    $(document).on('click', '#add_groups', function () {
        $('#overlay').fadeIn(400,
            function () {
                $('#groups_form')
                    .css('display', 'block')
                    .animate({opacity: 1, top: '50%'}, 200);
            });
    });
    //to show to_json_form
    $(document).on('click', '.to_json', function () {
        $('#overlay').fadeIn(400,
            function () {
                $('#to_json_form')
                    .css('display', 'block')
                    .animate({opacity: 1, top: '50%'}, 200);
            });
    });
    //to show from_json_form and add #toAddFromJSON to timetable tr
    $(document).on('click', '.from_json', function () {
        $('#overlay').fadeIn(400,
            function () {
                $('#from_json_form')
                    .css('display', 'block')
                    .animate({opacity: 1, top: '50%'}, 200);
            });
        $('#toAddFromJSON').removeAttr('id');
        $(this).parent().parent().attr('id', 'toAddFromJSON');
    });
    //to hide forms
    $(".close, #from_json_submit, #overlay, input[name='commit']").click(function () {
        $('#events_form, #groups_form, #to_json_form, #from_json_form')
            .animate({opacity: 0, top: '45%'}, 200,
                function () {
                    $(this).css('display', 'none');
                    $('#overlay').fadeOut(400);
                }
            );
    });
    //to show download overlay
    $("#from_json_submit, input[value='Добавить'], input[value='Пересоздать']").click(function () {
        $('#download').fadeIn(400);
    });
    $('#check_all').click(function () {
        $('input[type=checkbox]').prop('checked', true);
    });
    $('#uncheck_all').click(function () {
        $('input[type=checkbox]').prop('checked', false);
    });
    $(document).on('click', '#from_json_submit', function () {
        if (confirm("Текущий учебный план будет удален. Вы уверены?")) {
            fromJSON($('#toAddFromJSON').data('timetable'), $('#from_json').val());
        } else {
            $('#download').fadeOut(400);
        }
    });
    //to paste template json to textarea
    $(document).on('click', '#template', function () {
        paste($('#templates').val());
    });
    // to delete template
    $(document).on('click', '#template_delete', function () {
        if (confirm("Удалить шаблон?")) {
            destroy($('#templates').val());
        }
    });
    // to fix group_number on horizontal scroll
    $(document).on('scroll', function () {
        var leftScroll = $(document).scrollLeft();
        $('.num').css({'left': leftScroll});
    });
    $(document).on('scroll', function () {
        var topScroll = $(document).scrollTop();
        $('th').css({'top': topScroll});
    });
    $(document).on('change', '#event_action', function () {
        tasks($('#event_action').val());
    });
    $(document).on('change', '#tema_action', function () {
        temas($('#tema_action').val());
    });
});
function newEvent(date, timetable_id) {
    $.ajax({
        type: "GET",
        url: "/events/new",
        data: "date=" + date + ";timetable_id=" + timetable_id
    });
}
function moveEvent(event_id, date, timetable_id) {
    $.ajax({
        type: "POST",
        url: "/events/move",
        data: "id=" + event_id + ";date=" + date + ";timetable_id=" + timetable_id
    });
}
function fromJSON(timetable_id, json) {
    $.ajax({
        type: "POST",
        url: "/timetables/" + timetable_id + "/from_json",
        data: "json=" + json
    });
}
function paste(template_id) {
    if (template_id != null) {
        $.ajax({
            type: "GET",
            url: "/timetables/paste",
            data: "id=" + template_id
        });
    }
}
function destroy(template_id) {
    if (template_id != null) {
        $.ajax({
            type: "DELETE",
            url: "/timetable_templates/" + template_id
        });
    }
}
function tasks(action) {
    if (action != null) {
        $.ajax({
            type: "POST",
            url: "/events/tasks",
            data: "s_action=" + action
        });
    }
}
function temas(tema) {
    if (tema != null) {
        $.ajax({
            type: "POST",
            url: "/events/tema",
            data: "tema=" + tema
        });
    }
}


