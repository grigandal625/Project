let rowCount = () => $("#likert tr").length - 1;
let colCount = () => $("#likert tr")[0].getElementsByTagName("td").length - 1;

let getRow = (index) => $($("#likert tr")[Number(index) + 1]);
let activateRow = (row) => {
    $($($(row).children()[0]).children()[1]).on("click", () => $(row).remove());
};

let getColumnIndex = (column) =>
    Array.from($("#likert tr")[0].getElementsByTagName("td")).indexOf(
        column[0]
    ) - 1;
let getColumn = (index) =>
    $(
        Array.from($("#likert tr")).map(
            (row) => $(row).children()[Number(index) + 1]
        )
    );
let activateColumn = (column) =>
    $($($(column)[0]).children()[1]).on("click", () =>
        getColumn(getColumnIndex($(column))).remove()
    );

let getCell = (i, j) => $(getColumn(Number(i))[Number(j) + 1]);

$(document).ready(function () {
    Array.from(Array(rowCount())).forEach((e, i) => activateRow(getRow(i)));
    Array.from(Array(colCount())).forEach((e, i) =>
        activateColumn(getColumn(i))
    );

    $("#add-row").on("click", () => {
        let row = $(`
        <tr>
            <td>
                <input placeholder="Опишите вариант"/>
                <span class="remove glyphicon glyphicon-remove"></span>
            </td>
            ${Array.from(
                { length: colCount() },
                (v, i) => '<td><input type="checkbox"/></td>'
            ).join("\n")}
        </tr>
        `);

        $("#likert tbody").append(row);
        activateRow(row);
    });

    $("#add-col").on("click", () => {
        let column = $(
            Array.from($("#likert tr")).map((row, i) => {
                let td = $(
                    i
                        ? '<td><input type="checkbox"/></td>'
                        : `<td>
                            <input placeholder="Опишите вариант"/>
                            <span class="remove glyphicon glyphicon-remove"></span>
                        </td>`
                );
                $(row).append(td);
                return td[0];
            })
        );
        activateColumn(column);
    });

    $("#done").on("click", () => {
        let tasks = Array.from(Array(rowCount())).map((e, i) =>
            Object({
                id: i,
                text: $(getRow(i).children()[0]).children()[0].value,
            })
        );

        let variants = Array.from(Array(colCount())).map((e, i) =>
            Object({
                id: i,
                text: $(getColumn(i)[0]).children()[0].value,
            })
        );

        let matching = [];
        for (let i in variants) {
            for (let j in tasks) {
                if (getCell(i, j).children()[0].checked) {
                    matching.push({
                        task_id: tasks[j].id,
                        variant_id: variants[i].id,
                    });
                }
            }
        }

        text = $("#title").val()
        topic_id = $("#select_topic").val();

        $.ajax({
            type: "POST",
            url: "/likert_utz",
            data: {text, topic_id, tasks, variants, matching},
            success: function (msg) {
                alert("Задание создано успешно");
            },
        });
    });
});
