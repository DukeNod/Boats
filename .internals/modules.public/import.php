<?php


_main_::query(null, "truncate table pays");
_main_::query(null, "truncate table payment");
_main_::query(null, "truncate table `_models4payment_`");

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
	
	$model = check_list($ar[6], 'models');
	
	$order_type = 0;
	if ($model)
	{
		$tmp = _main_::query(null, "select `type` from `models` where id = {1}"
		,	$model
		);
		if (array_shift($tmp)['type'] == 4) $order_type = 1;
	}
	
	$new_id = _main_::query(null, "insert into payment
		set	phone	= {1}
		,	client	= {2}
		,	contract_number	= {3}
		,	contract_date	= {4}
		,	branch			= {5}
		,	manager			= {6}
		,	model			= {7}
		,	`type`			= {8}
		,	boat_number		= {9}
		,	avail			= {10}
		,	slugebka		= {11}
		,	paytype			= {12}
		,	organization	= {13}
		,	docs			= {14}
		,	docs_buh		= {15}
		,	summ			= {16}
		,	discount		= {17}
		,	shipping_date	= {18}
		,	shipping_status	= {19}
		,	currency		= {20}
		,	tradein			= {21}
		,	tradein_obj		= {22}
		,	gift			= {23}
		,	gift_summ		= {24}
		,	region			= {25}
		,	order_type		= {26}
	"
	,	$phone
	,	$ar[1]
	,	$ar[2]
	,	$cdate
	,	check_list($ar[4], 'branches')
	,	check_list($ar[5], 'users')
	,	null //check_list($ar[6], 'models')
	,	$type
	,	preg_replace('/\D/', '', $ar[8])
	,	$avail
	,	$slugebka
	,	check_list($ar[11], 'paytype')
	,	check_list($ar[12], 'organization')
	,	$docs
	,	$docs_buh
	,	make_price($ar[15])
	,	make_price($ar[16])
	,	$sdate
	,	$shipping
	,	$currency
	,	$ar[39]
	,	$ar[40]
	,	$ar[41]
	,	$ar[42]
	,	check_list($ar[43], 'regions')
	,	$order_type
	);
	

	pay_set($ar[20], $ar[21], $ar[22], $new_id);
	pay_set($ar[23], $ar[24], $ar[25], $new_id);
	pay_set($ar[27], $ar[28], $ar[29], $new_id);
	pay_set($ar[31], $ar[32], $ar[33], $new_id);
	
	if ($model)
	_main_::query(null, "insert into `_models4payment_`
		set	`payment`	= {1}
		,	`model`		= {2}
	"
	,	$new_id
	,	$model
	);
}

	function pay_set($ar20, $ar21, $ar22, $new_id)
	{
		if ($ar20 || $ar21 || $ar22)
		{
			if ($ar20)
			{
				$pdate = date('Y-m-d', strtotime($ar20));
			}
			else $pdate = null;
			
			$pstatus = ($ar22 == 'Оплачено') ? 'yes' : 'no';
			
			_main_::query(null, "insert into pays
				set	`date`	= {1}
				,	summ	= {2}
				,	status	= {3}
				,	payment	= {4}
			"
			,	$pdate
			,	make_price($ar21)
			,	$pstatus
			,	$new_id
			);
		}
	}

function make_price($price)
{
		if (!$price || strlen(trim($price)) < 2) return null;
		
		$price = str_replace(',00', '', $price);
		
		$ret = preg_replace('/\D/', '', $price);
		if (strpos($price, '-') === 0) $ret = -1 * $ret;
		
		return $ret;
}

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