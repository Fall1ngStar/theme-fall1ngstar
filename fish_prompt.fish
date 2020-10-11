set -g fish_prompt_pwd_dir_length 0

# Check if in git repository
function _is_in_git_repository
  echo (command git rev-parse --git-dir 2>/dev/null)
end


function fish_prompt
  set -l last_status $status
  # Customize fish prompt
  set -l green (set_color green)
  set -l red (set_color red)
  set -l normal (set_color normal)
  set -l arrow "❯"

  # Set shell color based on the result of the last command
  if test $last_status = 0
      set color green
  else
      set color red
  end
  set -l prompt_color (set_color $color)
  

  # Set cwd for git repository
  if [ (_is_in_git_repository) ]
    set cwd (string replace (git rev-parse --show-toplevel 2>/dev/null) "" $PWD)
    set cwd (string trim --left --chars "/" $cwd)
  else
    set cwd (prompt_pwd)
  end

  # Reduce prompt lenght to 30 chars max
  if test (string length "$cwd") -gt 30 
    set reduced_cwd ..(string sub --start=-28 $cwd)
  else 
    set reduced_cwd $cwd
  end
  
  # AWS Vault
  if [ -n "$AWS_VAULT" ]
    set -l yellow (set_color -o yellow)
    set vault (echo -n -s '[' $yellow $AWS_VAULT  $normal '] ')
  end

  echo -n -s $vault $prompt_color $reduced_cwd $arrow $normal ' '
end
