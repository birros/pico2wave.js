var input = document.querySelector("#input");
var button = document.querySelector("#button");
var audio = document.querySelector("#audio");

var pico2waveWorker = new Worker("../dist/pico2wave-worker.js");

pico2waveWorker.onmessage = function(e) {
    console.log(e.data);
    audio.src = e.data;
    audio.play();
};

input.onkeydown = function(e) {
    if(e.key === "Enter") {
        pico2waveWorker.postMessage(input.value);
    }
}

button.onclick = function() {
    pico2waveWorker.postMessage(input.value);
}
