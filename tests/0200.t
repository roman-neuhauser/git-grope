patterns passed with -e
=======================

setup
*****

::

  $ . $TESTDIR/setup

  $ init-repo checkout
  $ cd checkout

test
****

::

  $ git grope -e natural
  13 pg/pg14522.txt
   5 pg/pg31469.txt
   1 pg/pg42704.txt

  $ git grope -e program
  19 ewd/ewd264.rst
  19 ewd/ewd215.rst
   9 ewd/ewd251.rst

  $ git grope -Fe programmer
  5 ewd/ewd215.rst
  3 ewd/ewd251.rst

  $ git grope -Pe programming
  3 ewd/ewd251.rst
  1 ewd/ewd264.rst
  1 ewd/ewd215.rst

  $ git grope -Ee programm'(er|ing)'
  6 ewd/ewd251.rst
  6 ewd/ewd215.rst
  1 ewd/ewd264.rst

  $ git grope -Fe natural -e language
  14 pg/pg14522.txt
   8 pg/pg31469.txt
   3 pg/pg42704.txt
