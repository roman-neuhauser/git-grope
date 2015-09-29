cgi: display search results
===========================

setup
*****

::

  $ SCRIPT=$TESTDIR:h/git-grope.cgi

  $ . $TESTDIR/setup

  $ init-repo checkout

  $ export GIT_GROPE_CONFIG=$PWD/${TESTFILE:r}.config
  $ export PATH_INFO=/$TESTFILE/
  $ export QUERY_STRING='syn=bre&q=natural%20language'

  $ cat > $GIT_GROPE_CONFIG <<EOF
  > section $TESTFILE
  >   GIT_WORK_TREE   \$PWD/checkout
  >   GIT_DIR         \$PWD/checkout/.git
  >   gropetool       git-grope
  >   syntax          bre
  >   url_prefix      /file/
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
      <label>-F<input type="radio" name="syn" value="fix" /></label>
      <label>-G<input type="radio" name="syn" value="bre" checked/></label>
      <label>-P<input type="radio" name="syn" value="pre" /></label>
      <input type="string" class="q" name="q" value="natural language" />
      <input type="submit" id="go" name="go" value="search" />
     </form>
  
     <p>query: natural language</p>
  
     <p>
     results:
  
     <ol>
  <li>14 hits in <a href="/file/pg/pg14522.txt">pg/pg14522.txt</a></li>
  <li>8 hits in <a href="/file/pg/pg31469.txt">pg/pg31469.txt</a></li>
  <li>3 hits in <a href="/file/pg/pg42704.txt">pg/pg42704.txt</a></li>
     </ol>
     </p>
  
    </body>
    </html>
