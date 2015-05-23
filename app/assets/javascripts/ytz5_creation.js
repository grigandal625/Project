$(document).ready(function() {
    var task = {};
    var selections = [];
    var word = {};
    var step = 1;
    var highlighting = false;

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

    $(document).on('click', '#next_step', function() {
        //event.preventDefault();
        var tmp = $('#task')[0].contentEditable;
        var tmp2 = $('#task')[0];
        if ($('#task')[0].innerText != "") {
            $('#task')[0].contentEditable = false;
            $('#step1').replaceWith('<div id="step2"><div class="col-md-3 nav_buttons"><center><button class="btn btn-default settings_button" id="prev_step">Назад</button></center></div><div class="col-md-3 nav_buttons"><center><button class="btn btn-default settings_button" id="done">Создать</button></center></div></div>');
            $(this).text('Создать');
            step = 2;
            task.text = $('#task')[0].innerText;
        }
    });

    $(document).on('click', '#done', function() {
        task.selections = selections;
        task.hint = $('#hint').text;
        task.level =
        $.ajax({
            type: "POST",
            url: "/filling_utz",
            data: task,
            success: function(msg){
                alert( "Задание создано успешно" );
            }
        });
    });

    $(document).on('click', '#prev_step', function() {
        //event.preventDefault();
        $('#task')[0].contentEditable = true;
        $('#step2').replaceWith('<div class="col-md-6 nav_buttons" id="step1"><center><button class="btn btn-default settings_button" id="next_step">Следующий шаг</button></center></div>');
        $("#task").html(function() {
            return $(this).html().replace(/<\/?strong>/g, "");
        });
        selections = []
    });


    function selectElementContents(selectionStart, selectionEnd) {
        var el = document.getElementById("task");
        var range = document.createRange();
        range.setStart(el, selectionStart);
        //range.setEnd(el, selectionEnd);
        var sel = window.getSelection();
        sel.removeAllRanges();
        sel.addRange(range);
    }


    $('.editable').on('selectstart', function() {
        //var tmp = $('#task');
        var saved_text = $('#task')[0].innerText;
        var saved_html = $('#task')[0].innerHTML;
        //var proceed = false;
        $('#task').html(task.text);
        $(document).one('mouseup', function() {
            var tmp_sel = this.getSelection();
            if (tmp_sel != "" && step == 2) {
                proceed = true;
                var selection = tmp_sel; //this.getSelection();
                var range_for_arr = selection.getRangeAt(0);
                var start = range_for_arr.startOffset;
                var end = range_for_arr.endOffset;
                var selected_text = range_for_arr.toString();
                var data = selected_text + '\n';
                var new_selection = true;
                var sel_index = -1;
                for (var i = 0; i < selections.length; ++i) {
                    if (selections[i].start == start && selections[i].end == end) {
                        data = selections[i].variants.join('\n');
                        new_selection = false;
                        sel_index = i;
                        break;
                    }
                }

                var range;
                /*if (new_selection) {
                    //var tmp_html = $('#task').html();
                    if (window.getSelection) {
                        var new_elem = document.createElement('strong');
                        var sel = window.getSelection();
                        var range = document.createRange();
                        range = sel.getRangeAt(0);
                        txt = document.createTextNode(range.toString());
                        new_elem.appendChild(txt);
                        range.deleteContents();
                        range.insertNode(new_elem);
                        sel.removeAllRanges();
                    } else {
                        if (document.selection.createRange) {
                            var range = document.selection.createRange();
                            range.pasteHTML("<strong>" + range.text + "</strong>");
                            range.select();
                        }
                    }
                    var new_words = $('#task')[0].innerHTML.split(' ');
                    var old_words = saved_html.split(' ');
                    var new_html = "";
                    for (var i = 0; i < new_words.length; ++i) {
                        console.log(new_words[i]);
                        if (new_words[i].indexOf("strong") > -1) {
                            new_html += new_words[i] + " ";
                        } else {
                            new_html += old_words[i] + " ";
                        }
                    };
                } else {
                    $('#task').html(saved_html);
                }*/
                bootbox.dialog({
                    title: "Введите возможные варианты ответов",
                    message: '<div class="row">  ' +
                        '<div class="col-md-12"> ' +
                        '<form class="form-horizontal"> ' +
                        '<div class="form-group"> ' +
                        '<label class="col-md-3 control-label">Варианты ответов</label> ' +
                        '<div class="col-md-7"> ' +
                        '<textarea id="variants" rows="6" class="editable form-control row-fluid" placeholder="Введите здесь варианты ответов" style="resize: vertical; overflow: auto;">' + data + '</textarea>' +
                        '<span class="help-block">Ответ в первой строке считается верным!<br>Каждый вариант с новой строки</span> </div> ' +
                        '</div> ' +
                        '</form> </div>  </div>',
                    onEscape: function() {
                        $('#task').html(saved_html);
                    },
                    buttons: {
                        success: {
                            label: "Сохранить",
                            className: "btn-success",
                            callback: function() {
                                var variants = $('#variants').val().split('\n');
                                var clear_vars = [];
                                for (var i = 0; i < variants.length; ++i) {
                                    if (variants[i] != "")
                                        clear_vars.push(variants[i]);
                                };
                                if (clear_vars.length == 1 && (data.replace('\n', '') == clear_vars[0] || selected_text == clear_vars[0])) {
                                    if (!new_selection) {
                                        selections.splice(sel_index, 1);
                                    }
                                    return;
                                }
                                if (clear_vars.length > 0) {
                                    if (new_selection) {
                                        selections.push({
                                            'start': start,
                                            'end': end,
                                            'answer': clear_vars[0],
                                            'variants': clear_vars
                                        });
                                    } else {
                                        selections[sel_index].answer = clear_vars[0];
                                        selections[sel_index].variants = clear_vars;
                                    }

                                    //$('#task').html(new_html);
                                    console.log(JSON.stringify(selections)); //don't forget to send text itself!!
                                    console.log(task.text);
                                    /*highlighting = true;
                                    for (var i = 0; i < task.length; ++i) {
                                        selectElementContents(task[i].start, task[i].end);
                                    };
                                    highlighting = false;*/
                                }
                            }
                        }
                    }
                });
            };
        });
        //if (!proceed) {
        //    $('#task').html(saved_html);
        //}
    });
});
