#FROM alpine:3.13.1
FROM alpine:edge

RUN mkdir /root/workdir

RUN apk add --no-cache gcc clang neovim git openssh nodejs npm clang-extra-tools python3 py3-pip valgrind gdb build-base bash ripgrep

# sh
ARG PROMPT=🐋
ARG USER=marvin

ENV USER=${USER}
ENV EMAIL=$USER@student.42.fr

COPY dotfiles/shrc /shrc

RUN cat /shrc >> /etc/profile ; \
	rm shrc ; \
	sed -i "s/{{PROMPT}}/$PROMPT/g" /etc/profile

# norminette
RUN python3 -m pip install --upgrade pip setuptools && \
	python3 -m pip install norminette

# nvim
ENV XDG_CONFIG_HOME /home/.config
ENV VIM_LEADER m
ENV VIM_LOCAL_LEADER 8

RUN mkdir -p $XDG_CONFIG_HOME/nvim

COPY dotfiles/vimrc $XDG_CONFIG_HOME/nvim/init.vim
RUN sed -i "s/{{VIM_LEADER}}/$VIM_LEADER/g" $XDG_CONFIG_HOME/nvim/init.vim ; \
	sed -i "s/{{VIM_LOCAL_LEADER}}/$VIM_LOCAL_LEADER/g" $XDG_CONFIG_HOME/nvim/init.vim

# vim-plug
RUN mkdir -p $XDG_CONFIG_HOME/nvim/autoload && \
	wget -O $XDG_CONFIG_HOME/nvim/autoload/plug.vim \
		https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim && \
	nvim --headless -c PlugInstall -c qall > /dev/null

# coc
COPY dotfiles/coc-settings.json $XDG_CONFIG_HOME/nvim/

RUN nvim --headless -c "CocInstall coc-clangd" -c "CocCommand clangd.install" -c qall > /dev/null

COPY norminette-lsp /usr/bin

# docker_entrypoint
COPY ./docker_entrypoint.sh /docker_entrypoint.sh

WORKDIR /root/workdir

CMD sh /docker_entrypoint.sh && /bin/bash -l
