<?php


_main_::query(null, "truncate table daily");

$lines = file('daily.csv');
$parts = [];

$dict = _main_::fetchModule('dictionaries');

array_shift($lines);
array_shift($lines);
$total = 0;

$branches = [ 1, 2, 3, 4, 5 ];
$fields = [ 'visit', 'calls', 'sites', 'lids', 'sales', 'summ', 'rub', 'usd' ];

foreach($lines as $l)
{
	$ar = str_getcsv($l, ',');

	$date = date('Y-m-d', strtotime($ar[0]));
	
	foreach($branches as $b)
	{
		$empty = true;
		$start = 1 + 8*$b;
		$end = 8 + 8*$b;
		$where_add = '';

		$f_count = 0;		
		for($i = $start; $i <= $end; $i++)
		{
			if ($ar[$i]) $empty = false;
			$where_add .= ", `{$fields[$f_count]}` = "._main_::sql_quote($ar[$i]);
			$f_count++;		
		}
	
		if ($empty) continue;
		
		_main_::query(null, "insert into daily
			set	`date` = {1}
			,	`branch` = {2}
			{$where_add}
		"
		, $date
		, $b
		);
	}
}

debug($total);
die("OK");

?>