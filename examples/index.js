var input = document.querySelector("#input");
var select = document.querySelector("#select");
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
        postMessage();
    }
}

button.onclick = postMessage;

function postMessage() {
    pico2waveWorker.postMessage({
        lang: select.value,
        text: input.value
    });
}
