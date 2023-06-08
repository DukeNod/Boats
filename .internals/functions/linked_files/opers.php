<?php

function toggle_linked_file (&$errors, &$data, &$id, $field, $value)
{
	$field = _main_::sql_field($field);
	try { _main_::query(null, "
		update 	`linked_files`
		set	{$field} = {2}
		where	`id` = {1}
		", $id, $value);
	}
	catch (exception_db_unique $exception) { handle_linked_file_uploads_temporarily($data); _main_::depend('validations'); validate_add_error($errors, '', 'duplicate'); }
	catch (exception           $exception) { handle_linked_file_uploads_temporarily($data); throw $exception; }
}

function update_linked_file (&$errors, &$data, &$id, $orig = null)
{
	try { _main_::query(null, "
		update 	`linked_files`
		set	`uplink_type`		= {02}
		,	`uplink_id`		= {03}
		,	`position`		= {04}
		,	`name`			= {05}
		,	`attach_file`		= if({6}, null, {7})
		,	`attach_type`		= if({6}, null, {8})
		,	`attach_size`		= if({6}, null, {9})
		,	`preview_file`		= if({10}, null, {11})
		,	`preview_w`		= if({10}, null, {12})
		,	`preview_h`		= if({10}, null, {13})
		,	`lang_id`		= {14}
		where	`id` = {1}
		", $id,
		$data['uplink_type'], $data['uplink_id'],
		parse_linked_file_position($data['position'], $data['uplink_type'], $data['uplink_id']),
		$data['name'],
		$data['attach_delete'], $data['attach_name'], $data['attach_type'], $data['attach_size'],
		$data['preview_delete'], $data['preview_name'], $data['preview_w'], $data['preview_h'],
		LANG_ID,
		null);

		handle_linked_file_uploads_persistently($data);

		if (($orig === null) || ($orig['position'] !== $data['position']))//WTF ?????????? чо за фигня? что за orig===null?
		reorder_linked_files($orig['uplink_type'], $orig['uplink_id']);
		reorder_linked_files($data['uplink_type'], $data['uplink_id']);
	}
	catch (exception_db_unique $exception) { handle_linked_file_uploads_temporarily($data); _main_::depend('validations'); validate_add_error($errors, '', 'duplicate'); }
	catch (exception           $exception) { handle_linked_file_uploads_temporarily($data); throw $exception; }
}

function insert_linked_file (&$errors, &$data, &$id)
{
	try { $id = _main_::query(null, "
		insert 	into `linked_files`
		set	`uplink_type`		= {02}
		,	`uplink_id`		= {03}
		,	`position`		= {04}
		,	`name`			= {05}
		,	`attach_file`		= if({6}, null, {7})
		,	`attach_type`		= if({6}, null, {8})
		,	`attach_size`		= if({6}, null, {9})
		,	`preview_file`		= if({10}, null, {11})
		,	`preview_w`		= if({10}, null, {12})
		,	`preview_h`		= if({10}, null, {13})
		,	`lang_id`		= {14}
		", null,
		$data['uplink_type'], $data['uplink_id'],
		parse_linked_file_position($data['position'], $data['uplink_type'], $data['uplink_id']),
		$data['name'],
		$data['attach_delete'], $data['attach_name'], $data['attach_type'], $data['attach_size'],
		$data['preview_delete'], $data['preview_name'], $data['preview_w'], $data['preview_h'],
		LANG_ID,
		null);

		handle_linked_file_uploads_persistently($data);
		reorder_linked_files($data['uplink_type'], $data['uplink_id']);
	}
	catch (exception_db_unique $exception) { handle_linked_file_uploads_temporarily($data); _main_::depend('validations'); validate_add_error($errors, '', 'duplicate'); }
	catch (exception           $exception) { handle_linked_file_uploads_temporarily($data); throw $exception; }
}

function delete_linked_file (&$errors, &$data, &$id)
{
	_main_::depend('linked_files//reads');
	if ($data !== null) $dat = array($data); else
	select_linked_files_by_ids($dat, $id);
	delete_linked_files_in_table($dat);
	reorder_linked_files($data['uplink_type'], $data['uplink_id']);
}

function delete_linked_files_by_uplinks ($uplink_type, $uplink_ids)
{
	_main_::depend('linked_files//reads');
	select_linked_files_by_uplinks($dat, $uplink_type, $uplink_ids);
	delete_linked_files_in_table($dat);

	foreach ($uplink_ids as $uplink_id)
	reorder_linked_files($uplink_type, $uplink_id);
}

function delete_linked_files_where_orphaned ()
{
	_main_::depend('linked_files//reads');
	select_linked_files_where_orphaned($dat);
	delete_linked_files_in_table($dat);
}

function delete_linked_files_in_table ($table)
{
	_main_::depend('merges');
	$ids = get_fields($table, 'id');

	// Удаляем сами записи и чистим файлы от файловых полей.
	_main_::query(null, "delete from `linked_files` where `id` in {1}", $ids);
	foreach ($table as $row) handle_linked_file_uploads_cleanly($row);
}

function moveup_linked_file (&$errors, &$data, &$id)
{
	_main_::query(null, "update `linked_files` set `position` = (@position := `position` - 1) where `id` = {1}                            and `uplink_type` = {2} and `uplink_id` = {3} and `lang_id` = {4}", $id, $data['uplink_type'], $data['uplink_id'], LANG_ID);
	_main_::query(null, "update `linked_files` set `position` = (             `position` + 1) where `id`<> {1} and `position` = @position and `uplink_type` = {2} and `uplink_id` = {3} and `lang_id` = {4}", $id, $data['uplink_type'], $data['uplink_id'], LANG_ID);
}

function movedn_linked_file (&$errors, &$data, &$id)
{
	_main_::query(null, "update `linked_files` set `position` = (@position := `position` + 1) where `id` = {1}                            and `uplink_type` = {2} and `uplink_id` = {3} and `lang_id` = {4}", $id, $data['uplink_type'], $data['uplink_id'], LANG_ID);
	_main_::query(null, "update `linked_files` set `position` = (             `position` - 1) where `id`<> {1} and `position` = @position and `uplink_type` = {2} and `uplink_id` = {3} and `lang_id` = {4}", $id, $data['uplink_type'], $data['uplink_id'], LANG_ID);
}

function reorder_linked_files ($uplink_type, $uplink_id)
{
	_main_::query(null, "select @position := 0");
	_main_::query(null, "update `linked_files` set `position` = (@position := @position + 1) where `uplink_type` = {1} and `uplink_id` = {2} and `lang_id` = {3} order by `position` asc, `id` asc", $uplink_type, $uplink_id, LANG_ID);
}

function parse_linked_file_position ($position, $uplink_type, $uplink_id)
{
	_main_::depend('sql');
	return parse_position($position, '`linked_files`', '`position`', '`uplink_type`={1} and `uplink_id`={2} and `lang_id` = {3}', $uplink_type, $uplink_id, LANG_ID);
}

function handle_linked_file_uploads_cleanly (&$data)
{
	_main_::depend('uploads');
	handle_upload_cleanly($data, 'attach' , _config_::$dir_for_linked . 'files/attach/'  . $data['uplink_type'] . '/' . $data['uplink_id'] . '/', _config_::$tmp_for_linked);
	handle_upload_cleanly($data, 'preview', _config_::$dir_for_linked . 'files/preview/' . $data['uplink_type'] . '/' . $data['uplink_id'] . '/', _config_::$tmp_for_linked);
}

function handle_linked_file_uploads_temporarily (&$data)
{
	_main_::depend('uploads');
	handle_upload_temporarily($data, 'attach' , _config_::$dir_for_linked . 'files/attach/'  . $data['uplink_type'] . '/' . $data['uplink_id'] . '/', _config_::$tmp_for_linked);
	handle_upload_temporarily($data, 'preview', _config_::$dir_for_linked . 'files/preview/' . $data['uplink_type'] . '/' . $data['uplink_id'] . '/', _config_::$tmp_for_linked);
}

function handle_linked_file_uploads_persistently (&$data)
{
	_main_::depend('uploads');
	handle_upload_persistently($data, 'attach' , _config_::$dir_for_linked . 'files/attach/'  . $data['uplink_type'] . '/' . $data['uplink_id'] . '/', _config_::$tmp_for_linked);
	handle_upload_persistently($data, 'preview', _config_::$dir_for_linked . 'files/preview/' . $data['uplink_type'] . '/' . $data['uplink_id'] . '/', _config_::$tmp_for_linked);
}

function remember_linked_file (&$data)
{
	handle_linked_file_uploads_temporarily($data);
}

?>