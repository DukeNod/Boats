<?php

//set_time_limit(0);
$path='../../'; // $_SERVER['DOCUMENT_ROOT']."/eurosharm_dev";

ob_start();
echo "<pre>";
passthru("~/svn/bin/svn -v log $path");
echo "</pre>";
$buffers = ob_get_contents(); ob_clean();

$output = preg_replace("/\?\\\\(\d+)/","&#$1;", $buffers);
$output = html_entity_decode($output,ENT_NOQUOTES,"cp1252");
echo $output;
/*
exec("~/svn/bin/svn -v log $path", $output, $retval);

#if ($output) foreach($output as $f=>$v) { $file_list['out:'.$f] = $v; }

$buffers = join('<br/>', $output);
echo iconv('CP1251', 'UTF-8', $buffers);
*/
die;
?>