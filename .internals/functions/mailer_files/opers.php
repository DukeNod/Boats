<?php

function switch_mailer_file (&$errors, &$data, &$id, $field, $value)
{
	try { _main_::query(null, "
		update 	`mailer_files`
		set	`{$field}` = {2}
		where	`id` = {1}
		", $id, $value);
	}
	catch (exception_db_unique $exception) { _main_::depend('validations'); validate_add_error($errors, '', 'duplicate'); }
	catch (exception           $exception) { throw $exception; }
}

function update_mailer_file (&$errors, &$data, &$id, $orig = null)
{
	try { _main_::query(null, "
		update 	`mailer_files`
		set	`mailer_task`	= {02}
		,	`position`	= {03}
		,	`name`		= {04}
		,	`attach_file`	= if({5}, null, {6})
		,	`attach_type`	= if({5}, null, {7})
		,	`attach_size`	= if({5}, null, {8})
		where	`id` = {1}
		", $id,
		$data['mailer_task'],
		parse_mailer_file_position($data['position'], $data['mailer_task']),
		$data['name'],
		$data['attach_delete'], $data['attach_name'], $data['attach_type'], $data['attach_size'],
		null);

		handle_mailer_file_uploads_persistently($data);
		reorder_mailer_files($data['mailer_task']);
	}
	catch (exception_db_unique $exception) { handle_mailer_file_uploads_temporarily($data); _main_::depend('validations'); validate_add_error($errors, '', 'duplicate'); }
	catch (exception           $exception) { handle_mailer_file_uploads_temporarily($data); throw $exception; }
}

function insert_mailer_file (&$errors, &$data, &$id)
{
	try { $id = _main_::query(null, "
		insert 	into `mailer_files`
		set	`mailer_task`	= {02}
		,	`position`	= {03}
		,	`name`		= {04}
		,	`attach_file`	= if({5}, null, {6})
		,	`attach_type`	= if({5}, null, {7})
		,	`attach_size`	= if({5}, null, {8})
		", null,
		$data['mailer_task'],
		parse_mailer_file_position($data['position'], $data['mailer_task']),
		$data['name'],
		$data['attach_delete'], $data['attach_name'], $data['attach_type'], $data['attach_size'],
		null);

		handle_mailer_file_uploads_persistently($data);
		reorder_mailer_files($data['mailer_task']);
	}
	catch (exception_db_unique $exception) { handle_mailer_file_uploads_temporarily($data); _main_::depend('validations'); validate_add_error($errors, '', 'duplicate'); }
	catch (exception           $exception) { handle_mailer_file_uploads_temporarily($data); throw $exception; }
}

function delete_mailer_file (&$errors, &$data, &$id)
{
	_main_::depend('mailer_files//reads');
	if ($data !== null) $dat = array($data); else
	select_mailer_file_by_id($dat, $id);
	delete_mailer_files_in_table($dat);
	reorder_mailer_files($data['mailer_task']);
}

function delete_mailer_files_by_mailer_tasks ($mailer_tasks)
{
	_main_::depend('mailer_files//reads');
	select_mailer_files_by_mailer_tasks($dat, $mailer_tasks);
	delete_mailer_files_in_table($dat);
	foreach ($mailer_tasks as $mailer_task)
	reorder_mailer_files($mailer_task);
}

function delete_mailer_files_in_table ($table)
{
	_main_::depend('merges');
	$ids = get_fields($table, 'id');

	// Удаляем сами записи и чистим файлы от файловых полей.
	_main_::query(null, "delete from `mailer_files` where `id` in {1}", $ids);
	foreach ($table as $row) handle_mailer_file_uploads_cleanly($row);
}

function null_mailer_files_by_mailer_tasks ($mailer_tasks)
{
	_main_::depend('mailer_files//reads');
	select_mailer_files_by_mailer_tasks($dat, $mailer_tasks);
	null_mailer_files_in_table($dat);
}

function null_mailer_files_in_table ($table)
{
	_main_::depend('merges');
	$ids = get_fields($table, 'id');

	// За'null'яем сами записи и чистим файлы из файловых полей.
	_main_::query(null, "update `mailer_files` set `name` = `attach_file` where `id` in {1} and `name` is null", $ids);
	_main_::query(null, "update `mailer_files` set `attach_file` = null where `id` in {1}", $ids);
	foreach ($table as $row) handle_mailer_file_uploads_cleanly($row);
}

function moveup_mailer_file (&$errors, &$data, &$id)
{
	_main_::query(null, "update `mailer_files` set `position` = (@position := `position` - 1) where `id` = {1}                            and `mailer_task` = {2}", $id, $data['mailer_task']);
	_main_::query(null, "update `mailer_files` set `position` = (             `position` + 1) where `id`<> {1} and `position` = @position and `mailer_task` = {2}", $id, $data['mailer_task']);
}

function movedn_mailer_file (&$errors, &$data, &$id)
{
	_main_::query(null, "update `mailer_files` set `position` = (@position := `position` + 1) where `id` = {1}                            and `mailer_task` = {2}", $id, $data['mailer_task']);
	_main_::query(null, "update `mailer_files` set `position` = (             `position` - 1) where `id`<> {1} and `position` = @position and `mailer_task` = {2}", $id, $data['mailer_task']);
}

function reorder_mailer_files ($mailer_task)
{
	_main_::query(null, "select @position := 0");
	_main_::query(null, "update `mailer_files` set `position` = (@position := @position + 1) where `mailer_task` = {1} order by `position` asc, `id` asc", $mailer_task);
}

function parse_mailer_file_position ($position, $mailer_task)
{
	_main_::depend('sql');
	return parse_position($position, '`mailer_files`', '`position`', '`mailer_task`={1}', $mailer_task);
}

function handle_mailer_file_uploads_cleanly (&$data)
{
	_main_::depend('uploads');
	handle_upload_cleanly($data, 'attach', _config_::$dir_for_linked . 'mailer/', _config_::$tmp_for_linked);
}

function handle_mailer_file_uploads_temporarily (&$data)
{
	_main_::depend('uploads');
	handle_upload_temporarily($data, 'attach', _config_::$dir_for_linked . 'mailer/', _config_::$tmp_for_linked);
}

function handle_mailer_file_uploads_persistently (&$data)
{
	_main_::depend('uploads');
	handle_upload_persistently($data, 'attach', _config_::$dir_for_linked . 'mailer/', _config_::$tmp_for_linked);
}

function remember_mailer_file (&$data)
{
	handle_mailer_file_uploads_temporarily($data);
}

?>