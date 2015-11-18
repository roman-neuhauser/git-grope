cgi: display search form
========================

setup
*****

::

  $ . $TESTDIR/setup
  $ SCRIPT=$TESTDIR:h/grope.cgi

  $ export GROPE_CONFIG=$PWD/${TESTFILE:r}.config
  $ export PATH_INFO=/$TESTFILE/

  $ cat > $GROPE_CONFIG <<EOF
  > # first, 0-column comment
  > section $TESTFILE
  >   # second, indented comment
  >   gropetool       grope
  >   syntax          bre
  >   worktree        \$PWD
  >   # another indented comment
  > # last, 0-column comment
  > EOF

test
****

::

  $ $SHELL $SCRIPT | head -3
  Content-Type: text/html; charset="utf-8"
  
    <!DOCTYPE html>
