function initEvent() {
    var input = $('#code_input')[0];
    input.onchange = onChange;
    input.onkeyup = onChange;
    $('#mode-option-group input, #gen-option-group input').click(function () {
        onChange();
    });
}

function onChange() {
    var input = $('#code_input').val();
    var opts;
    opts = {
        packageName: '',
        className: 'TestClassSpec',
        genSetter: true,
        genGetter: true,
        genInnerClass: true
    };
    opts.packageName = $('#inputPackageName').val();
    opts.className = $('#inputClassName').val();
    opts.genSetter = $('#genSetter')[0].checked;
    opts.genGetter = $('#genGetter')[0].checked;
    opts.genInnerClass = $('#genInnerClass')[0].checked;
    opts.simple = $('#GenJavaTemplateSimple')[0].checked;

    var fileds2Java = new FiledsJavaDbXutils();
    var mode = parseInt($('#mode-option-group input[name="genMode"]:checked').val());

    switch (mode) {
        case 1: fileds2Java = new FiledsJavaDbOrmlite(); break;
        case 2: fileds2Java = new FiledsJavaDbXutils(); break;
        case 3: fileds2Java = new FiledsJavaDbXutils3(); break;
        case 4: fileds2Java = new FiledsJava(); break;

        case 5: fileds2Java = new JsonJavaDbOrmlite(); break;
        case 6: fileds2Java = new JsonJavaDbXutils(); break;
        case 7: fileds2Java = new JsonJavaDbXutils3(); break;
        case 8: fileds2Java = new JsonJava(); break;
        case 9: fileds2Java = new JsonJavaUrl(); break;

        case 10: fileds2Java = new StyleXML(); break;
        case 11: fileds2Java = new AlignComment(); break;
        case 12: fileds2Java = new FormatCode(); break;
        case 13: fileds2Java = new ParseLayoutXML(); break;
        case 14: fileds2Java = new GenJavaTemplate(); break;
        case 15: fileds2Java = new SQLJavaDbOrmlite(); break;
        case 16: fileds2Java = new SQLJavaDbXutils(); break;
        case 17: fileds2Java = new SQLJavaDbXutils3(); break;
        case 18: fileds2Java = new SQLJava(); break;
        default:
            fileds2Java = new FiledsJavaDbXutils();
            break;
    }

    fileds = input;
    var javaSrc = fileds2Java.toJava(fileds, opts);
    //     console.log('ssssssssss' + javaSrc);
    javaSrc = CodeFormat.alignComment(javaSrc);
    $('pre code').text(javaSrc);

    $('pre code').each(function (i, block) {
        hljs.highlightBlock(block);
    });

    saveConfig();
}
