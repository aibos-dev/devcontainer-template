FROM nvidia/cuda:12.2.2-cudnn8-devel-ubuntu22.04

ARG PYTHON_VERSION=3.10.12
ARG PYTHON_MAJOR=3.10
ARG USERNAME=vscode
ARG USER_UID=1001
ARG USER_GID=$USER_UID

ENV TZ=Asia/Tokyo \
    LC_ALL=C.UTF-8 \
    LANG=C.UTF-8 \
    PYTHONIOENCODING=utf-8 \
    DEBIAN_FRONTEND=noninteractive
    
WORKDIR /tmp/

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
    wget \
    git \
    zip \
    curl \
    make \
    llvm \
    tzdata \
    tk-dev \
    graphviz \
    xz-utils \
    zlib1g-dev \
    libssl-dev \
    libbz2-dev \
    libffi-dev \
    liblzma-dev \
    libsqlite3-dev \
    libgl1-mesa-dev \
    libreadline-dev \
    libncurses5-dev \
    libncursesw5-dev \
    build-essential \
    nano \
    git-lfs \
    ffmpeg \
    tree \
    && git lfs install


RUN cd /usr/local/ \
    && wget https://www.python.org/ftp/python/$PYTHON_VERSION/Python-$PYTHON_VERSION.tar.xz \
    && tar xvf Python-$PYTHON_VERSION.tar.xz \
    && cd /usr/local/Python-$PYTHON_VERSION \
    && ./configure --enable-optimizations \
    && make install \
    && rm /usr/local/Python-$PYTHON_VERSION.tar.xz \
    && cd /usr/local/Python-$PYTHON_VERSION \
    && ln -fs /usr/local/Python-$PYTHON_VERSION/python /usr/bin/python

RUN curl -kL https://bootstrap.pypa.io/get-pip.py | python \
    && curl -sSL https://install.python-poetry.org | POETRY_HOME=/opt/poetry python \
    && cd /usr/local/bin \
    && ln -s /opt/poetry/bin/poetry \
    && poetry config virtualenvs.create false

RUN apt-get autoremove -y \
    && apt-get clean \
    && rm -rf \
    /var/lib/apt/lists/* \
    /var/cache/apt/* \
    /usr/local/src/* \
    /tmp/*

RUN groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m -s /bin/bash $USERNAME \
    && mkdir -p /workspace \
    && mkdir -p /home/$USERNAME/.cache \
    && mkdir -p /home/$USERNAME/.local \
    && chown -R $USERNAME:$USERNAME /workspace \
    && chown -R $USERNAME:$USERNAME /home/$USERNAME \
    && chown -R $USERNAME:$USERNAME /opt/poetry

WORKDIR /workspace

COPY --chown=$USERNAME:$USERNAME ./pyproject.toml ./poetry.lock* /workspace/

USER $USERNAME

RUN poetry install --no-root

CMD ["/bin/bash"]