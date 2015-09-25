out-of-worktree operation
=========================

setup
*****

::

  $ . $TESTDIR/setup

  $ init-repo checkout
  $ export GIT_WORK_TREE=$PWD/checkout
  $ export GIT_DIR=$PWD/checkout/.git

test
****

::

  $ git grope natural
  13 pg/pg14522.txt
   5 pg/pg31469.txt
   1 pg/pg42704.txt

  $ git grope program
  19 ewd/ewd264.rst
  19 ewd/ewd215.rst
   9 ewd/ewd251.rst

  $ git grope -F programmer
  5 ewd/ewd215.rst
  3 ewd/ewd251.rst

  $ git grope -P programming
  3 ewd/ewd251.rst
  1 ewd/ewd264.rst
  1 ewd/ewd215.rst

  $ git grope -E programm'(er|ing)'
  6 ewd/ewd251.rst
  6 ewd/ewd215.rst
  1 ewd/ewd264.rst
