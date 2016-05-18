
/*
Android 样式 转 style.xml
使用：
    fileds2Java = new StyleXML()
    filedStr = """
        android:layout_width="match_parent"
        android:layout_height="wrap_content"
        android:layout_centerInParent="true"
        android:gravity="center_horizontal"
        """
    javaSrc = fileds2Java.toJava filedStr, opts
    console.log javaSrc
 */

var StyleXML = (function () {
    function StyleXML() {

    }

    StyleXML.prototype.toStyleXML = function (text, opts) {
        var arr, lines, tem;
        lines = text.trim().split(/\n/g);
        if (!((lines != null ? lines.length : void 0) > 0)) {
            return "lines is null";
        }
        arr = [];
        tem = '<item name="{0}">{1}</item>';
        lines.forEach(function (item) {
            var name, ss, value;
            ss = item.split('=');
            if (ss.length === 2) {
                name = ss[0].trim();
                value = ss[1].trim();
                value = value.replace(/^"(.*)"$/, function (match, first) {
                    return first;
                });
                return arr.push(tem.format(name, value));
            }
        });
        return arr.join('\n');
    };

    StyleXML.prototype.toJava = StyleXML.prototype.toStyleXML;

    return StyleXML;

})();



var AlignComment = (function () {
    function AlignComment() {

    }

    StyleXML.prototype.alignComment = function (text, opts) {
        return text;
    };

    StyleXML.prototype.toJava = StyleXML.prototype.alignComment;

    return StyleXML;

})();




var FormatCode = (function () {
    function FormatCode() {

    }

    FormatCode.prototype.getLogUrl = function (text, opts) {
        return js_beautify(text);
    };

    FormatCode.prototype.toJava = FormatCode.prototype.getLogUrl;

    return FormatCode;

})();


