$.fn.previewImg = function(img) {
    $input = $(this);
    console.log('previewImg start');
    console.log($(this));
    console.log('previewImg end');
    if ($input.prop('files') && $input.prop('files')[0]) {
        reader = new FileReader();
        reader.onload = function(e) {
            img.attr('src', e.target.result);
            img.attr('style', 'width: auto; height: 150px; max-width: 280px');
        };
        reader.readAsDataURL($input.prop('files')[0]);
    }
};

$(document).ready(function() {
    $.fn.editable.defaults.mode = 'inline';
    //$.fn.editable.defaults.showbuttons = false;
    $.fn.editable.defaults.type = 'text';
    $.fn.editable.defaults.url = '';
    $.fn.editable.defaults.emptytext = 'Empty';
    $.fn.editable.defaults.inputclass = 'input-sm';

    var el = document.getElementById('rows');
    var sortable = Sortable.create(el, {
        draggable: ".drag"
    });

    /*$('input:file').each(function() {
        //$this = $(this);
        //console.log($this);
        $img = $(this).closest('tr').find('.preview-img');
        console.log($img);
        console.log('-----------------');
        $(this).change(function() {
            console.log($(this));
            $img = $(this).closest('tr').find('.preview-img');
            //console.log($(this));
            console.log($img);
            $(this).previewImg($img);
        });
    });*/

    $('.edit_task').editable();
    $('#level').editable({
        url: '',
        mode: 'popup',
        value: 1,
        source: [{
            value: 0,
            text: 'Легкий'
        }, {
            value: 1,
            text: 'Средний'
        }, {
            value: 2,
            text: 'Сложный'
        }]
    });

    $(document).keydown(function(evt) {
        //var tmp = $('.editable-input textarea');
        if ($('.editable-input textarea').length)
            if (evt.keyCode == 32) {
                //console.log($(this));
                evt.preventDefault();
                var tmp = $('.editable-input textarea').val()
                $('.editable-input textarea').val(tmp + " ");
            }
        if ($('.input-sm').length) {
            if (evt.keyCode == 32) {
                //console.log($(this));
                evt.preventDefault();
                var tmp = $('.input-sm').val()
                $('.input-sm').val(tmp + " ");
            }
        }
    });

    $('#hint').editable({
        url: '',
        mode: 'popup',
        title: 'Введите подсказку',
        rows: 5,
        emptytext: 'Введите подсказку'
    });

    $('body').on('click', '.image_add', function(event) {
        $(this).closest('tr').find('input:file').click();
    });

    function getRandomInt(min, max) {
        return Math.floor(Math.random() * (max - min + 1)) + min;
    }


    $("#add_row").click(function() {
        var rand = getRandomInt(0, 10000000);
        $tr = $('<tr class="drag"><td><center><a href="#" class="image_add">+</a></center></td><td><img class="preview-img"></td><td><input id="' + rand + '" type="file" name="images[]" style="opacity: 0; width: 0; height: 0"></td><td><center><small><button id="row_del" type="button" class="btn btn-danger btn-xs del" value="1">del</button></small></center></td></tr>');
        $("#rows").append($tr);
        //$img = $tr.find('.preview-img');
        //$tr.find('input:file').previewImg($img);
        $tr.find('input:file').change(function() {
        //$('#rand input:file').change(function() {
            console.log($(this));
            $img = $(this).closest('tr').find('.preview-img');
            //console.log($(this));
            //console.log($img);
            $(this).previewImg($img);
        });
        $("#table tbody tr:last .edit_task").editable();

    });

    $('body').on('click', 'button#row_del', function(event) {
        event.preventDefault();
        var id = $(this).attr('value');

        $(this).parent().parent().parent().parent().remove();
    });

    $("#done").click(function() {
        $(this).toggleClass('active');
        var rows = $("#rows tr");
        //var counter = 1;
        var json = {};
        images = [];
        for (var i = 0; i < rows.length; ++i) {
            var cells = rows[i].cells;
            images.push(cells[1].firstChild.getAttribute('src'));
        }
        //var tmp = $('#level').editable();
        json.images = images;
        json.goal = $('#task_aim')[0].text == 'Введите цель задачи' ? '' : $('#task_aim')[0].text;
        json.theme = $('#task_theme')[0].text == 'Введите тему задачи' ? '' : $('#task_theme')[0].text;
        json.hint = $('#hint')[0].text;
        json.level = $('#level').editable()[0].text; //change this into id
        json.topic_id = $('#select_topic').val();
        console.log(json);
        $.ajax({
            type: "POST",
            url: "/images_sort_utz",
            data: json,
            success: function(msg){
                $('#done').toggleClass('active');
                alert( "Задание создано успешно" );
            },
            error: function(){
                $('#done').toggleClass('active');
            }
        });
    });
});
