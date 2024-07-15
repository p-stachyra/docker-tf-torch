FROM nvidia/cuda:12.5.0-base-ubuntu22.04

ARG USER=jovyan

ENV NB_USER jovyan
ENV NB_UID 1000
ENV HOME /home/${NB_USER}
ENV NB_PREFIX /

ENV TZ=US \
    DEBIAN_FRONTEND=noninteractive

WORKDIR ${HOME}

RUN apt-get update && \
    apt-get install -y \
    git \
    python3-pip \
    python3-dev \
    python3-opencv \
    libglib2.0-0 \
    net-tools \
    htop \
    curl \
    sox 

RUN rm -rf /root/.pip/pip.conf
RUN cat /dev/null > /etc/apt/apt.conf.d/80proxy

COPY requirements.txt ${HOME}/requirements.txt

RUN python3 -m pip install -r ${HOME}/requirements.txt

RUN python3 -m pip install --upgrade pip

RUN pip3 install torch torchvision torchaudio tensorflow

RUN python3 -m pip install jupyter jupyterlab numpy ipykernel

USER root

CMD ["/bin/bash", "-c", "jupyter lab \
--notebook-dir=${HOME} \
--ip=0.0.0.0 --no-browser --allow-root --port=8888 \
--NotebookApp.token='' --NotebookApp.password='' --NotebookApp.allow_origin='*' \
--NotebookApp.base_url=${NB_PREFIX}"]

