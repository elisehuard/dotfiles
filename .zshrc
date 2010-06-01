#
# .zshrc is sourced in interactive shells.  It contains options, aliases,
# functions, key bindings and more.  In a login shell, it will be sourced
# after .zprofile.
#
# $Id: dot.zshrc 40 2008-05-08 09:02:08Z philip $
#

# Undo the damage from .zshenv
unalias alias 2>/dev/null

# zsh options
setopt \
    append_history	\
    auto_cd		\
    auto_list		\
    bang_hist		\
    correct		\
    extended_history	\
    glob		\
    glob_complete	\
    hist_ignore_space	\
    hist_no_functions	\
    hist_no_store	\
    hist_reduce_blanks	\
    hist_save_no_dups	\
    list_packed		\
    long_list_jobs	\
    mark_dirs		\
    nobeep		\
    nonomatch		\
    notify		\
    prompt_subst	\
    share_history

# Save command line history
HISTSIZE=1000
SAVEHIST=500

# An informative prompt
case $UID in
0)
    PS1="[%h] (%B%m%b:%U%~%u)%# "
    HISTFILE=/root/.zhistory
    ;;
*)
    PS1='[%h] ${vcs_info_msg_0_}(%B%n@%m%b)%U%25<...<%~%<<%u%# '
    # PS1="[%h] ${vcs_info_msg_0_}(%B%n@%m%b)%U%~%u%# "
    HISTFILE=$HOME/.zhistory
    ;;
esac

# Other useful environment variables
export BLOCKSIZE=K
export LESS=-Mi
#export LSCOLORS=ExGxcxdxCxegDxabagacad
export NETHACKOPTIONS=color,noautopickup
export PAGER=less
export MANWIDTH=80

# A righteous umask
umask 002

# I want coredumps, really
limit coredumpsize 128M

# No spelling correct on cp, mkdir and mv
alias cp='nocorrect cp'
alias mkdir='nocorrect mkdir'
alias mv='nocorrect mv'

# Standard helpful aliases
alias d='dirs -v'
alias h='history 24'
alias j='jobs -l'
alias reload='source $HOME/.zshrc'

#temporary throw-away aliases
alias dpp='cd ~/dpplus/branches/dpplus-0.9'
alias gemdir='cd /opt/ruby-enterprise-1.8.7-2009.10/lib/ruby/gems/1.8/gems/'
alias lock='xscreensaver-command -lock'

# Implementations of ls vary wildly
case $OSTYPE in
linux*)
    alias ls='ls --color -F'
    alias ll='ls --color -F -lA'
    ;;
solaris*)
    alias ls='ls -F'
    alias ll='ls -F -lA'
    ;;
*)
    alias ls='ls -FG'
    alias ll='ls -FG -lA'
    ;;
esac

# List only directories and symbolic links that point to directories
alias lsd='ls -ld *(-/DN)'
    
# Use friendly tools if available
if [[ -x =bsdtar ]]; then
    alias tar='bsdtar'
fi

if [[ -x =lftp ]]; then
    alias ftp='lftp'
fi

if [[ -x =w3m ]]; then
    alias man='w3mman'
    export BROWSER=w3m
fi

if [[ -x =vim ]]; then
    alias vi='vim'
    export EDITOR=vim
else
    export EDITOR=vi
fi

# Needed for ssh-agent and others
if [[ -z "$SSH_AUTH_SOCK" ]]; then
    export SSH_AUTH_SOCK=$HOME/.ssh/ssh-auth-sock.$HOSTNAME
fi

# Change xterm/sun-cmd titles on startup
if [[ -t 1 ]]; then
    case $TERM in
    sun-cmd)
	print -Pn "\e]l%~\e\\"
	;;
    screen|*xterm*|rxvt|(dt|k|E)term)
        print -Pn "\e]0;%n@%m:%~\a"
	;;
    esac
fi

# Change xterm/sun-cmd titles when changing directories
chpwd() {
    [[ -t 1 ]] || return
    case $TERM in
    sun-cmd)
	print -Pn "\e]l%~\e\\"
	;;
    *xterm*|rxvt|(dt|k|E)term)
	print -Pn "\e]2;%n@%m:%~\a"
	;;
    esac
}

# Load vcs information before every function
function precmd { vcs_info }

# Emulate tcsh's run-fg-editor
run-fg-editor() {
    zle push-input
    BUFFER="fg %$EDITOR:t"
    zle accept-line
}
zle -N run-fg-editor

# Emulate tcsh's backward-delete-word
tcsh-backward-delete-word () {
    local WORDCHARS="${WORDCHARS:s#/#}"
    zle backward-delete-word
}
zle -N tcsh-backward-delete-word

# Sensible keybindings
bindkey -e
bindkey "OA" history-search-backward
bindkey "OB" history-search-forward
bindkey "[A" history-search-backward
bindkey "[B" history-search-forward
bindkey "" tcsh-backward-delete-word
bindkey "^Z" run-fg-editor

# Fix <home>, <end> and <delete> keys *sigh*
bindkey "[7~" beginning-of-line
bindkey "[4~" end-of-line
bindkey "[3~" delete-char

# Where to look for autoloaded function definitions
fpath=($fpath ~/.zfunc)

# Load completions and version control hoodoo
autoload -U compinit && compinit
autoload -Uz vcs_info

# Treat w3mman like man for completions
compdef _man w3mman

# Change the behaviour of completions
zstyle ':completion:*' completer _complete _correct _approximate
zstyle ':completion:*:default' list-colors "$LS_COLORS"

# Define behavior for vcs_info
zstyle ':vcs_info:*' enable cvs git svn
zstyle ':vcs_info:*' actionformats '%F{5}{%s:%b %a}%f'
zstyle ':vcs_info:*' formats '%F{5}{%s:%b}%f'

# Needed for the sensible completion of ssh and friends
users=(elise ehu root)
hosts=(${${${${(f)"$(<$HOME/.ssh/known_hosts)"}:#[0-9]*}%%\ *}%%,*})
zstyle ':completion:*:hosts' hosts $hosts

# Load settings from .zshrc.local if it exists
if [[ -f $HOME/.zshrc.local ]]; then
    source $HOME/.zshrc.local
fi

# vim: ft=zsh

# java apps in awesome
export AWT_TOOLKIT='MToolkit java -jar weka.jar'
export JDK_HOME=/usr/lib/jvm/java-6-sun
