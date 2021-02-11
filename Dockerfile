FROM alpine:3.13.1

RUN mkdir /root/workdir

RUN apk add --no-cache gcc clang neovim git openssh nodejs npm clang-extra-tools ruby-bundler ruby-dev build-base

# norminette
RUN git clone https://github.com/42Paris/norminette.git /home/.norminette && \
	cd /home/.norminette && \
	bundle && \
	mv norminette.rb norminette && \
	cd -

# sh
COPY dotfiles/shrc /shrc

RUN cat /shrc >> /etc/profile ; rm shrc

# nvim
ENV XDG_CONFIG_HOME /home/.config

RUN mkdir -p $XDG_CONFIG_HOME/nvim

COPY dotfiles/vimrc $XDG_CONFIG_HOME/nvim/init.vim

# vim-plug
RUN mkdir -p $XDG_CONFIG_HOME/nvim/autoload && \
	wget -O $XDG_CONFIG_HOME/nvim/autoload/plug.vim \
		https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim && \
	nvim --headless -c PlugInstall -c qall > /dev/null

# coc
COPY dotfiles/coc-settings.json $XDG_CONFIG_HOME/nvim/

RUN nvim --headless -c "CocInstall coc-clangd" -c qall > /dev/null

COPY norminette-lsp /usr/bin

ARG EMOJI

RUN	sed -i "s/{{EMOJI}}/${EMOJI:-🐋}/g" /etc/profile

WORKDIR /root/workdir

CMD /bin/sh -l
