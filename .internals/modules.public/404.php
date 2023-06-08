<?php
#_main_::depend('_specific_/fetches');
//fetch_every_page_content();

header("HTTP/1.0 404 Not Found");

throw new exception_exit();

_main_::put2dom('unknown');

#$p = _main_::fetchModule('pages');
#$p->fetch_page(array('404'));

?>
