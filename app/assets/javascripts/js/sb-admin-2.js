!function (a, b, c) {
    function d(b, c) {
        this.element = a(b), this.settings = a.extend({}, f, c), this._defaults = f, this._name = e, this.init()
    }

    var e = "metisMenu", f = {toggle: !0, doubleTapToGo: !1};
    d.prototype = {
        init: function () {
            var b = this.element, d = this.settings.toggle, f = this;
            this.isIE() <= 9 ? (b.find("li.active").has("ul").children("ul").collapse("show"), b.find("li").not(".active").has("ul").children("ul").collapse("hide")) : (b.find("li.active").has("ul").children("ul").addClass("collapse in"), b.find("li").not(".active").has("ul").children("ul").addClass("collapse")), f.settings.doubleTapToGo && b.find("li.active").has("ul").children("a").addClass("doubleTapToGo"), b.find("li").has("ul").children("a").on("click." + e, function (b) {
                return b.preventDefault(), f.settings.doubleTapToGo && f.doubleTapToGo(a(this)) && "#" !== a(this).attr("href") && "" !== a(this).attr("href") ? (b.stopPropagation(), void(c.location = a(this).attr("href"))) : (a(this).parent("li").toggleClass("active").children("ul").collapse("toggle"), void(d && a(this).parent("li").siblings().removeClass("active").children("ul.in").collapse("hide")))
            })
        }, isIE: function () {
            for (var a, b = 3, d = c.createElement("div"), e = d.getElementsByTagName("i"); d.innerHTML = "<!--[if gt IE " + ++b + "]><i></i><![endif]-->", e[0];)return b > 4 ? b : a
        }, doubleTapToGo: function (a) {
            var b = this.element;
            return a.hasClass("doubleTapToGo") ? (a.removeClass("doubleTapToGo"), !0) : a.parent().children("ul").length ? (b.find(".doubleTapToGo").removeClass("doubleTapToGo"), a.addClass("doubleTapToGo"), !3) : void 0
        }, remove: function () {
            this.element.off("." + e), this.element.removeData(e)
        }
    }, a.fn[e] = function (b) {
        return this.each(function () {
            var c = a(this);
            c.data(e) && c.data(e).remove(), c.data(e, new d(this, b))
        }), this
    }
}(jQuery, window, document);

$(function () {
    $(window).bind("load resize", function () {
        topOffset = 50;
        width = (this.window.innerWidth > 0) ? this.window.innerWidth : this.screen.width;
        if (width < 768) {
            $('div.navbar-collapse').addClass('collapse');
            topOffset = 100; // 2-row-menu
        } else {
            $('div.navbar-collapse').removeClass('collapse');
        }

        height = ((this.window.innerHeight > 0) ? this.window.innerHeight : this.screen.height) - 1;
        height = height - topOffset;
        if (height < 1) height = 1;
        if (height > topOffset) {
            $("#page-wrapper").css("min-height", (height) + "px");
        }
    });

    var url = window.location;
    var element = $('ul.nav a').filter(function () {
        return this.href == url;
    }).addClass('active').parent().parent().addClass('in').parent();
    if (element.is('li')) {
        element.addClass('active');
    }
});

$(function () {
    $('#side-menu').metisMenu();

});


function Inanimate() {
    $('.input-text').focus(function () {
        $(this).parent().removeClass('selected2');
        $(this).parent().addClass('selected');
    }).blur(function () {
        if ($(this).val() == "") {
            $(this).parent().removeClass('selected');
            $(this).parent().removeClass('selected2');
        } else {
            $(this).parent().removeClass('selected');
            $(this).parent().addClass('selected2');
        }
    });
    $('.input-label').click(function () {
        $(this).parent().addClass('selected');
    });
}
$(function () {
    $('#side-menu').metisMenu();
    Inanimate();
    $('.input-text').each(function () {
        if ($(this).val() != '') {
            $(this).parent().addClass('selected2');
        }
    });
});

$(function () {
    $('.input-text').focus(function () {
        $(this).parent().removeClass('selected2');
        $(this).parent().addClass('selected');
    }).blur(function () {
        if ($(this).val() == "") {
            $(this).parent().removeClass('selected');
            $(this).parent().removeClass('selected2');
        } else {
            $(this).parent().removeClass('selected');
            $(this).parent().addClass('selected2');
        }
    });
    $('.input-label').click(function () {
        $(this).parent().addClass('selected');
    });
});

$(".tscrollable li").click(function () {
    $(".tscrollable li").removeClass("ndj");
    $(this).addClass("ndj");
});
$.put = function (url, data, callback, type) {

    if ($.isFunction(data)) {
        type = type || callback,
            callback = data,
            data = {}
    }

    return $.ajax({
        url: url,
        type: 'PUT',
        success: callback,
        data: data,
        contentType: type
    });
}

$.delete = function (url, data, callback, type) {
    if ($.isFunction(data)) {
        type = type || callback,
            callback = data,
            data = {}
    }

    return $.ajax({
        url: url,
        type: 'DELETE',
        success: callback,
        data: data,
        contentType: type
    });
}