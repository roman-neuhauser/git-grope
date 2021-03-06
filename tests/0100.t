happy path
==========

setup
*****

::

  $ . $TESTDIR/setup

  $ init-repo checkout
  $ cd checkout

test
****

::

  $ grope natural **/*(.)
  13 pg/pg14522.txt
   5 pg/pg31469.txt
   1 pg/pg42704.txt

  $ grope program **/*(.)
  19 ewd/ewd264.rst
  19 ewd/ewd215.rst
   9 ewd/ewd251.rst

  $ grope -F programmer **/*(.)
  5 ewd/ewd215.rst
  3 ewd/ewd251.rst

  $ grope -P programming **/*(.)
  3 ewd/ewd251.rst
  1 ewd/ewd264.rst
  1 ewd/ewd215.rst

  $ grope -E programm'(er|ing)' **/*(.)
  6 ewd/ewd251.rst
  6 ewd/ewd215.rst
  1 ewd/ewd264.rst
