cgi: htmlized filenames
=======================

setup
*****

::

  $ SCRIPT=$TESTDIR:h/grope.cgi

  $ . $TESTDIR/setup

  $ init-repo checkout

  $ export GIT_GROPE_CONFIG=$PWD/${TESTFILE:r}.config
  $ export PATH_INFO=/$TESTFILE/
  $ export QUERY_STRING='syn=fix&q=inconcievable'

  $ cat > $GIT_GROPE_CONFIG <<EOF
  > section $TESTFILE
  >   GIT_WORK_TREE   \$PWD/checkout
  >   GIT_DIR         \$PWD/checkout/.git
  >   gropetool       git-grope
  >   syntax          bre
  >   url_prefix      /elsewhere/
  > EOF

test
****

::

  $ $SHELL $SCRIPT
  Content-Type: text/html; charset="utf-8"
  
    <!DOCTYPE html>
    <html>
    <head>
     <title>fubar</title>
     <script>
  
     </script>
    </head>
    <body>
  
     <form>
      <label>-E<input type="radio" name="syn" value="ere" /></label>
      <label>-F<input type="radio" name="syn" value="fix" checked/></label>
      <label>-G<input type="radio" name="syn" value="bre" /></label>
      <label>-P<input type="radio" name="syn" value="pre" /></label>
      <input type="string" class="q" name="q" value="inconcievable" />
      <input type="submit" id="go" name="go" value="search" />
     </form>
  
     <p>query: inconcievable</p>
  
     <p>
     results:
  
     <ol>
  <li>1 hits in <a href="/elsewhere/torture/lt-star-gt.&#0060;*&#0062;">torture/lt-star-gt.&#0060;*&#0062;</a></li>
     </ol>
     </p>
  
    </body>
    </html>

