$(document).ready(function (){
  $('div.events').draggable({
      containment: 'table',
      revert : 'invalid'
  });
  $(document).on('click', 'td.events', function() {
    if ($('div', this).length==0) { //true if $(this) dont include divs
      $('#overlay').fadeIn(400,
      function(){
        $('#events_form') 
          .css('display', 'block') 
          .animate({opacity: 1, top: '50%'}, 200);
      });
      $('.event_hidden').hide();
      $("input[name='event[timetable_id]']").val($(this).parent().data('timetable')); // submit timetable_id and week in db by ror form
      $("input[name='event[week]']").val($(this).data('week'));
      $(this).attr('id', 'addTo'); // save td to add div.events 
    };
  });
  $("#events_close, #overlay, input[name='commit']").click( function(){ 
    $('#events_form')
      .animate({opacity: 0, top: '45%'}, 200,  
        function(){ 
          $(this).css('display', 'none'); 
          $('#overlay').fadeOut(400); 
        }
      );
  });
  $('td.events').droppable({
    accept: 'div.events',
    tolerance: 'intersect',
    drop: function(event, ui) {
      if ($('div', this).length==0) {
        $div=$(ui.draggable);
        $div.appendTo($(this));
        var event_id = $div.data('event');
        var week = $(this).data('week');
        var timetable_id = $(this).parent().data('timetable');
        moveEvent(event_id,week,timetable_id);
        $div.css({
          'top': '0px',
          'left': '0px'
        });
      } else {
        $(ui.draggable).animate({ top: 0, left: 0 }, 'slow'); //revert
      }
    }
  });
  $(document).on('click', '.delete', function() {
    $(this).parent().parent().attr('id', 'toDelete');
  });
});
function moveEvent(event_id,week,timetable_id){
  $.ajax({
    type: "POST",
    url: "/events/move",
    data: "id=" + event_id + ";week=" + week + ";timetable_id=" + timetable_id
  });
};

