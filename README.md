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

The `nvim` folder _usually_ goes into the `~/.config/` folder since by default Neovim expects the configuration files to be present in this folder. However, if you wish to maintain a `dotfiles` repository for yourself you may want to `symlink` the files from your repository into `~/.config/`.

The `lua` folder is where all the actual configuration goes into. For better code organisation, the config files are placed into three distinct folders, namely — `core`, `plugins` and `utils`. The `core` folder has foundational code for creating a full-fledged editor/ IDE out of neovim and includes keymaps, auto-commands, theme configurations, etc... All plugin related code goes into the `plugins` folder (more on this in later sections). The `utils` folder is where we define helper functions and other not so important, but nevertheless useful utilties.

The folder names needn't be the exact same and you could get away with custom names for the folders. However, if you're just starting out or just dont want to have messy code with file path references in the config files then it would be better to leave the names of the folders as it is. Neovim implicitly indexes/ uses the configuration files without further intervention from our side if we use these folder names and makes it easier to reference different config files in our `init.lua` files (I've explained this further ahead)

### How does everything add up?

