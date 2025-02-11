# Améliorer la performance du shell en sautant l'initialisation globale des complétions
skip_global_compinit=1

# Activer le prompt instantané de Powerlevel10k
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Chemin vers l'installation de oh-my-zsh
export ZSH="/etc/skel/.oh-my-zsh"

# Définir le thème à utiliser
ZSH_THEME="powerlevel10k/powerlevel10k"

# Options de configuration de base améliorée
setopt AUTO_CD              # Permet de changer de répertoire en tapant seulement le nom du répertoire
setopt INTERACTIVE_COMMENTS # Permet les commentaires dans le shell interactif
setopt NO_CASE_GLOB        # Recherche insensible à la casse
setopt EXTENDED_GLOB       # Active les glob étendus

# Paramètres de complétion optimisés
autoload -Uz compinit
zstyle ':completion:*' rehash true
if [[ -n "/etc/skel/.zcompdump" ]]; then
  compinit -C
else
  compinit
fi

# Complétion plus intelligente
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' # Complétion insensible à la casse
zstyle ':completion:*' special-dirs true                  # Complétion pour les répertoires spéciaux .. et .
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}    # Colorisation des listes de complétion

# Liste des plugins à charger
plugins=(
  git
  zsh-autosuggestions
  zsh-syntax-highlighting
  zsh-completions
  z
  sudo
  history
  extract
  command-not-found
  docker
  fzf
)

# Configuration de l'éditeur par défaut
export VISUAL=vim
export EDITOR="vim"  # Utiliser vim comme éditeur par défaut

# Alias de base
alias zshconfig="vim /etc/skel/.zshrc"  # Ouvrir .zshrc avec vim
alias ohmyzsh="vim /etc/skel/.oh-my-zsh"  # Ouvrir le répertoire oh-my-zsh avec vim
alias tf="terraform"  # Alias pour terraform
alias ll="ls -alh"  # Lister les fichiers avec des détails
alias ls='ls -G'  # Lister les fichiers avec colorisation
alias l='ls -lah'  # Lister tous les fichiers y compris cachés
alias ..='cd ..'  # Remonter d'un répertoire
alias ...='cd ../..'  # Remonter de deux répertoires
alias grep='grep --color=auto'  # Grep avec colorisation
alias ports='netstat -tulanp'  # Lister les ports ouverts
alias ip='curl -s ipinfo.io | jq'  # Obtenir l'adresse IP publique

# Alias Git
alias gs="git status"
alias gd="git diff"
alias ga="git add ."
alias gc="git commit -m"
alias gco="git checkout"
alias gb="git branch"
alias gl="git log --oneline --graph --decorate --all"

# Alias développeur
alias dc='docker compose'
alias k='kubectl'

# Fonctions utiles
mkcd() { mkdir -p "$@" && cd "$@"; }  # Créer un répertoire et y accéder

# Configuration de Powerlevel10k
source /usr/share/powerlevel10k/powerlevel10k.zsh-theme
[[ ! -f /etc/skel/.p10k.zsh ]] || source /etc/skel/.p10k.zsh

# Configuration de Pyenv (si installé)
export PYENV_ROOT="/etc/skel/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init --path)"
  eval "$(pyenv virtualenv-init -)"
fi

# Configuration de Homebrew (si installé)
export HOMEBREW_NO_INSTALL_CLEANUP=TRUE
alias brew='env HOMEBREW_NO_AUTO_UPDATE=1 brew'

# Configuration de FZF
[ -f /etc/skel/.fzf.zsh ] && source /etc/skel/.fzf.zsh
export FZF_DEFAULT_COMMAND="fd --type f --hidden --exclude .git"
export FZF_ALT_C_COMMAND="fd --type d --hidden --exclude .git"

# Options avancées de FZF
export FZF_CTRL_T_OPTS="
  --preview 'bat -n --color=always {}'
  --bind 'ctrl-/:change-preview-window(down|hidden|)'"

export FZF_CTRL_R_OPTS="
  --preview 'echo {}'
  --preview-window up:3:hidden:wrap
  --bind 'ctrl-/:toggle-preview'"

# Thème FZF
fg="#CBE0F0"
bg="#011628"
bg_highlight="#143652"
purple="#B388FF"
blue="#06BCE4"
cyan="#2CF9ED"
export FZF_DEFAULT_OPTS="--color=fg:${fg},bg:${bg},hl:${purple},fg+:${fg},bg+:${bg_highlight},hl+:${purple},info:${blue},prompt:${cyan},pointer:${cyan},marker:${cyan},spinner:${cyan},header:${cyan}"

# Configuration de Bat (si installé)
export BAT_THEME=tokyonight_night

# Configuration de TheFuck (si installé)
eval $(thefuck --alias)
eval $(thefuck --alias fk)

# Configuration de l'historique
HISTFILE=/etc/skel/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt INC_APPEND_HISTORY
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_REDUCE_BLANKS
setopt EXTENDED_HISTORY
setopt SHARE_HISTORY
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_FIND_NO_DUPS

# Auto-correction
setopt CORRECT
setopt CORRECT_ALL

# Gestion du PATH
typeset -U path
export PATH="$PATH:/etc/skel/.local/bin"

# Raccourcis clavier
bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

# Optimisation Git pour gros repos
DISABLE_UNTRACKED_FILES_DIRTY="true"

# Chargement paresseux des plugins
{
  source /etc/skel/.oh-my-zsh/custom/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
  source /etc/skel/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
} &!

# Terraform autocomplete (si installé)
autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C /usr/bin/terraform terraform
