$(document).ready(function () {
  $(document).on('click', 'td.events', function () {
    if ($('div', this).length == 0) { //true if $(this) dont include divs
      $('#overlay').fadeIn(400,
        function () {
          $('#events_form')
            .css('display', 'block')
            .animate({opacity: 1, top: '50%'}, 200);
        });
      $('.event_hidden').hide();
      $("input[name='event[timetable_id]']").val($(this).parent().data('timetable')); // submit timetable_id and week in db by ror form
      $("input[name='event[week]']").val($(this).data('week'));
      $(this).attr('id', 'addTo'); // save td to add div.events
    }
    ;
  });
  $(document).on('click', '#add_groups', function () {
    $('#overlay').fadeIn(400,
      function () {
        $('#groups_form')
          .css('display', 'block')
          .animate({opacity: 1, top: '50%'}, 200);
      });
  });
  $(document).on('click', '.to_json', function () {
    $('#overlay').fadeIn(400,
        function () {
          $('#to_json_form')
              .css('display', 'block')
              .animate({opacity: 1, top: '50%'}, 200);
        });
  });
  $(document).on('click', '.from_json', function () {
    $('#overlay').fadeIn(400,
        function () {
          $('#from_json_form')
              .css('display', 'block')
              .animate({opacity: 1, top: '50%'}, 200);
        });
    $(this).parent().parent().attr('id', 'toAddFromJSON');
  });
  $(".close, #from_json_submit, #overlay, input[name='commit']").click(function () {
    $('#events_form, #groups_form, #to_json_form, #from_json_form')
      .animate({opacity: 0, top: '45%'}, 200,
        function () {
          $(this).css('display', 'none');
          $('#overlay').fadeOut(400);
        }
      );
  });
  $('#check_all').click(function () {
    $('input[type=checkbox]').prop('checked', true);
  });
  $('#uncheck_all').click(function () {
    $('input[type=checkbox]').prop('checked', false);
  });
  $(document).on('click', '.delete', function () {
    $(this).parent().parent().attr('id', 'toDelete');
  });
  $(document).on('click', '#from_json_submit', function () {
    if (confirm("Текущий учебный план будет удален. Вы уверены?")) {
      fromJSON($('#toAddFromJSON').data('timetable'), $('#from_json').val());
    }
  });
  $("#add_groups").trigger("click");
});
function moveEvent(event_id, week, timetable_id) {
  $.ajax({
    type: "POST",
    url: "/events/move",
    data: "id=" + event_id + ";week=" + week + ";timetable_id=" + timetable_id
  });
};
function fromJSON(timetable_id, json) {
  $.ajax({
    type: "POST",
    url: "/timetables/"+timetable_id+"/from_json",
    data: "json=" + json
  });
};

