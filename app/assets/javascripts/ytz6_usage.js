$(document).ready(function() {

    var el = document.getElementById('usage_rows');
    var sortable = Sortable.create(el, {
        draggable: ".drag"
    });
    debugger;

    $(document).on('click', '#task_done', function() {
        var rows = $("#usage_rows tr");
        //var counter = 1;
        var json = {};
        images = [];
        for (var i = 0; i < rows.length; ++i) {
            var cells = rows[i].cells;
            images.push($(cells[0]).find('img').attr('id'));
        }
        json.answer = images;
        $.ajax({
            type: "POST",
            url: "/images_sort_utz/" + $('#utz_id').val() + "/check_answer",
            data: json,
            success: function(msg) {
                alert(msg);
            }
        });
    });

});
