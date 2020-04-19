FROM ubuntu:18.04

WORKDIR /build

RUN apt-get update \
&&  apt-get install -y python3 python3-pip python3-psycopg2 python3-mysqldb gcc g++ \
                       neovim sudo tmux software-properties-common libfreetype6-dev \
&&  add-apt-repository ppa:deadsnakes/ppa \
&&  apt-get update &&  apt-get install -y python3.8 \
&&  apt-get install -y python3.7 \
&&  pip3 install pip jupyterlab jupytext pandas numpy scipy pyviz holoviews ipywidgets pipenv sklearn --upgrade \
&&  useradd -m -r -s /bin/bash zues \
&&  passwd -d zues \
&&  echo 'zues ALL=(ALL) ALL' > /etc/sudoers.d/zues \
&&  mkdir -p /home/zues/.gnupg \
&&  echo 'standard-resolver' > /home/zues/.gnupg/dirmngr.conf \
&&  chown -R zues:zues /home/zues \
&&  chown -R zues:zues /build \
&&  apt-get install -y curl \
&&  curl -sL https://deb.nodesource.com/setup_13.x | sudo -E bash - \
&&  apt-get install -y nodejs \
&&  apt-get update \
&&  DEBIAN_FRONTEND=noninteractive apt-get install -y pandoc \
&&  apt-get install -y wget libssl-dev openssl \
&&  apt-get update \
&&  DEBIAN_FRONTEND=noninteractive apt-get install -y software-properties-common apt-transport-https \
&&  wget -q https://packagecloud.io/AtomEditor/atom/gpgkey -O- | sudo apt-key add - \
&&  add-apt-repository "deb [arch=amd64] https://packagecloud.io/AtomEditor/atom/any/ any main" \
&&  wget -q https://packages.microsoft.com/keys/microsoft.asc -O- | apt-key add - \
&&  add-apt-repository "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" \
&&  apt-get update \
&&  DEBIAN_FRONTEND=noninteractive apt-get install -y atom code spyder3 \
&&  apt-get clean

RUN pip3 install notebook xeus-python ptvsd jupyter-lsp python-language-server[all] ipysheet plotly \
    jupyterlab-commenting-service dash jupyterlab_code_formatter jupyter_starters black jupyter-launcher-shortcuts \
&&  jupyter labextension install jupyterlab-jupytext \
&&  jupyter labextension install @jupyter-widgets/jupyterlab-manager \
&&  jupyter labextension install @pyviz/jupyterlab_pyviz \
&&  jupyter labextension install @ijmbarr/jupyterlab_spellchecker \
&&  jupyter labextension install @bokeh/jupyter_bokeh \
&&  jupyter labextension install @jupyter-widgets/jupyterlab-manager \
&&  jupyter labextension install ipysheet \
&&  jupyter labextension install @ryantam626/jupyterlab_code_formatter \
&&  jupyter serverextension enable --py jupyterlab_code_formatter --sys-prefix \
&&  jupyter labextension install @jupyterlab/toc \
&&  jupyter labextension install @krassowski/jupyterlab-lsp \
&&  jupyter labextension install @krassowski/jupyterlab_go_to_definition \
&&  jupyter labextension install jupyterlab-kernelspy \
&&  jupyter labextension install jupyterlab-gitlab \
&&  jupyter labextension install @deathbeds/jupyterlab-starters \
&&  jupyter labextension install jupyterlab-topbar-extension jupyterlab-system-monitor \
&&  jupyter labextension install jupyterlab_filetree \
&&  jupyter labextension install @jupyterlab/toc \
&&  jupyter labextension install @lckr/jupyterlab_variableinspector \
&&  jupyter labextension install jupyterlab-python-file 

ENV DISPLAY=:0
ENV SID=zues
ENV UID=1000
ENV GID=1000

COPY id-clone /build/id-clone
COPY zues.tar /build/zues.tar 
COPY entrypoint.sh /entrypoint.sh 

# &&  cd /build/jupyterlab_city-lights-theme \
# &&  jupyter labextension install .

ENTRYPOINT ["/entrypoint.sh"]
CMD ["jupyter" "lab" "--ip 0.0.0.0"]
