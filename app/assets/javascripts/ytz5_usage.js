$(document).ready(function () {
    $("#done").on("click", () => {
        let error = Array.from($(".hidden-filling"))
            .map((e) => e.getAttribute("data-check") == e.value)
            .includes(false);
        alert(error ? "Ошибка" : "Верно");
    });
    $("#hint").on("click", () => {
        alert(
            Array.from($(".hidden-filling"))
                .map((e) => e.getAttribute("data-check"))
                .join(", ")
        );
    });
});
