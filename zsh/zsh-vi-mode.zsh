# zsh-vi-mode.zsh -- A better and friendly vi(vim) mode for Zsh
# https://github.com/jeffreytse/zsh-vi-mode
#
# Copyright (c) 2020 Jeffrey Tse
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
#
# All Settings
# Some of these variables should be set before sourcing this file.
#
# ZVM_CONFIG_FUNC
# the config function (default is `zvm_config`), if this config function
# exists, it will be called automatically, you can do some configurations
# in this aspect before you source this plugin.
#
# For example:
#
# ```zsh
# function zvm_config() {
#   ZVM_LINE_INIT_MODE=$ZVM_MODE_INSERT
#   ZVM_VI_INSERT_ESCAPE_BINDKEY=jk
# }
#
# source ~/zsh-vi-mode.zsh
# ```
#
# ZVM_INIT_MODE
# the plugin initial mode (default is doing the initialization when the first
# new command line is starting. For doing the initialization instantly, you
# can set it to `sourcing`.
#
# ZVM_VI_ESCAPE_BINDKEY
# the vi escape key for all modes (default is ^[ => <ESC>), you can set it
# to whatever you like, such as `jj`, `jk` and so on.
#
# ZVM_VI_INSERT_ESCAPE_BINDKEY
# the vi escape key of insert mode (default is $ZVM_VI_ESCAPE_BINDKEY), you
# can set it to whatever, such as `jj`, `jk` and so on.
#
# ZVM_VI_VISUAL_ESCAPE_BINDKEY
# the vi escape key of visual mode (default is $ZVM_VI_ESCAPE_BINDKEY), you
# can set it to whatever, such as `jj`, `jk` and so on.
#
# ZVM_VI_OPPEND_ESCAPE_BINDKEY
# the vi escape key of operator pendding mode (default is
# $ZVM_VI_ESCAPE_BINDKEY), you can set it to whatever, such as `jj`, `jk`
# and so on.
#
# ZVM_VI_INSERT_MODE_LEGACY_UNDO:
# using legacy undo behavior in vi insert mode
#
# ZVM_VI_HIGHLIGHT_FOREGROUND:
# the behavior of highlight foreground (surrounds, visual-line, etc) in vi mode
#
# ZVM_VI_HIGHLIGHT_BACKGROUND:
# the behavior of highlight background (surrounds, visual-line, etc) in vi mode
#
# ZVM_VI_HIGHLIGHT_EXTRASTYLE:
# the behavior of highlight extra style (i.e. bold, underline) in vi mode
#
# For example:
#   ZVM_VI_HIGHLIGHT_FOREGROUND=green           # Color name
#   ZVM_VI_HIGHLIGHT_FOREGROUND=#008800         # Hex value
#   ZVM_VI_HIGHLIGHT_BACKGROUND=red             # Color name
#   ZVM_VI_HIGHLIGHT_BACKGROUND=#ff0000         # Hex value
#   ZVM_VI_HIGHLIGHT_EXTRASTYLE=bold,underline  # bold and underline
#
# ZVM_VI_SURROUND_BINDKEY
# the key binding mode for surround operating (default is 'classic')
#
# 1. 'classic' mode (verb->s->surround):
#   S"    Add " for visual selection
#   ys"   Add " for visual selection
#   cs"'  Change " to '
#   ds"   Delete "
#
# 2. 's-prefix' mode (s->verb->surround):
#   sa"   Add " for visual selection
#   sd"   Delete "
#   sr"'  Change " to '
#
# How to select surround text object?
#   vi"   Select the text object inside the quotes
#   va(   Select the text object including the brackets
#
# Then you can do any operation for the selection:
#
# 1. Add surrounds for text object
#   vi" -> S[ or sa[ => "object" -> "[object]"
#
# 2. Delete/Yank/Change text object
#   di( or vi( -> d
#   ca( or va( -> c
#   yi( or vi( -> y
#
# ZVM_READKEY_ENGINE
# the readkey engine for reading and processing the key events, and the
# below engines are supported:
#  ZVM_READKEY_ENGINE_NEX (Default)
#  ZVM_READKEY_ENGINE_ZLE
#
# the NEX is a better engine for reading and handling the key events than
# the Zsh's ZLE engine, currently the NEX engine is at beta stage, and
# you can change to Zsh's ZLE engine if you want.
#
# ZVM_KEYTIMEOUT:
# the key input timeout for waiting for next key (default is 0.4 seconds)
#
# ZVM_ESCAPE_KEYTIMEOUT:
# the key input timeout for waiting for next key if it is beginning with
# an escape character (default is 0.03 seconds), and this option is just
# available for the NEX readkey engine
#
# ZVM_LINE_INIT_MODE
# the setting for init mode of command line (default is empty), empty will
# keep the last command mode, for the first command line it will be insert
# mode, you can also set it to a specific vi mode to alway keep the mode
# for each command line
#
# For example:
#   ZVM_LINE_INIT_MODE=$ZVM_MODE_INSERT
#   ZVM_LINE_INIT_MODE=$ZVM_MODE_NORMAL
#
# ZVM_LAZY_KEYBINDINGS:
# the setting for lazy keybindings (default is true), and lazy keybindings
# will postpone the keybindings of vicmd and visual keymaps to the first
# time entering normal mode
#
# ZVM_NORMAL_MODE_CURSOR:
# the prompt cursor in normal mode
#
# ZVM_INSERT_MODE_CURSOR:
# the prompt cursor in insert mode
#
# ZVM_VISUAL_MODE_CURSOR:
# the prompt cursor in visual mode
#
# ZVM_VISUAL_LINE_MODE_CURSOR:
# the prompt cursor in visual line mode
#
# ZVM_OPPEND_MODE_CURSOR:
# the prompt cursor in operator pending mode
#
# You can change the cursor style by below:
#  ZVM_INSERT_MODE_CURSOR=$ZVM_CURSOR_BLOCK
#
# and the below cursor style are supported:
#  ZVM_CURSOR_USER_DEFAULT
#  ZVM_CURSOR_BLOCK
#  ZVM_CURSOR_UNDERLINE
#  ZVM_CURSOR_BEAM
#  ZVM_CURSOR_BLINKING_BLOCK
#  ZVM_CURSOR_BLINKING_UNDERLINE
#  ZVM_CURSOR_BLINKING_BEAM
#
# ZVM_VI_EDITOR
# the editor to edit your command line (default is $EDITOR)
#
# ZVM_TMPDIR
# the temporary directory (default is $TMPDIR, otherwise it's /tmp)
#
# ZVM_TERM
# the term for handling terminal sequences, it's important for some
# terminal emulators to show cursor properly (default is $TERM)
#
# ZVM_CURSOR_STYLE_ENABLED
# enable the cursor style feature (default is true)
#

# Avoid sourcing plugin multiple times
command -v 'zvm_version' >/dev/null && return

# Plugin information
typeset -gr ZVM_NAME='zsh-vi-mode'
typeset -gr ZVM_DESCRIPTION='💻 A better and friendly vi(vim) mode plugin for ZSH.'
typeset -gr ZVM_REPOSITORY='https://github.com/jeffreytse/zsh-vi-mode'
typeset -gr ZVM_VERSION='0.11.0'

# Plugin initial status
ZVM_INIT_DONE=false

# Postpone reset prompt (i.e. postpone the widget `reset-prompt`)
# -1 (No postponing)
# >=0 (Postponing, the decimal value stands for calling times of `reset-prompt`)
ZVM_POSTPONE_RESET_PROMPT=-1

# Disable reset prompt (i.e. postpone the widget `reset-prompt`)
ZVM_RESET_PROMPT_DISABLED=false

# Operator pending mode
ZVM_OPPEND_MODE=false

# Insert mode could be
# `i` (insert)
# `a` (append)
# `I` (insert at the non-blank beginning of current line)
# `A` (append at the end of current line)
ZVM_INSERT_MODE='i'

# The mode could be the below value:
# `n` (normal)
# `i` (insert)
# `v` (visual)
# `vl` (visual-line)
ZVM_MODE=''

# The keys typed to invoke this widget, as a literal string
ZVM_KEYS=''

# The region hilight information
ZVM_REGION_HIGHLIGHT=()

# Default zvm readkey engines
ZVM_READKEY_ENGINE_NEX='nex'
ZVM_READKEY_ENGINE_ZLE='zle'
ZVM_READKEY_ENGINE_DEFAULT=$ZVM_READKEY_ENGINE_NEX

# Default alternative character for escape characters
ZVM_ESCAPE_SPACE='\s'
ZVM_ESCAPE_NEWLINE='^J'

# Default vi modes
ZVM_MODE_LAST=''
ZVM_MODE_NORMAL='n'
ZVM_MODE_INSERT='i'
ZVM_MODE_VISUAL='v'
ZVM_MODE_VISUAL_LINE='vl'
ZVM_MODE_REPLACE='r'

# Default cursor styles
ZVM_CURSOR_USER_DEFAULT='ud'
ZVM_CURSOR_BLOCK='bl'
ZVM_CURSOR_UNDERLINE='ul'
ZVM_CURSOR_BEAM='be'
ZVM_CURSOR_BLINKING_BLOCK='bbl'
ZVM_CURSOR_BLINKING_UNDERLINE='bul'
ZVM_CURSOR_BLINKING_BEAM='bbe'

# The commands need to be repeated
ZVM_REPEAT_MODE=false
ZVM_REPEAT_RESET=false
ZVM_REPEAT_COMMANDS=($ZVM_MODE_NORMAL i)

##########################################
# Initial all default settings

# Default config function
: ${ZVM_CONFIG_FUNC:='zvm_config'}

# Set the readkey engine (default is NEX engine)
: ${ZVM_READKEY_ENGINE:=$ZVM_READKEY_ENGINE_DEFAULT}

# Set key input timeout (default is 0.4 seconds)
: ${ZVM_KEYTIMEOUT:=0.4}

# Set the escape key timeout (default is 0.03 seconds)
: ${ZVM_ESCAPE_KEYTIMEOUT:=0.03}

# Set keybindings mode (default is true)
# The lazy keybindings will post the keybindings of vicmd and visual
# keymaps to the first time entering the normal mode
: ${ZVM_LAZY_KEYBINDINGS:=true}

# All keybindings for lazy loading
if $ZVM_LAZY_KEYBINDINGS; then
  ZVM_LAZY_KEYBINDINGS_LIST=()
fi

# Set the cursor style in defferent vi modes, the value you could use
# the predefined value, such as $ZVM_CURSOR_BLOCK, $ZVM_CURSOR_BEAM,
# $ZVM_CURSOR_BLINKING_BLOCK and so on.
: ${ZVM_INSERT_MODE_CURSOR:=$ZVM_CURSOR_BEAM}
: ${ZVM_NORMAL_MODE_CURSOR:=$ZVM_CURSOR_BLOCK}
: ${ZVM_VISUAL_MODE_CURSOR:=$ZVM_CURSOR_BLOCK}
: ${ZVM_VISUAL_LINE_MODE_CURSOR:=$ZVM_CURSOR_BLOCK}

# Operator pending mode cursor style (default is underscore)
: ${ZVM_OPPEND_MODE_CURSOR:=$ZVM_CURSOR_UNDERLINE}

# Set the vi escape key (default is ^[ => <ESC>)
: ${ZVM_VI_ESCAPE_BINDKEY:=^[}
: ${ZVM_VI_INSERT_ESCAPE_BINDKEY:=$ZVM_VI_ESCAPE_BINDKEY}
: ${ZVM_VI_VISUAL_ESCAPE_BINDKEY:=$ZVM_VI_ESCAPE_BINDKEY}
: ${ZVM_VI_OPPEND_ESCAPE_BINDKEY:=$ZVM_VI_ESCAPE_BINDKEY}

# Set the line init mode (empty will keep the last mode)
# you can also set it to others, such as $ZVM_MODE_INSERT.
: ${ZVM_LINE_INIT_MODE:=$ZVM_MODE_LAST}

: ${ZVM_VI_INSERT_MODE_LEGACY_UNDO:=false}
: ${ZVM_VI_SURROUND_BINDKEY:=classic}
: ${ZVM_VI_HIGHLIGHT_BACKGROUND:=#cc0000}
: ${ZVM_VI_HIGHLIGHT_FOREGROUND:=#eeeeee}
: ${ZVM_VI_HIGHLIGHT_EXTRASTYLE:=default}
: ${ZVM_VI_EDITOR:=${EDITOR:-vim}}
: ${ZVM_TMPDIR:=${TMPDIR:-/tmp}}

# Set the term for handling terminal sequences, it's important for some
# terminal emulators to show cursor properly (default is $TERM)
: ${ZVM_TERM:=${TERM:-xterm-256color}}

# Enable the cursor style feature
: ${ZVM_CURSOR_STYLE_ENABLED:=true}

# All the extra commands
commands_array_names=(
  zvm_before_init_commands
  zvm_after_init_commands
  zvm_before_select_vi_mode_commands
  zvm_after_select_vi_mode_commands
  zvm_before_lazy_keybindings_commands
  zvm_after_lazy_keybindings_commands
)
for commands_array_name in $commands_array_names; do
  # Ensure commands set to an empty array, if not already set.
  if [[ -z "${(P)commands_array_name}" ]]; then
    typeset -g -a $commands_array_name
  fi
done

# All the handlers for switching keyword
zvm_switch_keyword_handlers=(
  zvm_switch_number
  zvm_switch_boolean
  zvm_switch_operator
  zvm_switch_weekday
  zvm_switch_month
)

# History for switching keyword
zvm_switch_keyword_history=()

# Display version information
function zvm_version() {
  local git_info=$(git show -s --format="(%h, %ci)" 2>/dev/null)
  echo -e "$ZVM_NAME $ZVM_VERSION $git_info"
  echo -e "\e[4m$ZVM_REPOSITORY\e[0m"
  echo -e "$ZVM_DESCRIPTION"
}

# The widget wrapper
function zvm_widget_wrapper() {
  local rawfunc=$1;
  local func=$2;
  local called=$3;
  local -i retval
  $called || { $rawfunc "${@:4}" }
  $func "${@:4}"
  return retval
}

# Define widget function
function zvm_define_widget() {
  local widget=$1
  local func=$2 || $1
  local result=($(zle -l -L "${widget}"))

  # Check if existing the same name
  if [[ ${#result[@]} == 4 ]]; then
    local rawfunc=${result[4]}
    local wrapper="zvm_${widget}-wrapper"

    # To avoid double calling, we need to check if the raw function
    # has been called already in the custom widget function
    local rawcode=$(declare -f $func 2>/dev/null)
    local called=false
    [[ "$rawcode" == *"\$rawfunc"* ]] && { called=true }

    eval "$wrapper() { zvm_widget_wrapper $rawfunc $func $called \"\$@\" }"
    func=$wrapper
  fi

  zle -N $widget $func
}

# Get the keys typed to invoke this widget, as a literal string
function zvm_keys() {
  local keys=${ZVM_KEYS:-$KEYS}

  # Append the prefix of keys if it is visual or visual-line mode
  case "${ZVM_MODE}" in
    $ZVM_MODE_VISUAL)
      if [[ "$keys" != v* ]]; then
        keys="v${keys}"
      fi
      ;;
    $ZVM_MODE_VISUAL_LINE)
      if [[ "$keys" != V* ]]; then
        keys="V${keys}"
      fi
      ;;
  esac

  # Escape the newline and space characters, otherwise, we can't
  # get the output from subshell correctly.
  keys=${keys//$'\n'/$ZVM_ESCAPE_NEWLINE}
  keys=${keys// /$ZVM_ESCAPE_SPACE}

  echo $keys
}

# Find the widget on a specified bindkey
function zvm_find_bindkey_widget() {
  local keymap=$1
  local keys=$2
  local prefix_mode=${3:-false}
  retval=()

  if $prefix_mode; then
    local pos=0
    local spos=3
    local prefix_keys=

    # Get the prefix keys
    if [[ $prefix_keys ]]; then
      prefix_keys=${prefix_keys:0:-1}

      # If the last key is an escape key (e.g. \", \`, \\) we still
      # need to remove the escape backslash `\`
      if [[ ${prefix_keys: -1} == '\' ]]; then
        prefix_keys=${prefix_keys:0:-1}
      fi
    fi

    local result=$(bindkey -M ${keymap} -p "$prefix_keys")$'\n'

    # Split string to array by newline
    for ((i=$spos;i<$#result;i++)); do

      # Save the last whitespace character of the line
      # and continue continue handling while meeting `\n`
      case "${result:$i:1}" in
        ' ') spos=$i; i=$i+1; continue;;
        [$'\n']);;
        *) continue;;
      esac

      # Check if it has the same prefix keys and retrieve the widgets
      if [[ "${result:$((pos+1)):$#keys}" == "$keys" ]]; then

        # Get the binding keys
        local k=${result:$((pos+1)):$((spos-pos-2))}

        # Escape spaces in key bindings (space -> $ZVM_ESCAPE_SPACE)
        k=${k// /$ZVM_ESCAPE_SPACE}
        retval+=($k ${result:$((spos+1)):$((i-spos-1))})
      fi

      # Save as new position
      pos=$i+1

      # Skip 3 characters
      # One key and quotes at least (i.e \n"_" )
      i=$i+3
    done
  else
    local result=$(bindkey -M ${keymap} "$keys")
    if [[ "${result: -14}" == ' undefined-key' ]]; then
      return
    fi

    # Escape spaces in key bindings (space -> $ZVM_ESCAPE_SPACE)
    for ((i=$#result;i>=0;i--)); do

      # Backward find the first whitespace character
      [[ "${result:$i:1}" == ' ' ]] || continue

      # Retrieve the keys and widget
      local k=${result:1:$i-2}

      # Escape spaces in key bindings (space -> $ZVM_ESCAPE_SPACE)
      k=${k// /$ZVM_ESCAPE_SPACE}
      retval+=($k ${result:$i+1})

      break
    done
  fi
}

# Read keys for retrieving widget
function zvm_readkeys() {
  local keymap=$1
  local key=${2:-$(zvm_keys)}
  local keys=
  local widget=
  local result=
  local pattern=
  local timeout=

  while :; do
    # Keep reading key for escape character
    if [[ "$key" == $'\e' ]]; then
      while :; do
        local k=
        read -t $ZVM_ESCAPE_KEYTIMEOUT -k 1 k || break
        key="${key}${k}"
      done
    fi

    keys="${keys}${key}"

    # Handle the pattern
    if [[ -n "$key" ]]; then
      # Transform the non-printed characters
      local k=$(zvm_escape_non_printed_characters "${key}")

      # Escape keys
      # " -> \" It's a special character in bash syntax
      # ` -> \` It's a special character in bash syntax
      # <space> -> ` ` It's a special character in bash syntax
      k=${k//\"/\\\"}
      k=${k//\`/\\\`}
      k=${k//$ZVM_ESCAPE_SPACE/ }

      pattern="${pattern}${k}"
    fi

    # Find out widgets that match this key pattern
    zvm_find_bindkey_widget $keymap "$pattern" true
    result=(${retval[@]})

    # Exit key input if there is only one widget matched
    # or no more widget matched.
    case ${#result[@]} in
      2) key=; widget=${result[2]}; break;;
      0) break;;
    esac

    # Evaluate the readkey timeout
    # Special timeout for the escape sequence
    if [[ "${keys}" == $'\e' ]]; then
      timeout=$ZVM_ESCAPE_KEYTIMEOUT
      # Check if there is any one custom escape sequence
      for ((i=1; i<=${#result[@]}; i=i+2)); do
        if [[ "${result[$i]}" =~ '^\^\[\[?[A-Z0-9]*~?\^\[' ]]; then
          timeout=$ZVM_KEYTIMEOUT
          break
        fi
      done
    else
      timeout=$ZVM_KEYTIMEOUT
    fi

    # Wait for reading next key, and we should save the widget
    # as the final widget if it is full matching
    key=
    if [[ "${result[1]}" == "${pattern}" ]]; then
      widget=${result[2]}
      # Get current widget as final widget when reading key timeout
      read -t $timeout -k 1 key || break
    else
      zvm_enter_oppend_mode
      read -k 1 key
    fi
  done

  # Exit operator pending mode
  if $ZVM_OPPEND_MODE; then
    zvm_exit_oppend_mode
  fi

  if [[ -z "$key" ]]; then
    retval=(${keys} $widget)
  else
    retval=(${keys:0:-$#key} $widget $key)
  fi
}

# Add key bindings
function zvm_bindkey() {
  local keymap=$1
  local keys=$2
  local widget=$3
  local params=$4
  local key=

  # We should bind keys with an existing widget
  [[ -z $widget ]] && return

  # If lazy keybindings is enabled, we need to add to the lazy list
  if [[ ${ZVM_LAZY_KEYBINDINGS_LIST+x} && ${keymap} != viins ]]; then
    keys=${keys//\"/\\\"}
    keys=${keys//\`/\\\`}
    ZVM_LAZY_KEYBINDINGS_LIST+=(
      "${keymap} \"${keys}\" ${widget} \"${params}\""
    )
    return
  fi

  # Hanle the keybinding of NEX readkey engine
  if [[ $ZVM_READKEY_ENGINE == $ZVM_READKEY_ENGINE_NEX ]]; then
    # Get the first key (especially check if ctrl characters)
    if [[ $#keys -gt 1 && "${keys:0:1}" == '^' ]]; then
      key=${keys:0:2}
    else
      key=${keys:0:1}

      # As any character that is not bound to one of the history control
      # related functions, or self-insert or self-insert-unmeta, will
      # cause the mode to be exited To prevent history search, so that
      # we need to bind keys explicitly.
      if [[ "$keymap" == "viins" ]]; then
        bindkey -M isearch "${key}" self-insert
      fi
    fi
    bindkey -M $keymap "${key}" zvm_readkeys_handler
  fi

  # Wrap params to a new widget
  if [[ -n $params ]]; then
    local suffix=$(zvm_string_to_hex $params)
    eval "$widget:$suffix() { $widget $params }"
    widget="$widget:$suffix"
    zvm_define_widget $widget
  fi

  # Bind keys with with a widget
  bindkey -M $keymap "${keys}" $widget
}

# Convert string to hexadecimal
function zvm_string_to_hex() {
  local str=
  for ((i=1;i<=$#1;i++)); do
    str+=$(printf '%x' "'${1[$i]}")
  done
  echo "$str"
}

# Escape non-printed characters
function zvm_escape_non_printed_characters() {
  local str=
  for ((i=0;i<$#1;i++)); do
    local c=${1:$i:1}
    if [[ "$c" < ' ' ]]; then
      local ord=$(($(printf '%d' "'$c")+64))
      c=$(printf \\$(printf '%03o' $ord))
      str="${str}^${c}"
    elif [[ "$c" == '' ]]; then
      str="${str}^?"
    elif [[ "$c" == '
