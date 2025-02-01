# ---- homebrew path----

if [[ -d "/opt/homebrew/bin" ]] && [[ "$(uname)" == "Darwin" ]]
then
    eval "$(/opt/homebrew/bin/brew shellenv)"
    eval "$(mise activate zsh)"
else
    eval "$("$HOME/.local/bin/mise" activate zsh)"
fi


# ---- mise path ----

# ---- pnpm path ----
if [[ "$(uname)" == "Darwin" ]]
then
    export PNPM_HOME="$HOME/Library/pnpm"
    case ":$PATH:" in
      *":$PNPM_HOME:"*) ;;
      *) export PATH="$PNPM_HOME:$PATH" ;;
    esac
fi

# ---- add directory for custom commands/ scripts ----
export PATH="$PATH:$HOME/bin"

# ---- cargo path ----
. "$HOME/.cargo/env"
