importScripts("pico2wave.js");

onmessage = function(event) {
    var message = event.data;
    Pico2wave({
        arguments: [ "--wave=filename.wav", "--lang=" + message.lang, message.text ]
    }).then(function(module) {
        var data = module.FS.readFile('filename.wav');
        var blob = new Blob([data.buffer], {type: "application/octet-binary"});
        var url = URL.createObjectURL(blob);
        postMessage(url);
    });
}
