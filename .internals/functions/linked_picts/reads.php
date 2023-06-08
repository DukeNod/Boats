<?php

function select_linked_picts_by_ids (&$dat, $ids, $required = null, $details = null)
{
	if (!is_array($ids)) $ids = (array) $ids;
	$dat = !count($ids) ? array() : _main_::query('linked_pict', "
		select	L.*
		from	`linked_picts` as L
		where	L.`id` in {1}
		", $ids);
	if ($required && !count($dat))
		throw new exception_bl('No such record (by id).', 'linked_pict_absent', 'absent');
	select_linked_picts_details($dat, $details);
}

function select_linked_picts_for_admin (&$dat, $filters, $sorters, $pager = null, $details = null)
{
	$where_clause = convert_filters_to_sql_where_clause($filters, 'L', null, 'true');
	$order_clause = convert_sorters_to_sql_order_clause($sorters, 'L');
	$limit_clause = convert_pager_to_sql_limit_clause  ($pager);
	$dat = _main_::query('linked_pict', "
		select	L.*
		from	`linked_picts` as L
		where	{$where_clause}
		order	by {$order_clause}
		{$limit_clause}
		");
	select_linked_picts_details($dat, $details);
}

function select_linked_picts_by_uplinks (&$dat, $uplink_type, $uplink_ids, $details = null)
{
	$dat = _main_::query('linked_pict', "
		select	L.*
		from	`linked_picts` as L
		where	L.`uplink_type` = {1} and L.`uplink_id` in {2}
		order	by L.`uplink_type`, L.`uplink_id`, L.`position` asc, L.`id` asc
		", $uplink_type, $uplink_ids);
	select_linked_picts_details($dat, $details);
}

function select_linked_picts_by_uplinks_random (&$dat, $uplink_type, $uplink_ids, $details = null)
{
	$dat = _main_::query('linked_pict', "
		select	L.*
		from	`linked_picts` as L
		where	L.`uplink_type` = {1} and L.`uplink_id` in {2}
		order	by rand()
		limit 1
		", $uplink_type, $uplink_ids);
	select_linked_picts_details($dat, $details);
}

function select_linked_picts_by_uplinks_by_page (&$dat, $uplink_type, $uplink_ids, &$pager, $details = null)
{
        $limit=$pager->limit();
	$dat = _main_::query('linked_pict', "
		select	SQL_CALC_FOUND_ROWS L.*
		from	`linked_picts` as L
		where	L.`uplink_type` = {1} and L.`uplink_id` in {2}
		order	by L.`uplink_type`, L.`uplink_id`, L.`position` asc, L.`id` asc
		{$limit}
		", $uplink_type, $uplink_ids);
	$pager->getTotal();
	select_linked_picts_details($dat, $details);
}


function select_linked_picts_where_orphaned (&$dat, $details = null)
{
	$dat = _main_::query('linked_pict', "
		select	L.*
		from	`linked_picts` as L
		where	L.`uplink_type` is null or L.`uplink_id` is null
		order	by null
		");
	select_linked_picts_details($dat, $details);
}

function select_linked_picts_details (&$struct, $details = null)
{
	// Это затычка для обработки uploaded файлов и возможности смены их имени. Что-то типа того. Я уж и забыл как оно там это использует.
	foreach ($struct as $key => $row)
	{
		$struct[$key]['small_name' ] = $struct[$key]['small_file'];
		$struct[$key]['middle_name'] = $struct[$key]['middle_file'];
		$struct[$key]['large_name' ] = $struct[$key]['large_file'];
		$struct[$key]['small_href' ] = 'linked/picts/small/'.$row['uplink_type'].'/'.$row['uplink_id'].'/'.$struct[$key]['small_file'];
		$struct[$key]['middle_href'] = 'linked/picts/middle/'.$row['uplink_type'].'/'.$row['uplink_id'].'/'.$struct[$key]['middle_file'];
		$struct[$key]['large_href' ] = 'linked/picts/large/'.$row['uplink_type'].'/'.$row['uplink_id'].'/'.$struct[$key]['large_file'];
	}
}

?>