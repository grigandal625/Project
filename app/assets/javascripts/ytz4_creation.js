$(document).ready(function() {

	$('#hint').editable({
        url: '',
        mode: 'popup',
        title: 'Введите подсказку',
        rows: 5,
        emptytext: 'Введите подсказку'
    });

    $(document).keydown(function(evt) {
        if ($('.editable-input textarea').length)
            if (evt.keyCode == 32) {
                evt.preventDefault();
                var tmp = $('.editable-input textarea').val()
                $('.editable-input textarea').val(tmp + " ");
            }
    });
    
    var a = document.getElementById('errors_text');
    var b = document.getElementById('errors_free_text');
    var result = document.getElementById('diff_result');

    function changed() {
        var diff = JsDiff.diffWords(a.value, b.value);
        var fragment = document.createDocumentFragment();
        for (var i = 0; i < diff.length; i++) {

            if (diff[i].added && diff[i + 1] && diff[i + 1].removed) {
                var swap = diff[i];
                diff[i] = diff[i + 1];
                diff[i + 1] = swap;
            }

            var node;
            if (diff[i].removed) {
                node = document.createElement('del');
                node.appendChild(document.createTextNode(diff[i].value));
            } else if (diff[i].added) {
                node = document.createElement('ins');
                node.appendChild(document.createTextNode(diff[i].value));
            } else {
                node = document.createTextNode(diff[i].value);
            }
            fragment.appendChild(node);
        }

        result.textContent = '';
        result.appendChild(fragment);
        var errors_count = Math.max($("del").length, $("ins").length);
        $('#errors_count')[0].innerText = errors_count;
    }

    a.onpaste = a.onchange = b.onpaste = b.onchange = changed;

    if ('oninput' in a) {
        a.oninput = b.oninput = changed;
    } else {
        a.onkeyup = b.onkeyup = changed;
    }

    $("#done").click(function() {
        var data = $(".edit_task");
        //var counter = 1;
        var json = {};
        json.text_with_errors = a.value;
        json.text_without_errors = b.value;
        json.errors_count = $('#errors_count')[0].innerText;
        json.hint = $('#hint')[0].text;

        $.ajax({
            type: "POST",
            url: "/text_correction_utz",
            data: json,
            success: function(msg){
                alert( "Задание создано успешно" );
            }
        });
    });

});
