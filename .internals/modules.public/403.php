<?php
_main_::depend('_specific_/fetches');
fetch_every_page_content();

header("HTTP/1.0 403 Forbidden");
_main_::put2dom('unknown');

?>
