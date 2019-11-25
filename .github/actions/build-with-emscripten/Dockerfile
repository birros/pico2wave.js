FROM trzeci/emscripten-slim:sdk-tag-1.37.36-64bit as emscripten_base

FROM debian:buster-slim

COPY --from=emscripten_base /emsdk_portable /emsdk_portable

RUN apt update && apt install -y python python-pip ca-certificates curl automake libtool

ENV EMSDK=/emsdk_portable
ENV EMSCRIPTEN=/emsdk_portable/sdk
ENV EM_DATA=/emsdk_portable/data
ENV EM_CONFIG=/emsdk_portable/data/.config
ENV EM_CACHE=/emsdk_portable/data/.cache
ENV EM_PORTS=/emsdk_portable/data/.ports
ENV PATH=/emsdk_portable/sdk:${PATH}

ENV GITHUB_WORKSPACE=/src

COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]