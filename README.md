# pico2wave.js

This is a port of the pico2wave command line tool from the Pico text-to-speech
engine to JavaScript made with [Emscripten].

## Limitations & contributions

__To limit the size of the JavaScript library only the English (Great Britain,
United States) and French languages are supported for the moment__. Any
contribution aimed at improving the portability of other languages supported by
Pico TTS while limiting the final size of the library is welcome. The idea
being, why not, to load the language files on the fly.

## Example

To see how to use this library in a web browser see the `examples` folder.

## Building (with Docker)

[Docker] must be installed:

    docker build -t local/emscripten:1.37.36 ./.github/actions/build-with-emscripten
    docker run --rm -ti -v $(pwd):/src -u $(id -u):$(id -g) local/emscripten:1.37.36 make

## Building (without Docker)

The __Emscripten__ framework must be installed and configured before compiling
the package: [Download and install Emscripten]. Also, `automake` and `libtool`
must be installed from your distribution repositories.

Then execute the following command to use the recipe in the `Makefile`:

    npm run build

## Publishing

To publish this package to the npm repo:

    npm publish

## License

The code of Pico TTS being under Apache 2 license, this port keeps the same
license. However, some restrictions exist in the original package, making it a
non-free library, especially regarding language files. For more information see
this page: [Copyright for svox source package].

[Emscripten]: https://kripken.github.io/emscripten-site/
[Download and install Emscripten]: https://kripken.github.io/emscripten-site/docs/getting_started/downloads.html
[Copyright for svox source package]: https://launchpad.net/ubuntu/bionic/+source/svox/+copyright
[Docker]: https://docs.docker.com/install/