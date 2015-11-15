// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

  jQuery(function() {
  var works;
  works = $('#event_name').html();
  return $('#event_test_id').change(function() {
    var options, tip;
    tip = $('#event_test_id :selected').text();
    options = $(works).filter("optgroup[label='" + tip + "']").html();
    if (options) {
      return $('#event_name').html(options);
    } else {
      return $('#event_name').empty();
    }
  });
});
    
