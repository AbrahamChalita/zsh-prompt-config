# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/Users/abrahamch/opt/anaconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/Users/abrahamch/opt/anaconda3/etc/profile.d/conda.sh" ]; then
        . "/Users/abrahamch/opt/anaconda3/etc/profile.d/conda.sh"
    else
        export PATH="/Users/abrahamch/opt/anaconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

# Load vcs_info for Git branch details
autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git:*' formats 'on %F{green}git:(%f%F{123}%b%f%F{green})%f'

# Function to check Git status and set prompt elements
git_prompt_info() {
    if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
        # Uncommitted files
        local uncommitted_count=$(git status --porcelain 2> /dev/null | wc -l | tr -d ' ')
        [[ $uncommitted_count -gt 0 ]] && uncommitted_prompt="%F{green}±${uncommitted_count}%f" || uncommitted_prompt=""

        # Stash count
        local stash_count=$(git stash list 2> /dev/null | wc -l | tr -d ' ')
        [[ $stash_count -gt 0 ]] && stash_prompt="%F{123}<✵${stash_count}>%f" || stash_prompt=""

        # Commits ahead/behind remote
        local git_status=$(git status -sb 2> /dev/null)
        local ahead_count=$(echo $git_status | grep -o '\[ahead [0-9]*\]' | grep -o '[0-9]*')
        local behind_count=$(echo $git_status | grep -o '\[behind [0-9]*\]' | grep -o '[0-9]*')
        [[ -n $ahead_count ]] && ahead_prompt="%F{123}⇡${ahead_count}%f" || ahead_prompt=""
        [[ -n $behind_count ]] && behind_prompt="%F{123}⇣${behind_count}%f" || behind_prompt=""

        # Merge conflicts, staged, unstaged, untracked
        local merge_conflicts=$(git diff --name-only --diff-filter=U 2> /dev/null | wc -l | tr -d ' ')
        [[ $merge_conflicts -gt 0 ]] && merge_conflict_prompt="%F{226}~${merge_conflicts}%f" || merge_conflict_prompt=""

        local staged_changes=$(git diff --cached --numstat 2> /dev/null | wc -l | tr -d ' ')
        [[ $staged_changes -gt 0 ]] && staged_prompt="%F{220}+${staged_changes}%f" || staged_prompt=""

        local unstaged_changes=$(git diff --numstat 2> /dev/null | wc -l | tr -d ' ')
        [[ $unstaged_changes -gt 0 ]] && unstaged_prompt="%F{220}!${unstaged_changes}%f" || unstaged_prompt=""

        local untracked_files=$(git ls-files --others --exclude-standard 2> /dev/null | wc -l | tr -d ' ')
        [[ $untracked_files -gt 0 ]] && untracked_prompt="%F{123}?${untracked_files}%f" || untracked_prompt=""

        local repo_state=$(git status | grep -o 'rebase in progress\|merging\|applying' | head -1)
        [[ -n $repo_state ]] && repo_state_prompt="%F{123}${repo_state}%f" || repo_state_prompt=""
    else
        uncommitted_prompt=""
        stash_prompt=""
        ahead_prompt=""
        behind_prompt="" 
        merge_conflict_prompt=""
        staged_prompt=""
        unstaged_prompt=""
        untracked_prompt=""
        repo_state_prompt=""
    fi
}

precmd() { 
    vcs_info 
    git_prompt_info
}

setopt prompt_subst

# prompt='%F{red}abraham%f at %F{214}%m%f in %F{033}%~%f ${vcs_info_msg_0_}${uncommitted_prompt}${stash_prompt}${ahead_prompt}${behind_prompt}${merge_conflict_prompt}${staged_prompt}${unstaged_prompt}${untracked_prompt}${repo_state_prompt}
# $ '

prompt='%F{red}abraham%f in %F{038}%~%f ${vcs_info_msg_0_}${uncommitted_prompt}${stash_prompt}${ahead_prompt}${behind_prompt}${merge_conflict_prompt}${staged_prompt}${unstaged_prompt}${untracked_prompt}${repo_state_prompt}
$ '

# Export the PS1 variable
export PS1=$prompt

alias ls='ls -1'
alias ls='ls -G'

source $HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source $HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# remove syntax underlining
(( ${+ZSH_HIGHLIGHT_STYLES} )) || typeset -A ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES[path]=none
ZSH_HIGHLIGHT_STYLES[path_prefix]=none
