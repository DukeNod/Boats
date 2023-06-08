<?php


#_main_::query(null, "truncate table pays");
#_main_::query(null, "truncate table payment");

$lines = file('regions.csv');
$parts = [];

$dict = _main_::fetchModule('dictionaries');

#array_shift($lines);
$total = 0;

foreach($lines as $l)
{
	$ar = str_getcsv($l, ';');
	
	if (!$ar[0]) continue;
	
	$region = $ar[0];
	
	$dat = _main_::query(null, "select id from regions where name = {1}", $region);

	if (!$dat)
	{
		$id = _main_::query(null, "insert into regions
				set	`name`	= {1}
			"
			,	$region
			);
	
		$total++;
	}
}

debug($total);
die("OK");

?>