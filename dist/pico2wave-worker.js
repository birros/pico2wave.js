importScripts("pico2wave.js");

onmessage = function(e) {
    Pico2wave({
        arguments: [ "--wave=filename.wav", "--lang=fr-FR", e.data ]
    }).then(function(module) {
        var data = module.FS.readFile('filename.wav');
        var blob = new Blob([data.buffer], {type: "application/octet-binary"});
        var url = URL.createObjectURL(blob);
        postMessage(url);
    });
}
