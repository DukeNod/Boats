<?php


$lines = file('1.csv');
$parts = [];

$dict = _main_::fetchModule('dictionaries');

array_shift($lines);
$total = 0;

foreach($lines as $l)
{
	$ar = str_getcsv($l, ',');
	
	if (!$ar[1]) continue;
	
	if ($ar[0])
	{
		#$phone = str_replace('-', ' ', str_replace(')', '', str_replace('(', '', str_replace('"', '', str_replace('+7 ', '', $ar[0])))));
		$phone = trim(preg_replace('/[^\d\s]/', '', str_replace('-', ' ', str_replace('+7 ', '', $ar[0]))));
	}else $phone = null;
	
	if ($ar[3])
	{
		$cdate = date('Y-m-d', strtotime($ar[3]));
	}
	else $cdate = null;
	
	if ($ar[7])
	{
		$type = ($ar[7] == 'новый') ? 'новый' : (($ar[7] == 'бу') ? 'б/у' : null);
	}
	else $type = null;
	
	if ($ar[9])
	{
		$avail = ($ar[9] == 'В наличии') ? 'yes' : (($ar[9] == 'Под заказ') ? 'no' : null);
	}
	else $avail = null;
	
	if ($ar[10])
	{
		$slugebka = ($ar[10] == 'Отправлена') ? 'yes' : (($ar[10] == 'Не отправлена') ? 'no' : null);
	}
	else $slugebka = null;
	
	if ($ar[13])
	{
		$docs = ($ar[13] == 'да') ? 'yes' : (($ar[13] == 'нет') ? 'no' : null);
	}
	else $docs = null;
	
	if ($ar[14])
	{
		$docs_buh = ($ar[14] == 'да') ? 'yes' : (($ar[14] == 'нет') ? 'no' : null);
	}
	else $docs_buh = null;

	if ($ar[17])
	{
		$sdate = date('Y-m-d', strtotime($ar[17]));
	}
	else $sdate = null;
	
	if ($ar[18])
	{
		$shipping = ($ar[18] == 'Отправлено') ? 'yes' : (($ar[10] == 'Не отправлено') ? 'no' : null);
	}
	else $shipping = null;
	
	$currency = strpos($ar[15], '$') !== false ? 'usd' : (strpos($ar[15], '€') !== false ? 'euro' : 'rub');
	
	$user_id = check_list($ar[5], 'users');
	
	if (!isset($users[$user_id])) $users[$user_id] = [ 'name' => $ar[5], 'regions' => [] ];
	
	$region = $ar[4];
	
	if (!in_array($region, $users[$user_id]['regions'])) $users[$user_id]['regions'][] = $region;

}

foreach($users as $u => $v)
{
	foreach($v['regions'] as $branch)
	if (trim($branch))
	{
		$bid = check_list($branch, 'branches');
		_main_::query(null, "
			update users
			set	branch	= {2}
			where	id	= {1}
		"
		, $u
		, $bid
		);
	}
}

debug($users); die;
function check_list($field, $table)
{
	if (!$field) return null;
	
	$dict = _main_::fetchModule('dictionaries');
	
	$id = $dict->get_id($field, $table);
	if (!$id)
	{
		$where = ($table == 'users') ? '' : ',	active	= 0';
		$id = _main_::query(null, "insert into `{$table}`
			set	`name`	= {1}
			{$where}
		"
		,	$field
		);
	}
	
	return $id;
}

debug($total);
die("OK");

?>