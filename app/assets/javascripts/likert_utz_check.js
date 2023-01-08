$(document).ready(function () {
    $("#done").on("click", () => {
        Array.from($(".for-check"))
            .map(
                (e) =>
                    (e.getAttribute("data-check") && e.checked) ||
                    (!e.getAttribute("data-check") && !e.checked)
            )
            .includes(false)
            ? alert("Ошибка")
            : alert("Верно");
    });
});
