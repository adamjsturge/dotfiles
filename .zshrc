#!/bin/zsh

export SKIM_DEFAULT_OPTIONS="--tiebreak=score,index"
export ZSH_AUTOSUGGEST_HISTORY_IGNORE="cd *|?(#c50,)"
export PATH="$PATH:$HOME/.composer/vendor/bin"
export PATH="$PATH:$HOME/go/bin"
export GOPATH=$HOME/go
# source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
# source /opt/homebrew/share/zsh-history-substring-search/zsh-history-substring-search.zsh

source /opt/homebrew/share/antigen/antigen.zsh

antigen bundle zsh-users/zsh-autosuggestions
antigen bundle zsh-users/zsh-completions
antigen bundle zsh-users/zsh-history-substring-search
antigen bundle zsh-users/zsh-syntax-highlighting

bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

eval "$(starship init zsh)"

autoload -Uz edit-command-line
zle -N edit-command-line
bindkey -M vicmd 'v' edit-command-line

# History tweaks
mkdir -p "${HOME}/.local/share/zsh"
HISTFILE="${HOME}/.local/share/zsh/history"
HISTSIZE=1000000000
SAVEHIST=$HISTSIZE
setopt inc_append_history # Append every command to $HISTFILE immediately
setopt share_history      # Always import new commands from $HISTFILE
setopt extended_history   # Save additional info to $HISTFILE
setopt hist_ignore_space  # Ignore history beginning with a space
setopt NO_BEEP

# Eliminate escape delay
KEYTIMEOUT=1

# Allow new features, i.e. ^ which negates the pattern following it
# ls <100-200>.txt, **/, and more
setopt extendedglob

#If pattern for filename generation has no matches, print an error.
setopt nomatch

# Disable changing the window title
export DISABLE_AUTO_TITLE=true

bindkey '^R' history-incremental-search-backward

# source "${HOME}/.config/zsh/alias.zsh"

# autoload -Uz manydots-magic
# manydots-magic

# fpath+=~/.config/zsh/.zfunc

# The following lines were added by compinstall
zstyle ':completion:*' completer _expand _complete _ignored _approximate
zstyle ':completion:*' use-cache on
zstyle ':completion:*' expand prefix suffix
zstyle ':completion:*' file-sort access
zstyle ':completion:*' ignore-parents parent .. directory
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt '%SAt %p: Hit TAB for more, or the character to insert%s'
zstyle ':completion:*' list-suffixes true
zstyle ':completion:*' matcher-list 'm:{[:lower:]}={[:upper:]}' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'r:|[._-]=** r:|=**' 'l:|=* r:|=*'
zstyle ':completion:*' menu select=1
zstyle ':completion:*' select-prompt '%SScrolling active: current selection at %p%s'
zstyle ':completion:*:*:docker:*' option-stacking yes
zstyle ':completion:*:*:docker-*:*' option-stacking yes

autoload -Uz compinit
compinit
# End of lines added by compinstall

# The next line updates PATH for the Google Cloud SDK.
if [ -f "$HOME/Downloads/google-cloud-sdk/path.zsh.inc" ]; then source "$HOME/Downloads/google-cloud-sdk/path.zsh.inc"; fi

# The next line enables shell command completion for gcloud.
if [ -f "$HOME/Downloads/google-cloud-sdk/completion.zsh.inc" ]; then source "$HOME/Downloads/google-cloud-sdk/completion.zsh.inc"; fi

compdef _gnu_generic delta

# source ~/.config/zsh/aliases/init.zsh

# # >>> conda initialize >>>
# # !! Contents within this block are managed by 'conda init' !!
# __conda_setup="$('/usr/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
# if [ $? -eq 0 ]; then
#     eval "$__conda_setup"
# else
#     if [ -f "/usr/etc/profile.d/conda.sh" ]; then
#         . "/usr/etc/profile.d/conda.sh"
#     else
#         export PATH="/usr/bin:$PATH"
#     fi
# fi
# unset __conda_setup
# # <<< conda initialize <<<

autoload -U +X bashcompinit && bashcompinit

# Herd injected NVM configuration
export NVM_DIR="$HOME/Library/Application Support/Herd/config/nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm

[[ -f "/Applications/Herd.app/Contents/Resources/config/shell/zshrc.zsh" ]] && builtin source "/Applications/Herd.app/Contents/Resources/config/shell/zshrc.zsh"

# Herd injected PHP 8.3 configuration.
export HERD_PHP_83_INI_SCAN_DIR="$HOME/Library/Application Support/Herd/config/php/83/"


# Herd injected PHP binary.
export PATH="$HOME/Library/Application Support/Herd/bin/":$PATH