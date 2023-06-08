<?php

set_time_limit(0);
$path=realpath("../../");
/*
echo "<pre>";
passthru("~/svn/bin/svn update $path");
echo "</pre>";
die;
*/
exec("/usr/local/bin/svn update $path", $output, $retval);

if ($output) foreach($output as $f=>$v) { $file_list['out:'.$f] = $v; }

_main_::put2dom('file_list', $file_list);
_main_::put2dom('retval', $retval);

?>