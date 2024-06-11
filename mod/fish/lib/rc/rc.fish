
# add path to .x-cmd.root/bin and .x-cmd.root/global/data/bin/l/j/h

if ! contains -- $HOME/.x-cmd.root/bin $PATH
    set -g PATH $HOME/.x-cmd.root/bin $PATH
end

if ! contains -- $HOME/.x-cmd.root/global/data/bin/l/j/h/bin $path
    set -g PATH $HOME/.x-cmd.root/global/data/bin/l/j/h/bin $PATH
end

function x
    ___x_cmd $argv
end

function c
    if [ "$argv[1]" = "-" ]
        cd -
        return
    end
    ___x_cmd cd $argv
end

function ___x_cmd
    setenv ___X_CMD_XBINEXP_FP "$HOME/.x-cmd.root/local/data/xbinexp/fish/$status"_(random)
    mkdir -p $___X_CMD_XBINEXP_FP
    setenv ___X_CMD_XBINEXP_INITENV_OLDPWD $OLDPWD

    bash "$HOME/.x-cmd.root/bin/xbinexp" $argv

    if [ -f "$___X_CMD_XBINEXP_FP/PWD" ]
        cd (cat $___X_CMD_XBINEXP_FP/PWD)
    end

    if [ -f "$___X_CMD_XBINEXP_FP/PATH" ]
        setenv PATH (cat $___X_CMD_XBINEXP_FP/PATH)
    end

    setenv ___X_CMD_XBINEXP_EVAL ""
    for file in $___X_CMD_XBINEXP_FP/*
        set _filename (basename $file)
        if string match -q "*_*" "$_filename"
            set varname (string replace -r '^[^_]+_' '' "$_filename")
            # set -g "$varname" "$(cat $file)"
            setenv "$varname" (cat $file)
        end
    end

    if string match -q "*xbinexp/fish*" "$___X_CMD_XBINEXP_FP"
        rm -rf "$___X_CMD_XBINEXP_FP"
    end

    if [ -n "$___X_CMD_XBINEXP_EVAL" ]
        set data "$___X_CMD_XBINEXP_EVAL"
        set -u ___X_CMD_XBINEXP_EVAL ""
        printf "%s\n" "===================" >&2
        printf ">>> %s\n\n" "$data" >&2
        printf "%s\n" "-------------------" >&2
        eval "$data"
        printf "\n%s\n" "===================" >&2
    end
end

# TODO: in the future, adding the advise

# "$HOME/.x-cmd.root/bin/xbin" prepare alias
if status is-interactive
    setenv ___X_CMD_IS_INTERACTIVE_FORCE 1
    # setenv ___X_CMD_CO_EXEC_SHELL=fish

    eval ("$HOME/.x-cmd.root/bin/xbin" chat --aliasinit --code)

    # chat, writer, w
    # eval "$("$HOME/.x-cmd.root/bin/xbin" aliasinit --code)"

    alias xw='x ws'
    alias xg='x git'
    # alias xd='x docker'

    alias ,="x fish --sysco"
end
setenv ___X_CMD_THEME_RELOAD_DISABLE 1

