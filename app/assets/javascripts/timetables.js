$(document).ready(function (){
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
    $(document).on('click', '#add_groups', function() {
            $('#overlay').fadeIn(400,
                function(){
                    $('#groups_form')
                        .css('display', 'block')
                        .animate({opacity: 1, top: '50%'}, 200);
                });
    });
    $('#check_all').click(function() {
        $('input[type=checkbox]').prop('checked', true);
    });
    $('#uncheck_all').click(function() {
        $('input[type=checkbox]').prop('checked', false);
    });
  $("#events_close, #groups_close, #overlay, input[name='commit']").click( function(){
    $('#events_form, #groups_form')
      .animate({opacity: 0, top: '45%'}, 200,  
        function(){ 
          $(this).css('display', 'none'); 
          $('#overlay').fadeOut(400); 
        }
      );
  });


  $(document).on('click', '.delete', function() {
    $(this).parent().parent().attr('id', 'toDelete');
  });
    $( "#add_groups" ).trigger( "click" );
});
function moveEvent(event_id,week,timetable_id){
  $.ajax({
    type: "POST",
    url: "/events/move",
    data: "id=" + event_id + ";week=" + week + ";timetable_id=" + timetable_id
  });
};

