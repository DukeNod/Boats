<?php

function switch_subscriber (&$errors, &$data, &$id, $field, $value)
{
	try { _main_::query(null, "
		update 	`subscribers`
		set	`{$field}` = {2}
		where	`id` = {1}
		", $id, $value);
	}
	catch (exception_db_unique $exception) { _main_::depend('validations'); validate_add_error($errors, 'email', 'duplicate'); }
	catch (exception           $exception) { throw $exception; }
}

function activate_subscriber (&$id)
{
	_main_::query(null, "
		update 	`subscribers`
		set	`is_active` = 1
		,	`confirm_ts` = now()
		where	`id` = {1}
		", $id);
}

function disactivate_subscriber (&$id, $clean = null)
{
	if ($clean)
	_main_::query(null, "
		delete	from `subscribers`
		where	`id` = {1}
		", $id);
	else
	_main_::query(null, "
		update 	`subscribers`
		set	`is_active` = 0
		where	`id` = {1}
		", $id);
}

function update_subscriber (&$errors, &$data, &$id, $orig = null)
{
	try { _main_::query(null, "
		update 	`subscribers`
		set	`email`		= {02}
		,	`code`		= ifnull({03}, `code`)
		,	`is_active`	= {04}
		,	`is_tester`	= {05}
		where	`id` = {1}
		", $id,
		$data['email'],
		$data['code'],
		$data['is_active'],
		$data['is_tester'],
		null);

		subscribers_fulfil_groups($id, $data['groups_list']);

		handle_subscriber_uploads_persistently($data);
	}
	catch (exception_db_unique $exception) { handle_subscriber_uploads_temporarily($data); _main_::depend('validations'); validate_add_error($errors, 'email', 'duplicate'); }
	catch (exception           $exception) { handle_subscriber_uploads_temporarily($data); throw $exception; }
}

function import_subscribers (&$errors, &$data)
{
        /*
        $str = '';

	if ($data['emails']) 
	{
		foreach ($data['emails'] as $v)
			$str .= '('._main_::sql_quote($v).', 1, '.generate_subscriber_code().'), ';
		$str = substr($str, 0, -2);
	}

	_main_::query(null, "
		insert ignore 	`subscribers` (`email`, `is_active`, `code`)
		values {$str}
	");

	return mysql_affected_rows();
	*/
	$i = 0;
	foreach ($data['emails'] as $v)
	{
		if ($dat = _main_::query('row', 'select `id` from `subscribers` where `email` = {1}', $v))
		{
			$id = array_shift(array_shift($dat));
		}else
		{
			$id = _main_::query(null, "
				insert into `subscribers`
				set	`email`		= {1}
				,	`is_active`	= {2}
				,	`code`		= {3}
			",	$v
			,	1
			,	generate_subscriber_code()
			);
			$i++;
		}

		subscribers_fulfil_groups($id, $data['groups_list']);
	}

	return $i;
}

function insert_subscriber (&$errors, &$data, &$id)
{
	try { $id = _main_::query(null, "
		insert 	into `subscribers`
		set	`email`		= {02}
		,	`code`		= {03}
		,	`is_active`	= {04}
		,	`is_tester`	= {05}
		", null,
		$data['email'],
		$data['code'],
		$data['is_active'],
		$data['is_tester'],
		null);

		subscribers_fulfil_groups($id, $data['groups_list']);

		handle_subscriber_uploads_persistently($data);
	}
	catch (exception_db_unique $exception) { handle_subscriber_uploads_temporarily($data); _main_::depend('validations'); validate_add_error($errors, 'email', 'duplicate'); }
	catch (exception           $exception) { handle_subscriber_uploads_temporarily($data); throw $exception; }
}

function request_subscriber (&$data, &$id)
{
	try { $id = _main_::query(null, "
		insert 	into `subscribers`
		set	`email`		= {02}
		,	`code`		= {03}
		,	`is_active`	= 0
		,	`is_tester`	= 0
		,	`request_ts`	= now()
		,	`confirm_ts`	= null
		", null,
		$data['email'],
		$data['code'],
		null);

		handle_subscriber_uploads_persistently($data);
	}
	catch (exception $exception) { handle_subscriber_uploads_temporarily($data); throw $exception; }
}

function delete_subscriber (&$errors, &$data, &$id)
{
	_main_::depend('subscribers//reads');
	if ($data !== null) $dat = array($data); else
	select_subscriber_by_id($dat, $id);
	delete_subscribers_in_table($dat);
}

function delete_subscribers_where_inactive ($age_in_seconds)
{
	_main_::depend('subscribers//reads');
	select_subscribers_where_inactive($dat, $age_in_seconds);
	delete_subscribers_in_table($dat);
}

function delete_subscribers_in_table ($table)
{
	_main_::depend('merges');
	$ids = get_fields($table, 'id');

	// Удаляем дочерние элементы (неявно вместе со всеми их файлами и под-дочерними элементами).
	// nothing to do

	// Удаляем сами записи и чистим файлы от файловых полей.
	_main_::query(null, "delete from `_groups2subscribers_` where `subscriber` in {1}", $ids);
	_main_::query(null, "delete from `subscribers` where `id` in {1}", $ids);
	foreach ($table as $row) handle_subscriber_uploads_cleanly($row);
}

function handle_subscriber_uploads_cleanly (&$data)
{
}

function handle_subscriber_uploads_temporarily (&$data)
{
}

function handle_subscriber_uploads_persistently (&$data)
{
}

function remember_subscriber (&$data)
{
	handle_subscriber_uploads_temporarily($data);
}

function generate_subscriber_code ($email = null)
{
	_main_::depend('generators');
	return generate_alphabet(7, 9);
}

function subscribers_fulfil_groups ($id, $parts_list)
{
	$parts_ids = get_fields($parts_list, 'id');

	// Удаляем ссылки, которые отсутствуют в нашем целевом списке (либо чистим все связи, если целевой список пуст).
	if (count($parts_list))
	_main_::query(null, "
		delete	from `_groups2subscribers_`
		where	`subscriber` = {1} and `group` not in {2}
		", $id, $parts_ids);
	else
	_main_::query(null, "
		delete	from `_groups2subscribers_`
		where	`subscriber` = {1}
		", $id);

	// Добавляем (с игнорированием уже существующих связей) связи на автомодели из целевого списка.
	// Для работы replace важно чтоб связка двух этих id была primary key!
	$list = array(); foreach ($parts_ids as $parts_id) $list[] = _main_::sql_quote($parts_id);
	$list = count($list) ? "({1}," . implode("),({1},", $list) . ")" : null;
	if (strlen($list)) _main_::query(null, "
		insert ignore into `_groups2subscribers_`
			(`subscriber`, `group`)
		values	{$list}
		", $id);
}
?>