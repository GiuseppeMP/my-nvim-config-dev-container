FROM debian:latest

ENV DEBIAN_FRONTEND noninteractive
ENV TZ=America/Brasilia

RUN apt-get update && \
    apt-get install -y software-properties-common && \
    rm -rf /var/lib/apt/lists/*

RUN apt update

RUN apt install luajit git curl build-essential unzip  -y

SHELL ["/bin/bash", "-lc"]

# install asdf to manage all the thingz!!!
RUN git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.11.3 && \
    echo ". $HOME/.asdf/asdf.sh" >> /root/.bashrc && \
    echo ". $HOME/.asdf/asdf.sh" >> /root/.zshrc

RUN source /root/.bashrc

# install plugins
RUN asdf plugin add nodejs && \
    asdf plugin add python && \
    asdf plugin add golang && \
    asdf plugin add awscli && \
    asdf plugin-add java https://github.com/halcyon/asdf-java.git && \
    asdf plugin add neovim && \
    asdf plugin add aws-sam-cli && \
    asdf plugin-add lua https://github.com/Stratus3D/asdf-lua.git

RUN asdf install neovim stable
RUN asdf global neovim stable
RUN asdf install nodejs latest
RUN asdf install lua 5.4.4

RUN asdf global nodejs latest
RUN asdf global lua 5.4.4

RUN npm i -g yarn
RUN luarocks install jsregexp

# nvim

RUN nvim -v
RUN mkdir -p ~/.config/nvim
RUN git clone https://github.com/GiuseppeMP/my-nvim-config.git ~/.config/nvim


# set all the things to be sure bash is always used as the default shell
RUN cd /bin && ln -sf bash sh && chsh -s /bin/bash

ENV SHELL=bash

ENV PATH=$PATH:/root/.bin

WORKDIR /root

ENTRYPOINT [ "/bin/bash", "-lc" ]
