$(function() {
    $("#select_root").change(function() {
        var root_id = this.selectedOptions[0].value;

        $.ajax({
            type: "GET",
            url: "/ka_topics/" + root_id,
            dataType: "json",
            success: function(topics) {
                $('#select_topic_container').css("display", "block");
                $('#select_topic').empty();
                topics.forEach(function(t) {
                    $('<option></option>', {value: t.id, text: t.text}).appendTo($('#select_topic'));
                });
            }
        });
    });
});