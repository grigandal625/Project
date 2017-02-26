$.fn.previewImg = function(img) {
    $input = $(this);
    if ($input.prop('files') && $input.prop('files')[0]) {
        reader = new FileReader();
        reader.onload = function (e) {
            img.attr('src', e.target.result);
        };
        reader.readAsDataURL($input.prop('files')[0]);
    }
};