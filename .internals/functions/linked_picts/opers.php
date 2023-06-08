<?php

function toggle_linked_pict (&$errors, &$data, &$id, $field, $value)
{
	$field = _main_::sql_field($field);
	try { _main_::query(null, "
		update 	`linked_picts`
		set	{$field} = {2}
		where	`id` = {1}
		", $id, $value);
	}
	catch (exception_db_unique $exception) { handle_linked_pict_uploads_temporarily($data); _main_::depend('validations'); validate_add_error($errors, '', 'duplicate'); }
	catch (exception           $exception) { handle_linked_pict_uploads_temporarily($data); throw $exception; }
}

function update_linked_pict (&$errors, &$data, &$id, $orig = null)
{
	try { _main_::query(null, "
		update 	`linked_picts`
		set	`uplink_type`		= {02}
		,	`uplink_id`		= {03}
		,	`position`		= {04}
		,	`alt`			= {05}
		,	`small_file`		= if({6}, null, {7})
		,	`small_w`		= if({6}, null, {8})
		,	`small_h`		= if({6}, null, {9})
		,	`middle_file`		= if({10}, null, {11})
		,	`middle_w`		= if({10}, null, {12})
		,	`middle_h`		= if({10}, null, {13})
		,	`large_file`		= if({14}, null, {15})
		,	`large_w`		= if({14}, null, {16})
		,	`large_h`		= if({14}, null, {17})
		where	`id` = {1}
		", $id,
		$data['uplink_type'], $data['uplink_id'],
		parse_linked_pict_position($data['position'], $data['uplink_type'], $data['uplink_id']),
		$data['alt'],
		$data['small_delete'], $data['small_name'], $data['small_w'], $data['small_h'],
		$data['middle_delete'], $data['middle_name'], $data['middle_w'], $data['middle_h'],
		$data['large_delete'], $data['large_name'], $data['large_w'], $data['large_h'],
		null);
		handle_linked_pict_uploads_persistently($data);

		if (($orig === null) || ($orig['position'] !== $data['position']))
		reorder_linked_picts($orig['uplink_type'], $orig['uplink_id']);
		reorder_linked_picts($data['uplink_type'], $data['uplink_id']);
	}
	catch (exception_db_unique $exception) { handle_linked_pict_uploads_temporarily($data); _main_::depend('validations'); validate_add_error($errors, '', 'duplicate'); }
	catch (exception           $exception) { handle_linked_pict_uploads_temporarily($data); throw $exception; }
}

function insert_linked_pict_import (&$errors, &$data)
{
	if ($data['images']) foreach($data['images'] as &$v)
	{
		insert_linked_pict ($errors, $v, $id);
	}
}

function insert_linked_pict (&$errors, &$data, &$id)
{
	try { $id = _main_::query(null, "
		insert 	into `linked_picts`
		set	`uplink_type`		= {02}
		,	`uplink_id`		= {03}
		,	`position`		= {04}
		,	`alt`			= {05}
		,	`small_file`		= if({6}, null, {7})
		,	`small_w`		= if({6}, null, {8})
		,	`small_h`		= if({6}, null, {9})
		,	`middle_file`		= if({10}, null, {11})
		,	`middle_w`		= if({10}, null, {12})
		,	`middle_h`		= if({10}, null, {13})
		,	`large_file`		= if({14}, null, {15})
		,	`large_w`		= if({14}, null, {16})
		,	`large_h`		= if({14}, null, {17})
		", $id,
		$data['uplink_type'], $data['uplink_id'],
		parse_linked_pict_position($data['position'], $data['uplink_type'], $data['uplink_id']),
		$data['alt'],
		$data['small_delete'], $data['small_name'], $data['small_w'], $data['small_h'],
		$data['middle_delete'], $data['middle_name'], $data['middle_w'], $data['middle_h'],
		$data['large_delete'], $data['large_name'], $data['large_w'], $data['large_h'],
		null);

		handle_linked_pict_uploads_persistently($data);

		reorder_linked_picts($data['uplink_type'], $data['uplink_id']);
	}
	catch (exception_db_unique $exception) { handle_linked_pict_uploads_temporarily($data); _main_::depend('validations'); validate_add_error($errors, '', 'duplicate'); }
	catch (exception           $exception) { handle_linked_pict_uploads_temporarily($data); throw $exception; }
}

function delete_linked_pict (&$errors, &$data, &$id)
{
	_main_::depend('linked_picts//reads');
	if ($data !== null) $dat = array($data); else
	select_linked_picts_by_ids($dat, $id);
	delete_linked_picts_in_table($dat);

	reorder_linked_picts($data['uplink_type'], $data['uplink_id']);
}

function delete_linked_picts_by_uplinks ($uplink_type, $uplink_ids)
{
	_main_::depend('linked_picts//reads');
	select_linked_picts_by_uplinks($dat, $uplink_type, $uplink_ids);
	delete_linked_picts_in_table($dat);

	foreach ($uplink_ids as $uplink_id)
	reorder_linked_picts($uplink_type, $uplink_id);
}

function delete_linked_picts_where_orphaned ()
{
	_main_::depend('linked_picts//reads');
	select_linked_picts_where_orphaned($dat);
	delete_linked_picts_in_table($dat);
}

function delete_linked_picts_in_table ($table)
{
	_main_::depend('merges');
	$ids = get_fields($table, 'id');

	// Удаляем сами записи и чистим файлы от файловых полей.
	_main_::query(null, "delete from `linked_picts` where `id` in {1}", $ids);
	foreach ($table as $row) handle_linked_pict_uploads_cleanly($row);
}

function moveup_linked_pict (&$errors, &$data, &$id)
{
	_main_::query(null, "update `linked_picts` set `position` = (@position := `position` - 1) where `id` = {1}                            and `uplink_type` = {2} and `uplink_id` = {3}", $id, $data['uplink_type'], $data['uplink_id']);
	_main_::query(null, "update `linked_picts` set `position` = (             `position` + 1) where `id`<> {1} and `position` = @position and `uplink_type` = {2} and `uplink_id` = {3}", $id, $data['uplink_type'], $data['uplink_id']);
}

function movedn_linked_pict (&$errors, &$data, &$id)
{
	_main_::query(null, "update `linked_picts` set `position` = (@position := `position` + 1) where `id` = {1}                            and `uplink_type` = {2} and `uplink_id` = {3}", $id, $data['uplink_type'], $data['uplink_id']);
	_main_::query(null, "update `linked_picts` set `position` = (             `position` - 1) where `id`<> {1} and `position` = @position and `uplink_type` = {2} and `uplink_id` = {3}", $id, $data['uplink_type'], $data['uplink_id']);
}

function reorder_linked_picts ($uplink_type, $uplink_id)
{
	_main_::query(null, "select @position := 0");
	_main_::query(null, "update `linked_picts` set `position` = (@position := @position + 1) where `uplink_type` = {1} and `uplink_id` = {2} order by `position` asc, `id` asc", $uplink_type, $uplink_id);
}

function parse_linked_pict_position ($position, $uplink_type, $uplink_id)
{
	_main_::depend('sql');
	return parse_position($position, '`linked_picts`', '`position`', '`uplink_type`={1} and `uplink_id`={2}', $uplink_type, $uplink_id);
}

function handle_linked_pict_uploads_cleanly (&$data)
{
	_main_::depend('uploads');
	handle_upload_cleanly($data, 'small', _config_::$dir_for_linked . 'picts/small/' . $data['uplink_type'] . '/' . $data['uplink_id'] . '/', _config_::$tmp_for_linked);
	handle_upload_cleanly($data, 'middle', _config_::$dir_for_linked . 'picts/middle/' . $data['uplink_type'] . '/' . $data['uplink_id'] . '/', _config_::$tmp_for_linked);
	handle_upload_cleanly($data, 'large', _config_::$dir_for_linked . 'picts/large/' . $data['uplink_type'] . '/' . $data['uplink_id'] . '/', _config_::$tmp_for_linked);
}

function handle_linked_pict_uploads_temporarily (&$data)
{
	_main_::depend('uploads');
	handle_upload_temporarily($data, 'small', _config_::$dir_for_linked . 'picts/small/' . $data['uplink_type'] . '/' . $data['uplink_id'] . '/', _config_::$tmp_for_linked);
	handle_upload_temporarily($data, 'middle', _config_::$dir_for_linked . 'picts/middle/' . $data['uplink_type'] . '/' . $data['uplink_id'] . '/', _config_::$tmp_for_linked);
	handle_upload_temporarily($data, 'large', _config_::$dir_for_linked . 'picts/large/' . $data['uplink_type'] . '/' . $data['uplink_id'] . '/', _config_::$tmp_for_linked);
}

function handle_linked_pict_uploads_persistently (&$data)
{
	_main_::depend('uploads');
	handle_upload_persistently($data, 'small', _config_::$dir_for_linked . 'picts/small/' . $data['uplink_type'] . '/' . $data['uplink_id'] . '/', _config_::$tmp_for_linked);
	handle_upload_persistently($data, 'middle', _config_::$dir_for_linked . 'picts/middle/' . $data['uplink_type'] . '/' . $data['uplink_id'] . '/', _config_::$tmp_for_linked);
	handle_upload_persistently($data, 'large', _config_::$dir_for_linked . 'picts/large/' . $data['uplink_type'] . '/' . $data['uplink_id'] . '/', _config_::$tmp_for_linked);
}

function remember_linked_pict (&$data)
{
	handle_linked_pict_uploads_temporarily($data);
}

?>
