FROM alpine:latest

RUN apk add --no-cache gcc clang neovim git nodejs npm clang-extra-tools ruby-bundler

# sh
COPY dotfiles/shrc /shrc

#RUN mv /etc/profile.d/color_prompt /etc/profile.d/color_prompt.sh

# nvim
ENV XDG_CONFIG_HOME /home/.config

RUN mkdir -p $XDG_CONFIG_HOME/nvim

COPY dotfiles/vimrc $XDG_CONFIG_HOME/nvim/init.vim

# vim-plug
RUN mkdir -p $XDG_CONFIG_HOME/nvim/autoload && \
	wget -O $XDG_CONFIG_HOME/nvim/autoload/plug.vim \
		https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim && \
	nvim --headless +PlugInstall +qall &> /dev/null

# coc
COPY dotfiles/coc-settings.json $XDG_CONFIG_HOME/nvim/
#RUN nvim --headless +"CocInstall coc-clangd" +"sleep 2" +qall

RUN cat /shrc >> /etc/profile ; rm shrc

#norminette
RUN git clone https://github.com/42Paris/norminette.git /home/.norminette && \
	cd /home/.norminette && \
	bundle && \
	cd -

ARG EMOJI

RUN	sed -i "s/{{EMOJI}}/${EMOJI:-🐋}/g" /etc/profile

#COPY dotfiles/shrc /etc/bash.bashrc

#919
#WORKDIR /root

CMD /bin/sh -l
