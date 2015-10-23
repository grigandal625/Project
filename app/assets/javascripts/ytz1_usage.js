$(document).ready(function() {

    function shuffle(o) {
        for (var j, x, i = o.length; i; j = Math.floor(Math.random() * i), x = o[--i], o[i] = o[j], o[j] = x);
        return o;
    };
    
//    function parseJSON(json) {
//        var task = jQuery.parseJSON(json);
//        var shufled_arr = shuffle(task.answers);
//        $('#question_title_usage').innerText = task.question;
//        $('#question_title_usage')[0].setAttribute('question_id', task.q_id);
//        for (var i = 0; i < shufled_arr.length; i++) {
//            $('#test_rows').append('<tr class="test_answer"><td><center><input type="checkbox"></center></td><td><button class="btn btn-default task" answer_id=' + shufled_arr[i].id + '>' + shufled_arr[i].text + '</button></td></tr>');
//        };
//    }
//
//    parseJSON(json);

    $('#test_done').click(function() {
        var rows = $(".test_answer");
        var result = {};
        var checked_answers = [];
        result.question_id = $('#question_title_usage')[0].getAttribute('question_id');
        for (var i = 0; i < rows.length; ++i) {
        	var checked = rows[i].children[0].children[0].children[0].checked;
            if (checked)
                checked_answers.push(rows[i].children[1].children[0].getAttribute('data-answer-id'));
        }
        result.checked_answers = checked_answers;
        $.ajax({
            type: "POST",
            url: "/test_utz_questions/" + $('#question_id').val() + "/check_answer",
            data: result,
            success: function(msg){
                alert( msg );
            }
        });
    });
});