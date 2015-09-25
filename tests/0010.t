usage instructions
==================

setup
*****

::

  $ . $TESTDIR/setup

test
****

  $ grope -h
  grope: Usage: grope {-h|[options] PATTERN [FILE]...}
    Options:
      -h                Display this message
      -E                Interpret PATTERNs as extended regular expressions (ERE)
      -F                Interpret PATTERNs as a fixed strings
      -G                Interpret PATTERNs as basic regular expressions (ERE)
      -P                Interpret PATTERNs as Perl regular expressions (PCRE)
      -e PATTERN        Use PATTERN for matching
