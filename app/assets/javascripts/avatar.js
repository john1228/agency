// or using File.prototype.objectURL()?

function getObjectURL(file) {
    //console.log(file);
    var url = null;
    if (window.createObjectURL != undefined) { // basic
        url = window.createObjectURL(file);
    } else if (window.URL != undefined) { // mozilla(firefox)
        url = window.URL.createObjectURL(file);
    } else if (window.webkitURL != undefined) { // webkit or chrome
        url = window.webkitURL.createObjectURL(file);
    }
    return url;
}

$(".file_uploader").change(function () {
    var objUrl = getObjectURL(this.files[0]);
    if (objUrl) {

        $('.portrait .place').remove();
        $('.portrait ').css('background-image', 'url("' + objUrl + '")');
        $('.portrait ').css('background-size', 'cover');
    }
});

; (function ($) {

    $.fn.Avatar = function (options) {
        var defaults = {
            container: '.rotatorWrapper',
            animationduration: 1000,
            slideWidth: 960
        };

        options = $.extend(defaults, options);
        elm = this;


        var _show = function(url) {
            elm.find('.place').remove();
            elm.css('background-image', 'url("' + url + '")');
            elm.css('background-size', 'cover');
        }

        var _init = function () {
            url = $(elm).data("url");
            if(url) {
                _show(url);
            }
            _bindEvents();
        };


        var _bindEvents = function () {
            elm.find(".file_uploader").change(function () {
                var objUrl = getObjectURL(this.files[0]);
                if (objUrl) {
                    _show(objUrl)

                }
            });
        };

        return _init(elm);
    }
})(jQuery);

