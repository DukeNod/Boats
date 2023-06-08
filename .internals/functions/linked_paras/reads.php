<?php

function select_linked_paras_by_ids (&$dat, $ids, $required = null, $details = null)
{
	if (!is_array($ids)) $ids = (array) $ids;
	$dat = !count($ids) ? array() : _main_::query('linked_para', "
		select	L.*
		from	`linked_paras` as L
		where	L.`id` in {1}
		", $ids);
	if ($required && !count($dat))
		throw new exception_bl('No such record (by id).', 'linked_para_absent', 'absent');
	select_linked_paras_details($dat, $details);
}

function select_linked_paras_for_admin (&$dat, $filters, $sorters, $pager = null, $details = null)
{
	$where_clause = convert_filters_to_sql_where_clause($filters, 'L', null, 'true');
	$order_clause = convert_sorters_to_sql_order_clause($sorters, 'L');
	$limit_clause = convert_pager_to_sql_limit_clause  ($pager);
	$dat = _main_::query('linked_para', "
		select	L.*
		from	`linked_paras` as L
		where	{$where_clause}
		order	by {$order_clause}
		{$limit_clause}
		");
	select_linked_paras_details($dat, $details);
}

function select_linked_paras_by_uplinks (&$dat, $uplink_type, $uplink_ids, $details = null)
{
	$dat = _main_::query('linked_para', "
		select	L.*
		from	`linked_paras` as L
		where	L.`uplink_type` = {1} and L.`uplink_id` in {2} and lang_id = {3}
		order	by L.`uplink_type`, L.`uplink_id`, L.`position` asc, L.`id` asc
		", $uplink_type, $uplink_ids, _config_::$lang_id);
	select_linked_paras_details($dat, $details);
}

function select_linked_paras_count_by_uplinks (&$dat, $uplink_type, $uplink_ids, $details = null)
{
	$dat = _main_::query('linked_para', "
		select	L.`uplink_id`, count(L.`id`) as `linked_avail`
		from	`linked_paras` as L
		where	L.`uplink_type` = {1} and L.`uplink_id` in {2} and lang_id = {3}
		group	by L.`uplink_id`
		", $uplink_type, $uplink_ids, _config_::$lang_id);
	select_linked_paras_details($dat, $details);
}

function select_linked_paras_where_orphaned (&$dat, $details = null)
{
	$dat = _main_::query('linked_para', "
		select	L.*
		from	`linked_paras` as L
		where	L.`uplink_type` is null or L.`uplink_id` is null
		order	by null
		");
	select_linked_paras_details($dat, $details);
}

function select_linked_paras_details (&$struct, $details = null)
{
	// Это затычка для обработки uploaded файлов и возможности смены их имени. Что-то типа того. Я уж и забыл как оно там это использует.
	foreach ($struct as $key => $row)
	{
		$struct[$key]['small_name'] = $struct[$key]['small_file'];
		$struct[$key]['large_name'] = $struct[$key]['large_file'];
	}
}

?>