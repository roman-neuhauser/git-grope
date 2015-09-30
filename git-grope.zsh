#!/usr/bin/env zsh
# vim: ts=2 sts=2 sw=2 et fdm=marker cms=\ #\ %s

set -eu

_SELF=${${0:t}/#git-/git }

function list-files # {{{
{
  local -a reply
  reply=($(git ls-files))
  : ${(AP)1::=$reply}
} # }}}

git rev-parse --is-inside-work-tree >/dev/null || exit 4
cd ${GIT_WORK_TREE:-.}

usage() # {{{
{
  local self="$_SELF" exit=${1?} fd=1
  shift
  test $exit -ne 0 && fd=2
  {
    if (( exit == 1 )); then
      print -f "%s: option -%c requires an argument\n" "$self" "$1"
    elif (( exit == 2 )); then
      print -f "%s: unknown option -%c\n" "$self" "$1"
    elif (( exit == 3 )); then
      print -f "%s: no PATTERNs specified\n" "$self"
    fi
    print -f "%s: Usage: %s {-h|[options] PATTERN [FILE]...}\n" "$self" "$self"
    if (( exit != 0 )); then
      print -f "%s: Use \"%s -h\" to see the full option listing.\n" "$self" "$self"
    else
      print -f "  Options:\n"
      print -f "    %-16s  %s\n" -- \
        "-h"              "Display this message" \
        "-E"              "Interpret PATTERNs as extended regular expressions (ERE)" \
        "-F"              "Interpret PATTERNs as a fixed strings" \
        "-G"              "Interpret PATTERNs as basic regular expressions (ERE)" \
        "-P"              "Interpret PATTERNs as Perl regular expressions (PCRE)" \
        "-e PATTERN"      "Use PATTERN for matching" \

    fi
  } >&$fd
  if (( exit == 0 )); then
    exit 0
  else
    exit 1
  fi
} # }}}

declare -a terms
declare -a grep

while getopts :EFGPe:h optname; do
  case $optname in
  E|F|G|P) grep+=(-$optname) ;;
  I|i|w) grep+=(-$optname) ;;
  e) terms+=($OPTARG) ;;
  h) usage 0 ;;
  :) usage 1 $OPTARG ;;
  ?) usage 2 $OPTARG ;;
  esac
done; shift $((OPTIND - 1))

if (( $# && !${#terms} )); then
  terms=($1)
  shift
fi

if (( !${#terms} )); then
  usage 3
fi

declare -a files

if (( $# )); then
  files=("$@")
else
  list-files files
fi

declare -i cnt=0 max=0
declare file term
declare -a hits

for file in $files; do
  for term in $terms; do
    grep $grep -oe $term ./$file
  done | wc -l | read cnt
  if (( cnt > max )); then
    max=$cnt
  fi
  if (( cnt > 0 )); then
    hits+=($cnt $file)
  fi
done

declare -i cwidth=${#max}

for cnt file in $hits; do
  print -f "%*d %s\n" $cwidth $cnt $file
done | sort -rn

