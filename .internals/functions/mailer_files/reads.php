<?php

function select_mailer_file_by_id (&$dat, $id, $required = false, $exception_id = null)
{
	$dat = _main_::query('mailer_file', "
		select	MF.*
		,	MF.`attach_file` as `attach_name`
		from	`mailer_files` as MF
		where	MF.`id` = {1}
		", $id);
	if ($required && !count($dat))
		throw new exception_bl('No such record (by id).', $exception_id);
}

function select_mailer_files_for_admin (&$dat, $filters, $sorters)
{
	$where_clause = convert_filters_to_sql_where_clause($filters, 'MF', null, 'true');
	$order_clause = convert_sorters_to_sql_order_clause($sorters, 'MF', null);
	$dat = _main_::query('mailer_file', "
		select	MF.*
		,	MF.`attach_file` as `attach_name`
		from	`mailer_files` as MF
		where	{$where_clause}
		order	by {$order_clause}
		");
}

function select_mailer_files_by_mailer_tasks (&$dat, $mailer_tasks)
{
	$dat = _main_::query('mailer_file', "
		select	MF.*
		,	MF.`attach_file` as `attach_name`
		from	`mailer_files` as MF
		where	MF.`mailer_task` in {1}
		order	by MF.`position` asc, MF.`id` asc
		", $mailer_tasks);
}

?>