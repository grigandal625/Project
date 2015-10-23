$(document).on('click', '#done', function() {
    $.ajax({
        type: "POST",
        url: "/text_correction_utz/" + $('#utz_id').val() + "/check_answer",
        data: {
            answer: $('#answer').val()
        },
        success: function(msg){
            alert(msg);
        }
    })
});