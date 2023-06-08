<?php


#_main_::query(null, "truncate table pays");
#_main_::query(null, "truncate table payment");

$lines = file('types.csv');
$parts = [];

$dict = _main_::fetchModule('dictionaries');

#array_shift($lines);
$total = 0;

foreach($lines as $l)
{
	$ar = str_getcsv($l, ';');
	
	if (!$ar[0]) continue;
	
	$model = $ar[0];
	$type = $ar[1];
	
	$dat = _main_::query(null, "select id from model_types where `name` = {1}", $type);

	if (!$dat)		
	{
		/*
		$id = _main_::query(null, "insert into model_types
				set	`name`	= {1}
			"
			,	$type
			);
		*/
		debug($model.$type);
		die("Error");

	}
	else
	{
		$id = array_shift($dat)['id'];
	}
	
	/*
	_main_::query(null, "update models
		set	`type`	= {2}
		where `name`= {1}
	"
	,	$model
	,	$id
	);
	*/
	$dat = _main_::query(null, "select id from models where `name` = {1}", $model);
	
	if (!$dat)		
	{
		$dat = _main_::query(null, "select name from models where `id` = 1");
		$name = array_shift($dat)['name'];
		if ($model == $name) debug("OK");
		
		else debug("error");
		debug(strlen($model)." ".strlen($name)." ".strlen("Охотник 650"));
		die("Error");

	}
	else
	{
		$mid = array_shift($dat)['id'];
	}
	
	echo "$model $type $mid $id <br>\n";

	
	$total++;
}

debug($total);
die("OK");

?>