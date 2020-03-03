FROM python:3-slim

RUN export DEBIAN_FRONTEND=noninteractive \
    && apt-get update && apt-get -y upgrade \
    && apt-get -y --no-install-recommends install \
        cpanminus \
        gcc \
        git \
        libc6-dev \
        linux-libc-dev \
        make \
    && rm -r /var/lib/apt/lists/* \
    && export MAKEFLAGS=-j$(nproc) \
    && cpanm --notest Perl::Critic \
    && rm -r /root/.cpanm \
    && pip3 install -Ur https://raw.githubusercontent.com/scop/bash-completion/master/test/requirements-dev.txt \
    && rm -r /root/.cache/pip \
    && tmpdir=$(mktemp -d) \
    && cd $tmpdir \
    && git init . \
    && python3 -c "from urllib.request import urlretrieve; urlretrieve('https://raw.githubusercontent.com/scop/bash-completion/master/.pre-commit-config.yaml', './.pre-commit-config.yaml')" \
    && pre-commit install-hooks \
    && cd - \
    && rm -r $tmpdir

WORKDIR /work
