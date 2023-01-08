$(document).ready(function () {
    var task = {};
    var selections = [];
    var word = {};
    var step = 1;
    var highlighting = false;

    $("#hint").editable({
        url: "",
        mode: "popup",
        title: "Введите подсказку",
        rows: 5,
        emptytext: "Введите подсказку",
    });

    $("#add-element").on("click", () => {
        document.getElementById("myDropdown").classList.toggle("show");
    });

    $("#add-simple").on("click", () => {
        document.getElementById("myDropdown").classList.remove("show");
        let x = $(
            `<span class="text-element">
                <input class="simple-text-element" placeholder="Видимый текст" title="Видимый текст"/> 
                <span class="move move-left glyphicon glyphicon-arrow-left" />
                <span class="move move-right glyphicon glyphicon-arrow-right" />
                <span class="move remove glyphicon glyphicon-remove" />
            </span>`
        ).insertBefore("#add-element");
        console.log(x);
        $(x.children()[3]).on("click", () => $(x).remove());
        $(x.children()[1]).on("click", () => {
            if ($(x)[0].previousElementSibling) {
                let e = $(x[0].previousElementSibling);

                $(x).insertBefore(e);
            }
        });
        $(x.children()[2]).on("click", () => {
            if (
                $(x)[0].nextElementSibling &&
                Array.from($(x)[0].nextElementSibling.classList).includes(
                    "text-element"
                )
            ) {
                let e = $(x[0].nextElementSibling);

                $(x).insertAfter(e);
            }
        });
    });

    $("#add-hidden").on("click", () => {
        document.getElementById("myDropdown").classList.remove("show");
        let x = $(
            `<span class="text-element">
                <input class="hidden-text-element" placeholder="Пропуск в тексте" title="Пропуск в тексте"/>
                <span class="move move-left glyphicon glyphicon-arrow-left" />
                <span class="move move-right glyphicon glyphicon-arrow-right" />
                <span class="move remove glyphicon glyphicon-remove" />
            </span>`
        ).insertBefore("#add-element");
        console.log(x);
        $(x.children()[3]).on("click", () => $(x).remove());
        $(x.children()[1]).on("click", () => {
            if ($(x)[0].previousElementSibling) {
                let e = $(x[0].previousElementSibling);

                $(x).insertBefore(e);
            }
        });
        $(x.children()[2]).on("click", () => {
            if (
                $(x)[0].nextElementSibling &&
                Array.from($(x)[0].nextElementSibling.classList).includes(
                    "text-element"
                )
            ) {
                let e = $(x[0].nextElementSibling);

                $(x).insertAfter(e);
            }
        });
    });

    $(document).on("click", "#next_step", function () {
        //event.preventDefault();

        $("#step1").replaceWith(
            '<div id="step2"><div class="col-md-3 nav_buttons"><center><button class="btn btn-default settings_button" id="prev_step">Назад</button></center></div><div class="col-md-3 nav_buttons"><center><button class="btn btn-default settings_button" id="done">Создать</button></center></div></div>'
        );
        $(this).text("Создать");
        step = 2;
    });

    $(document).on("click", "#done", function () {
        debugger;
        task.elements = Array.from($(".text-element")).map((e, i) =>
            Object({
                number: i,
                is_hidden: Array.from($(e).children()[0].classList).includes(
                    "hidden-text-element"
                ),
                text: $(e).children()[0].value,
            })
        );
        task.hint = $("#hint").text;
        task.topic_id = $("#select_topic").val();
        task.level = $.ajax({
            type: "POST",
            url: "/filling_utz",
            data: task,
            success: function (msg) {
                alert("Задание создано успешно");
            },
        });
    });

    $(document).on("click", "#prev_step", function () {
        //event.preventDefault();
        $("#task")[0].contentEditable = true;
        $("#step2").replaceWith(
            '<div class="col-md-6 nav_buttons" id="step1"><center><button class="btn btn-default settings_button" id="next_step">Следующий шаг</button></center></div>'
        );
        $("#task").html(function () {
            return $(this)
                .html()
                .replace(/<\/?strong>/g, "");
        });
        selections = [];
    });
});
