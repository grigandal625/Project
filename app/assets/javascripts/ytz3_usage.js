var json = '{"left":["1","2","3"],"right":["one","two","three"],"hint":"4 <--> four","level":"Easy"}';

$(document).ready(function() {

    function shuffle(o) {
        for (var j, x, i = o.length; i; j = Math.floor(Math.random() * i), x = o[--i], o[i] = o[j], o[j] = x);
        return o;
    };

    function parseJSON(json) {
        var task = jQuery.parseJSON(json);
        var shufled_arr = shuffle(task.right);
        for (var i = 0; i < task.left.length; i++) {
            $('#task_table tbody').append('<tr><td><div><button class="btn btn-default answer"><small>' + task.left[i] + '</small></button></div></td><td><center><--></center></td><td class="drop"></td></tr>');
            $('#variants tbody').append('<tr><td><div class="item"><button class="btn btn-default answer"><small>' + shufled_arr[i] + '</small></button></div></td></tr>');
        };
    }

    $('.item').draggable({
        revert: true,
        proxy: 'clone'
    });

    $('.drop').droppable({
        onDragEnter: function() {
            $(this).addClass('over');
        },
        onDragLeave: function() {
            $(this).removeClass('over');
        },
        onDrop: function(e, source) {
            $(this).removeClass('over');
            if ($(source).hasClass('assigned')) {
                $(this).append(source);
            } else {
                var c = $(source).clone().addClass('assigned');
                $(this).empty().append(c);
                //c.draggable({
                //    revert: true
                //});
            }
        }
    });

    $('#task_done').click(function() {
        var data = $("#task_table tbody tr");
        var ans = {};
        var left = [];
        var right = [];
        for (var i = 0; i < data.length; ++i) {
        	var cells = data[i].cells;
            left.push(cells[0].textContent.trim());
            right.push(cells[2].textContent.trim());
        }
        ans.left = left;
        ans.right = right;


        $.ajax({
            type: "POST",
            url: "/matching_utz/" + $('#utz_id').val() + "/check_answers",
            data: ans,
            success: function(msg){
                alert( msg );
            }
        });
    });

    $('body').on('click', '#task_hint', function(event) {
        event.preventDefault();
    });
});
