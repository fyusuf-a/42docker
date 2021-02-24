# 42docker
A containerized working environment for the Macs in 42Paris containing:
* neovim (aliased as vim)
* [coc-neovim](https://github.com/neoclide/coc.nvim) with syntax highlighting, linting with [coc-clangd](https://github.com/clangd/coc-clangd) and a custom norminette [language server](https://microsoft.github.io/language-server-protocol/).
* git, norminette v2, valgrind, gdb

## How to run

### Warning
Prepare to lose all your docker containers. They should be saved if you want to process further. The following procedure makes your .docker be in your sgoinfre, which can be destroyed at any moment by the staff's bots.

### Move your .docker directory to sgoinfre

```bash
mkdir -p /sgoinfre/goinfre/Perso/$USER
mv $HOME/.docker /sgoinfre/goinfre/Perso/$USER/docker
ln -sf /sgoinfre/goinfre/Perso/$USER/docker $HOME/.docker
```

### Pull the image and build it

```sh
git clone https://github.com/fyusuf-a/42docker
cd 42docker
docker build -t 42docker .
```

### Execute it with your current directory as the working directory
```sh
docker run --rm -it -v $PWD:/root/workdir -v $HOME/.gitconfig:/root/.gitconfig -v $HOME/.ssh:/root/.ssh 42docker
```

#### Experimental - add your own .vimrc
```sh
docker run --rm -it -v $PWD:/root/workdir -v $HOME/.gitconfig:/root/.gitconfig -v $HOME/.ssh:/root/.ssh $HOME/.vimrc:/root/.vimrc 42docker
```
If you want more plugins, you can bind a plugin.vim as such (with a [vim-plug](https://github.com/junegunn/vim-plug) syntax) :
```sh
docker run --rm -it -v $PWD:/root/workdir -v $HOME/.gitconfig:/root/.gitconfig -v $HOME/.ssh:/root/.ssh $HOME/.vimrc:/root/.vimrc /path/to/plugin.vim:/root/plugin.vim 42docker
```
An example with basic (and awesome!) plugins is given in the example subdirectory of this repository.
