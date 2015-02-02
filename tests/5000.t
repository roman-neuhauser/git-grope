cgi: display search form
========================

setup
*****

::

  $ . $TESTDIR/setup
  $ SCRIPT=$TESTDIR:h/git-grope.cgi

  $ export GIT_GROPE_CONFIG=$PWD/${TESTFILE:r}.config
  $ export PATH_INFO=/$TESTFILE/

  $ cat > $GIT_GROPE_CONFIG <<EOF
  > section $TESTFILE
  >   GIT_WORK_TREE   \$PWD
  >   GIT_DIR         \$PWD/.git
  >   syntax          bre
  > EOF

test
****

::

  $ $SHELL $SCRIPT | head -3
  Content-Type: text/html; charset="utf-8"
  
    <!DOCTYPE html>
