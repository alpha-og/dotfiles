# -- fzf --
eval "$(fzf --zsh)"
source ~/.config/fzf-git.sh/fzf-git.sh
# -- Use fd instead of fzf --

export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type=d --hidden --strip-cwd-prefix --exclude .git"

# Use fd (https://github.com/sharkdp/fd) for listing path candidates.
# - The first argument to the function ($1) is the base path to start traversal
# - See the source code (completion.{bash,zsh}) for the details.
_fzf_compgen_path() {
  fd --hidden --exclude .git . "$1"
}

# Use fd to generate the list for directory completion
_fzf_compgen_dir() {
  fd --type=d --hidden --exclude .git . "$1"
}

export FZF_CTRL_T_OPTS="--preview 'bat -n --color=always --line-range :500 {}'"
export FZF_ALT_C_OPTS="--preview 'eza --tree --color=always {} | head -200'"

# Advanced customization of fzf options via _fzf_comprun function
# - The first argument to the function is the name of the command.
# - You should make sure to pass the rest of the arguments to fzf.

_fzf_comprun() {
  local command=$1
  shift

  case "$command" in
    cd)           fzf --preview 'eza --tree --color=always {} | head -200' "$@" ;;
    export|unset) fzf --preview "eval 'echo $'{}"         "$@" ;;
    ssh)          fzf --preview 'dig {}'                   "$@" ;;
    *)            fzf --preview "bat -n --color=always --line-range :500 {}" "$@" ;;
  esac
}

# ---- Eza (better ls) -----
alias ls="eza --color=always --git --no-filesize --icons=always --no-time --no-user --no-permissions"

# ---- bat (better cat) ----
alias cat="bat"
export BAT_THEME="Catppuccin Mocha"

# ---- direnv ----
eval "$(direnv hook zsh)"

# ---- pnpm ----
export PNPM_HOME="/Users/athulanoop/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

# ---- zsh-autosuggestions ----
source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# ---- zsh-syntax-highlighting ----
source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# ---- starship ----
eval "$(starship init zsh)"

# ---- history ----
HISTFILE=~/.zsh_history
SAVEHIST=10000
HISTSIZE=999

setopt share_history
setopt hist_ignore_dups
setopt hist_expire_dups_first
setopt hist_verify

bindkey '^[[A' history-search-backward
bindkey '^[[B' history-search-forward

# ---- auto-start zellij ----
# eval "$(zellij setup --generate-auto-start zsh)"
export ZELLIJ_AUTO_START=true
if [[ -z "$ZELLIJ" ]]; then
  if [[ "$ZELLIJ_AUTO_START" == "true" && "$TERM_PROGRAM" == "WezTerm" ]]; then
    if command -v zellij &> /dev/null; then
      zellij -l welcome 
    else
      echo "Zellij not found. Please install it."
    fi
  fi
fi
