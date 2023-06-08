<?php

function select_linked_files_by_ids (&$dat, $ids, $required = null, $details = null)
{
	if (!is_array($ids)) $ids = (array) $ids;
	$dat = !count($ids) ? array() : _main_::query('linked_file', "
		select	L.*
		from	`linked_files` as L
		where	L.`id` in {1}
		", $ids);
	if ($required && !count($dat))
		throw new exception_bl('No such record (by id).', 'linked_file_absent', 'absent');
	select_linked_files_details($dat, $details);
}

function select_linked_files_for_admin (&$dat, $filters, $sorters, $pager = null, $details = null)
{
	$where_clause = convert_filters_to_sql_where_clause($filters, 'L', null, 'true');
	$order_clause = convert_sorters_to_sql_order_clause($sorters, 'L');
	$limit_clause = convert_pager_to_sql_limit_clause  ($pager);
	$dat = _main_::query('linked_file', "
		select	L.*
		from	`linked_files` as L
		where	{$where_clause}
		order	by {$order_clause}
		{$limit_clause}
		");
	select_linked_files_details($dat, $details);
}

function select_linked_files_by_uplinks (&$dat, $uplink_type, $uplink_ids, $details = null)
{
	$dat = _main_::query('linked_file', "
		select	L.*
		from	`linked_files` as L
		where	L.`uplink_type` = {1} and L.`uplink_id` in {2} and lang_id = {3}
		order	by L.`uplink_type`, L.`uplink_id`, L.`position` asc, L.`id` asc
		", $uplink_type, $uplink_ids, _config_::$lang_id);
	select_linked_files_details($dat, $details);
}

function select_linked_files_where_orphaned (&$dat, $details = null)
{
	$dat = _main_::query('linked_file', "
		select	L.*
		from	`linked_files` as L
		where	L.`uplink_type` is null or L.`uplink_id` is null
		order	by null
		");
	select_linked_files_details($dat, $details);
}

function select_linked_files_details (&$struct, $details = null)
{
	// Это затычка для обработки uploaded файлов и возможности смены их имени. Что-то типа того. Я уж и забыл как оно там это использует.
	foreach ($struct as $key => $row)
	{
		$struct[$key][ 'attach_name'] = $struct[$key][ 'attach_file'];
		$struct[$key]['preview_name'] = $struct[$key]['preview_file'];
		$struct[$key][ 'attach_href'] = 'linked/files/attach/'.$row['uplink_type'].'/'.$row['uplink_id'].'/'.$struct[$key]['attach_file'];
		$struct[$key]['preview_href'] = 'linked/files/preview/'.$row['uplink_type'].'/'.$row['uplink_id'].'/'.$struct[$key]['preview_file'];
	}
}

?>