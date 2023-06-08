<?php

_main_::depend('configs');
_main_::depend('merges');
_main_::depend('subscribers//reads');


select_subscribers_where_active ($dat);

if ($dat) 
{
	foreach($dat as $v) $str .= $v['email'].";";
	$str = substr($str,0,-1);
}

header ("Content-Type: text/x-csv");
header('Content-Disposition: inline; filename="emails.csv"');
header('Expires: 0');
header('Cache-Control: must-revalidate, post-check=0, pre-check=0');
header('Pragma: public');
echo $str;
throw new exception_exit();
?>