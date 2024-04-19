# Configuration `dotfiles`

This repository serves to be a collection of configurations that I use and document the process of setting up a development workflow and environment.

## Neovim

My neovim configuration is a combination of different configurations I've come across. I've just started exploring Neovim and so this configuration is in no way perfect. If you're looking for something thats stable and quick to setup, I suggest you take a look at some of the alternative distros for a quick-start.

### Structure

```
nvim
└── lua
    ├── core
    ├── plugins
    │   └── lsp
    └── utils
```

The `nvim` directory _usually_ goes into the `~/.config/` directory since by default Neovim expects the configuration files to be present in this directory. However, if you wish to maintain a `dotfiles` repository for yourself you may want to `symlink` the files from your repository into `~/.config/`.

The `lua` directory is where all the actual configuration goes into. For better code organisation, the config files are placed into three distinct directories, namely — `core`, `plugins` and `utils`. The `core` directory has foundational code for creating a full-fledged editor/ IDE out of neovim and includes keymaps, auto-commands, theme configurations, etc... All plugin related code goes into the `plugins` directory (more on this in later sections). The `utils` directory is where we define helper functions and other not so important, but nevertheless useful utilties.

The directory names needn't be the exact same and you could get away with custom names for the directories. However, if you're just starting out or just dont want to have messy code with file path references in the config files then it would be better to leave the names of the directorys as it is. Neovim implicitly indexes/ uses the configuration files without further intervention from our side if we use these directory names and makes it easier to reference different config files in our `init.lua` files (I've explained this further ahead)

### How does everything add up?

PS: In most if not all config files within the `~/.config/nvim/lua` directory, when importing/ referencing user defined files and/ or directories the path with respect to the said `lua` directory is specified

The entry point for neovim when it looks for configuration files, is the `init.lua` file inside the `~/.config/nvim` directory. `init.lua` has a single line of code which imports/ references the `core` directory within the `~/.config/nvim/lua` directory. On closer inspection of the code in this file, it may come to your notice that, no-where have we specified the file path to the `core` directory. So, how does neovim actually reference the contents of that directory? This is where the directory names we defined earlier come to life. The `lua` directory is automatically searched for the required files or folders; however, if this directory was called something else, then we would have to specify the path as well.

Alright, so we've successfully imported the `core` directory, but again how does neovim actually go about using the contents of the directory? Just as we had an `init.lua` file in the `~/.config/nvim`, we also define an `init.lua` file within the `core` directory. This file is where we bootstrap the lazy plugin managerand import configurations for editor options, keymaps and auto-commands. We also specify the themes to be installed (it is also required to export a lua table with the plugin spec corresponding to the theme within the `plugins` directory). In order for lazy to correctly load the required plugins we also have to specify the path of the `plugins` directory and any sub-directories within the the `plugins` directory

The lazy plugin manager will handle the installation of plugins, based on the lua tables exported by files in the `plugins` directory.

## Window Management 
I've chosen to go with a tiling window manager, Yabai supplemented by Skhd for shortcuts. Both can be installed via homebrew. 

## Terminal Configuration
I've customised my terminal using oh-my-zsh and the powerlevel10k theme. I am also using some other CLI utilties like fzf and fd for fuzzy finding, bat, eza amd git-delta
