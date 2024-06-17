$(function() {
    window.addEventListener('message', function(event) {
        if (event.data.type == "enableui") {
            document.body.style.display = event.data.enable ? "block" : "none";
            document.getElementById('channel').focus();
        }
    });

    document.onkeyup = function (data) {
        //var initChannel = parseInt(document.getElementById('vChannel').innerHTML);
        if (data.which == 27) { // Escape key
            $.post('http://_radio/escape', JSON.stringify({}));
        }
        /*if (data.which == 37 || data.which == 40) { // Down/Left key
            initChannel = initChannel - 1;
            document.getElementById('vChannel').innerHTML = initChannel;
        }
        if (data.which == 39 || data.which == 38) { // Up/Right key
            initChannel = initChannel + 1;
            document.getElementById('vChannel').innerHTML = initChannel;
        }*/
        if (data.which == 13) { // Down/Left key
            document.getElementById('submit').focus();
        }
        if (data.which == 37 || data.which == 40) { // Down/Left key
            document.getElementById('channel').focus();
        }
        if (data.which == 39 || data.which == 38) { // Up/Right key
            document.getElementById('channel').focus();
        }
    };

    $("#submit").click(function() {
        $.post('http://_radio/joinRadio', JSON.stringify({
            channel: document.getElementById('vChannel').innerHTML
        }));
    });

    $('#channelScroller').on('wheel', function(event){
        var initChannel = parseInt(document.getElementById('vChannel').innerHTML);
        if (event.originalEvent.deltaY !== 0) {
            if (event.originalEvent.deltaY < 0) {
                if (initChannel >= 0 && initChannel < 100) {
                    initChannel = initChannel + 1;
                    $('#channel').val(initChannel);
                    document.getElementById('vChannel').innerHTML = initChannel;
                }
            }
            else {
                if (initChannel > 0) {
                    initChannel = initChannel - 1;
                    $('#channel').val(initChannel);
                    document.getElementById('vChannel').innerHTML = initChannel;
                }
            }
        }
    });

    $("#onoff").click(function() {
        $.post('http://_radio/leaveRadio', JSON.stringify({}));
    });
});
