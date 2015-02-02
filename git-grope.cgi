#!/usr/bin/env zsh
# vim: ts=2 sts=2 sw=2 et fdm=marker cms=\ #\ %s

# this is web interface to git-grope
# it reads its configuration from the GIT_GROPE_CONFIG env var
# which defaults to "$PWD/git-grope.config".
#
# git-grope.cgi can be used for multiple Git repositories,
# each needs to have a section in the config file.  $PATH_INFO
# is used to lookup the appropriate section in the config file.
#
# further reading: example-git-grope.config.

setopt extended_glob

declare cfgfile=${GIT_GROPE_CONFIG-$PWD/git-grope.config}
declare gropetool='git-grope'
declare syntax=fix
declare url_prefix=
declare heap=${${${PATH_INFO#/}%/}:-default}
declare query=

declare -a terms
declare -A checked

function load-config # {{{
# populate $GIT_GROPE_CFG w/ $wanted section data from $cfgfile
#
# config file is a sequence of statements;
# a statement spans an /^\S/ line possibly followed
# by a run of /^\s+/ lines;
# empty lines are ignored, even within statements;
# comments start with '#';
# usual shell lexing rules apply
{
  local wanted=$1 cfgfile=$2
  local default= stmt=
  local -a sections

  # iterate lines of $cfgfile, ignoring empty lines;
  # a statement is complete as soon we have a new one,
  # the last statement of the $cfgfile is handled by
  # the synthetic __EOF__ line
  # FIXME: splitting the string into an array on newlines
  # not-followed-by horizontal ws would let me do w/o
  # the statefulness or __EOF__
  local line
  for line in "${(@f):-$(cat $cfgfile)}" __EOF__; do
    case $line in
    '') # ignored
    ;;
    [[:space:]]*)
      stmt+=$line
    ;;
    *)
      if [[ -n $stmt ]]; then
        local -a w; w=("${(Z:C:)stmt}")
        case $w[1] in
        default) default=$w[2] ;;
        section)
          sections+=($w[2])
          local name=GIT_GROPE_SETTINGS_${${w[2]}//[^[:IDENT:]]/_}
          declare -Ag $name
          : "${(AAP)name::=${(@)w}}"
        ;;
        esac
      fi
      stmt=$line
    ;;
    esac
  done

  case $wanted in
  default) wanted=$default ;;
  *) wanted=$wanted ;;
  esac

  if [[ ${sections[(i)$wanted]} -gt $#sections ]]; then
    print -f 'requested configuration (%s) not found in %s\n' \
      -- $wanted $cfgfile
    return 1
  fi >&2

  local name=GIT_GROPE_SETTINGS_${wanted//[^[:IDENT:]]/_}
  declare -Ag GIT_GROPE_CFG; GIT_GROPE_CFG=(${(Pkv)name})
} # }}}

function set-config-vars # {{{
{
  local n
  for n in GIT_WORK_TREE GIT_DIR gropetool syntax url_prefix; do
    if (( ${+GIT_GROPE_CFG[$n]} )); then
      : ${(P)n::=$GIT_GROPE_CFG[$n]}
      [[ $n == GIT_* ]] && export $n
    fi
  done
} # }}}

function handle-user-inputs # {{{
{
  for kv in ${(s:&:)QUERY_STRING}; do
    case $kv in
    q=*)
      # decode application/x-www-form-urlencoded data
      local v=
      v=${kv#q=}
      v=${v//+/ }
      # decode '"%" HEXDIG HEXDIG'-encoded octets
      setopt local_options c_bases nomultibyte
      v=${v//(#b)%(??)/${(#):-0x$match[1]}}
      terms+=($=v)
      ;;
    syn=(bre|ere|fix|pre))
      syntax=${kv#*=}
      ;;
    esac
  done
  checked=($syntax checked)
} # }}}

load-config $heap $cfgfile || exit 1

set-config-vars

handle-user-inputs

declare -A to_html; to_html=(
  '"' '&#0034;'
  "'" '&#0039;'
  '<' '&#0060;'
  '>' '&#0062;'
)

# html-safe
declare -a htmlterms; htmlterms=(${terms//(#b)(${(k~j:|:)to_html})/$to_html[$match[1]]})

# output {{{
print -f 'Content-Type: text/html; charset="utf-8"\r\n\r\n'

cat <<HTML
  <!DOCTYPE html>
  <html>
  <head>
   <title>fubar</title>
   <script>

   </script>
  </head>
  <body>

   <form>
    <label>-E<input type="radio" name="syn" value="ere" ${checked[ere]}/></label>
    <label>-F<input type="radio" name="syn" value="fix" ${checked[fix]}/></label>
    <label>-G<input type="radio" name="syn" value="bre" ${checked[bre]}/></label>
    <label>-P<input type="radio" name="syn" value="pre" ${checked[pre]}/></label>
    <input type="string" class="q" name="q" value="$htmlterms" />
    <input type="submit" id="go" name="go" value="search" />
   </form>

   <p>query: ${htmlterms}</p>

   <p>
   results:

   <ol>
$(
  (( $#terms )) || exit
  $gropetool "${(@)terms}" | while read cnt file; do
    # html-safe
    file=${file//${(k~j:|:)to_html}/$to_html[$match[1]]}
    print -f '<li>%d hits in <a href="%s%s">%s</a></li>\n' \
      $cnt $url_prefix $file ${file/%.rest/.html}
  done
)
   </ol>
   </p>

   KTHXBYE!
  </body>
  </html>
HTML
# }}}
