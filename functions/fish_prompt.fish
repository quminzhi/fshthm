set __fshthm_color_red AF0000
set __fshthm_color_orange FD971F
set __fshthm_color_blue 6EC9DD
set __fshthm_color_green A6E22E
set __fshthm_color_yellow E6DB7E
set __fshthm_color_pink F92672
set __fshthm_color_grey 554F48
set __fshthm_color_light_grey BCBCBC
set __fshthm_color_white F1F1F1
set __fshthm_color_purple AF5FFF
set __fshthm_color_lilac AE81FF

function __fshthm_color_echo
  set_color $argv[1]
  if test (count $argv) -eq 2
    echo -n $argv[2]
  end
end

function __fshthm_prompt_hostname
  set -l host (hostname -s)
  set -l user (whoami)

  if [ "$user" = "root" ]
    __fshthm_color_echo $__fshthm_color_red $user
	  __fshthm_color_echo $__fshthm_color_purple '@'$host' '
  else
    __fshthm_color_echo $__fshthm_color_blue ' '$user
	  __fshthm_color_echo $__fshthm_color_orange ' [@'$host'] '
  end
end

function __fshthm_git_status_codes
  echo (git status --porcelain 2> /dev/null | sed -E 's/(^.{3}).*/\1/' | tr -d ' \n')
end

function __fshthm_git_branch_name
  echo (git rev-parse --abbrev-ref HEAD 2> /dev/null)
end

function __fshthm_rainbow
  if echo $argv[1] | grep -q -e $argv[3]
    __fshthm_color_echo $argv[2] "彡ミ"
  end
end

function __fshthm_git_status_icons
  set -l git_status (__fshthm_git_status_codes)

  __fshthm_rainbow $git_status $__fshthm_color_pink 'D'
  __fshthm_rainbow $git_status $__fshthm_color_orange 'R'
  __fshthm_rainbow $git_status $__fshthm_color_white 'C'
  __fshthm_rainbow $git_status $__fshthm_color_green 'A'
  __fshthm_rainbow $git_status $__fshthm_color_blue 'U'
  __fshthm_rainbow $git_status $__fshthm_color_lilac 'M'
  __fshthm_rainbow $git_status $__fshthm_color_grey '?'
end

function __fshthm_git_status
  # In git
  if test -n (__fshthm_git_branch_name)

    __fshthm_color_echo $__fshthm_color_blue " git"
    __fshthm_color_echo $__fshthm_color_white ":"(__fshthm_git_branch_name)

    if test -n (__fshthm_git_status_codes)
      __fshthm_color_echo $__fshthm_color_pink ' ●'
      __fshthm_color_echo $__fshthm_color_white ' [^._.^]ﾉ'
      __fshthm_git_status_icons
    else
      __fshthm_color_echo $__fshthm_color_green ' ○'
    end
  end
end

function fish_prompt
  __fshthm_color_echo $__fshthm_color_blue "(◕‿◕)➜"
  __fshthm_prompt_hostname
  __fshthm_color_echo $__fshthm_color_light_grey (prompt_pwd)
  __fshthm_git_status
  echo

  set -l uid (id -u $USER)
  if test $uid -eq '0'
    __fshthm_color_echo $__fshthm_color_yellow "❯ "
  else
  	__fshthm_color_echo $__fshthm_color_blue "❯" 
    __fshthm_color_echo $__fshthm_color_yellow "❯"
    __fshthm_color_echo $__fshthm_color_light_grey "❯ "
  end
end
