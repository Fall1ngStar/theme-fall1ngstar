function _git_branch_name
  echo (command git symbolic-ref HEAD 2> /dev/null | sed -e 's|^refs/heads/||')
end

function _is_git_dirty
  echo (command git status -s --ignore-submodules=dirty 2> /dev/null)
end

function _is_in_git_repository
  echo (command git rev-parse --is-inside-work-tree 2>/dev/null)
end

function _git_project
  echo (git rev-parse --show-toplevel 2>/dev/null)
end

function fish_right_prompt
  # colors
  set -l grey (set_color -d white)
  set -l normal (set_color normal)

  if [ (_is_in_git_repository) ]
    if [ (_is_git_dirty) ]
      set dirty ' !'
    end
    
    set -l branch (_git_branch_name)
    if test (string length "$branch") -gt 20 
      set reduced_branch (string sub --length=18 $branch)..
    else 
      set reduced_branch $branch
    end

    set -l project (_git_project)
    set -l project_name (basename $project)
    
    echo -n -s $grey $project_name '/' $reduced_branch $dirty $normal ' '
  else
    set -l user (whoami)
    set -l host (hostname)

    echo -n -s $grey $user '@' $host $normal ' '
  end
end
