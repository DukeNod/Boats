<?php

function select_subscriber_by_id (&$dat, $id, $required = false, $exception_id = null)
{
	$dat = _main_::query('subscriber', "
		select	S.*
		from	`subscribers` as S
		where	S.`id` = {1}
		", $id);
	if ($required && !count($dat))
		throw new exception_bl('No such record (by id).', $exception_id);
	select_subscribers_details($dat);
}

function select_subscriber_by_email (&$dat, $email, $required = false, $exception_id = null)
{
	$dat = _main_::query('subscriber', "
		select	S.*
		from	`subscribers` as S
		where	S.`email` = {1}
		", $email);
	if ($required && !count($dat))
		throw new exception_bl('No such record (by email).', $exception_id);
	select_subscribers_details($dat);
}

function count_subscribers_for_admin ($filters, $sorters)
{
	$where_clause = convert_filters_to_sql_where_clause($filters, 'S', array(
		'group' => '({#} = 0 and G2S.`group` is null) or (G2S.`group` = {#})'
	), '1');
	$order_clause = convert_sorters_to_sql_order_clause($sorters, 'S', null);
	$dat = _main_::query(null, "
		select	count(S.`id`)
		from	`subscribers` as S
		left	join `_groups2subscribers_` G2S on (G2S.`subscriber` = S.`id`)
		where	{$where_clause}
		group	by S.`id`
		");
	return array_shift(array_shift($dat));
}

function select_subscribers_for_admin (&$dat, $filters, $sorters, &$pager)
{
	$where_clause = convert_filters_to_sql_where_clause($filters, 'S', array(
		'group' => '({#} = 0 and G2S.`group` is null) or (G2S.`group` = {#})'
	), '1');
	$order_clause = convert_sorters_to_sql_order_clause($sorters, 'S');
	$limit_clause = convert_pager_to_sql_limit_clause  ($pager  );
	$dat = _main_::query('subscriber', "
		select	SQL_CALC_FOUND_ROWS S.*
		from	`subscribers` as S
		left	join `_groups2subscribers_` G2S on (G2S.`subscriber` = S.`id`)
		where	{$where_clause}
		group	by S.`id`
		order	by {$order_clause}
		{$limit_clause}
		");
	$total = _main_::query(null, "SELECT FOUND_ROWS() as total");
	$pager['count'] = array_shift(array_shift($total));

}

function select_subscribers_where_inactive (&$dat, $age_in_seconds)
{
	$dat = _main_::query('subscriber', "
		select	S.*
		from	`subscribers` as S
		where	not `is_active`
		and	`request_ts` < subdate(now(), interval {1} second)
		", $age_in_seconds);
}

function select_subscribers_by_groups (&$dat, $groups, $details = null)
{
        $where = '(G2S.`group` in {1})';
        if (in_array(0, $groups)) $where .= ' or (G2S.`group` is null)';

	$dat = _main_::query('subscriber', "
		select	S.*
		,	G2S.`group`
		from	`subscribers` as S
		left	join `_groups2subscribers_` G2S on (G2S.`subscriber` = S.`id`)
		where	{$where}
		group	by S.`id`
		", $groups);
}

function select_subscribers_where_active (&$dat)
{
	$dat = _main_::query('subscriber', "
		select	S.*
		from	`subscribers` as S
		where	`is_active`
		");
}

function select_subscribers_details (&$struct)
{
	_main_::depend('details');
	select_details($struct, true, array(
		'groups' => 'select_subscriber_groups',
		));
}

function select_subscriber_groups(&$struct, $details = null) { _main_::depend('merges'); $m=_main_::fetchModule('subscriber_groups'); $m->select_by_subscribers($dat, get_fields($struct, 'id'), $details); merge_subtable_as_array($struct, $dat, 'groups_list', 'subscriber'    , 'id'); }

?>