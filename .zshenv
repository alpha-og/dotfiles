
if [[ "$(uname)" != "Darwin" ]]
then
    eval "$("$HOME/.local/bin/mise" activate zsh)"
fi



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
