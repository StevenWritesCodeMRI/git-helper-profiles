PROJECTS_DIR="c:/workspaces/"

# get current status of git repo
function parse_git_dirty {
    status=`git status 2>&1 | tee`
    dirty=`echo -n "${status}" 2> /dev/null | grep "modified:" &> /dev/null; echo "$?"`
    untracked=`echo -n "${status}" 2> /dev/null | grep "Untracked files" &> /dev/null; echo "$?"`
    ahead=`echo -n "${status}" 2> /dev/null | grep "Your branch is ahead of" &> /dev/null; echo "$?"`
    newfile=`echo -n "${status}" 2> /dev/null | grep "new file:" &> /dev/null; echo "$?"`
    renamed=`echo -n "${status}" 2> /dev/null | grep "renamed:" &> /dev/null; echo "$?"`
    deleted=`echo -n "${status}" 2> /dev/null | grep "deleted:" &> /dev/null; echo "$?"`
    bits=''
    if [ "${renamed}" == "0" ]; then
        bits=">${bits}"
    fi
    if [ "${ahead}" == "0" ]; then
        bits="*${bits}"
    fi
    if [ "${newfile}" == "0" ]; then
        bits="+${bits}"
    fi
    if [ "${untracked}" == "0" ]; then
        bits="?${bits}"
    fi
    if [ "${deleted}" == "0" ]; then
        bits="x${bits}"
    fi
    if [ "${dirty}" == "0" ]; then
        bits="!${bits}"
    fi
    if [ ! "${bits}" == "" ]; then
        echo " \033[5m${bits}\033[25m"
    else
        echo ""
    fi
}

COLOR_RED="\[\033[0;31m\]"
COLOR_VIOLET="\[\033[0;35m\]"
COLOR_YELLOW="\[\033[0;33m\]"
COLOR_GREEN="\[\033[0;32m\]"
COLOR_BLUE="\[\033[0;34m\]"
COLOR_CYAN="\[\033[0;36m\]"
COLOR_WHITE="\[\033[0;37m\]"
RESET="\[\033[0m\]"
BOLD_RED="\[\e[1;31m\]"
BOLD_VIOLET="\[\033[1;35m\]"
BOLD_GREEN="\[\033[1;32m\]"
BOLD_BLUE="\[\033[1;34m\]"
BOLD_CYAN="\[\033[1;36m\]"
BOLD_WHITE="\[\033[1;37m\]"

function get_status_color {
  if [ "${1}" == "" ]; then
    echo $BOLD_GREEN
  else
    echo $BOLD_RED
  fi
}

# get current branch in git repo
function parse_git_branch {
    BRANCH=`git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'`
    if [ ! "${BRANCH}" == "" ]
    then
        STAT=`parse_git_dirty`
        COLOR=`get_status_color ${STAT}`
        PS1="${PS1} ${COLOR}(${BRANCH}${STAT})"
    fi
}

BRANCH=`git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'`

alias gb="git branch"

alias gc="git checkout"

alias gm="git merge --no-ff"

alias pull="git pull --rebase"

alias push="git push -u origin ${BRANCH}"

alias gr="git rebase"

alias gg="git gui"

alias gs="git status"

alias mss="cd ${PROJECTS_DIR}/MRISecureSign"

function dev {
    git checkout development
    git pull --rebase
    }

function set_prompt {
    PS1="$COLOR_WHITE\u $BOLD_BLUE@ $COLOR_GREEN\h$RESET $BOLD_CYAN[\w]$RESET"
    parse_git_branch
    PS1="${PS1}\n$BOLD_VIOLET>$RESET "
}

PROMPT_COMMAND=set_prompt

export PS1
