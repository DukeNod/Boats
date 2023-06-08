<?php
Class Inlines {
	var $table;
	var $essence;
	var $outfield;
	var $uplink;

	function __construct(){
		$this->table='inlines';
		$this->essence='inlines';
		$this->outfield='inline';
		$this->multilang_fields=array('content');
	}


function fetch_config ()
{
	_main_::depend('configs');
	$fields = array('pager_size');
	return config_for_module('inlines', $fields);
}

function fetch_enums ()
{
	$enums = array('@for' => 'inlines');

	_main_::put2dom('enums', $enums);
	return $enums;
}

function form_posted ($action = null)
{
	$result = array();
	_main_::depend('forms');

	// Always posted fields (text/password/textarea/select/radio/...)
	$fields = array('content');
	fields_fill($result, $fields); 
	fields_find($result, $fields);

	// Conditionally posted fields (checkbox)
	$fields = array();
	fields_fill($result, $fields, $action !== null ? 0 : null); 
	fields_find($result, $fields);

	return $result;
}

function form_posted_full ($action = null)
{
	$result = array();
	_main_::depend('forms');

	// Always posted fields (text/password/textarea/select/radio/...)
	$fields = array('content', 'label', 'comment', 'group', 'mode');
	fields_fill($result, $fields); 
	fields_find($result, $fields);

	// Conditionally posted fields (checkbox)
	$fields = array();
	fields_fill($result, $fields, $action !== null ? 0 : null); 
	fields_find($result, $fields);

	return $result;
}

function prepare (&$errors, &$data, $config, $enums)
{
}

function validate (&$errors, &$data, $config, $enums, $ignore_uploads = false)
{
	_main_::depend('validations', 'merges');

	validate_optional($errors, $data, 'content');

	if (!$ignore_uploads)
	{
	}
}


function validate_full (&$errors, &$data, $config, $enums, $ignore_uploads = false)
{
	_main_::depend('validations', 'merges');

	validate_required($errors, $data, 'label');
	validate_required($errors, $data, 'group');
	validate_required($errors, $data, 'mode');
	validate_required($errors, $data, 'comment');
	validate_optional($errors, $data, 'content');

	if (!$ignore_uploads)
	{
	}
}

function predelete (&$errors, &$data, $config, $enums)
{
}


function toggle (&$errors, &$data, &$id, $field, $value)
{
	$field = _main_::sql_field($field);
	try { _main_::query(null, "
		update 	`inlines`
		set	{$field} = {2}
		where	`id` = {1}
		", $id, $value);
	}
	catch (exception_db_unique $exception) { $this->handle_uploads_temporarily($data); _main_::depend('validations'); validate_add_error($errors, '', 'duplicate'); }
	catch (exception           $exception) { $this->handle_uploads_temporarily($data); throw $exception; }
}

function update (&$errors, &$data, &$id, $orig = null)
{
	update_texts($data, $this->table, $this->multilang_fields);

	try { _main_::query(null, "
		update 	`inlines`
		set	`label`		= {02}
		,	`comment`	= {03}
		,	`content`	= {04}
		where	`id` = {1}
		", $id,
		$data['label'],
		$data['comment'],
		$data['content'],
		null);

		$this->handle_uploads_persistently($data);
	}
	catch (exception_db_unique $exception) { $this->handle_uploads_temporarily($data); _main_::depend('validations'); validate_add_error($errors, '', 'duplicate'); }
	catch (exception           $exception) { $this->handle_uploads_temporarily($data); throw $exception; }
}

function update_full (&$errors, &$data, &$id, $orig = null)
{
	update_texts($data, $this->table, $this->multilang_fields);

	try { _main_::query(null, "
		update 	`inlines`
		set	`label`		= {02}
		,	`comment`	= {03}
		,	`content`	= {04}
		,	`mode`		= {05}
		,	`group`		= {06}
		where	`id` = {1}
		", $id,
		$data['label'],
		$data['comment'],
		$data['content'],
		$data['mode'],
		$data['group'],
		null);

		$this->handle_uploads_persistently($data);
	}
	catch (exception_db_unique $exception) { $this->handle_uploads_temporarily($data); _main_::depend('validations'); validate_add_error($errors, '', 'duplicate'); }
	catch (exception           $exception) { $this->handle_uploads_temporarily($data); throw $exception; }
}

function insert (&$errors, &$data, &$id)
{
	insert_texts($data, $this->multilang_fields);

	try { $id = _main_::query(null, "
		insert 	into `inlines`
		set	`label`		= {02}
		,	`comment`	= {03}
		,	`content`	= {04}
		", null,
		$data['label'],
		$data['comment'],
		$data['content'],
		null);

		$this->handle_uploads_persistently($data);
	}
	catch (exception_db_unique $exception) { $this->handle_uploads_temporarily($data); _main_::depend('validations'); validate_add_error($errors, '', 'duplicate'); }
	catch (exception           $exception) { $this->handle_uploads_temporarily($data); throw $exception; }
}

function insert_full (&$errors, &$data, &$id)
{
	insert_texts($data, $this->multilang_fields);

	try { $id = _main_::query(null, "
		insert 	into `inlines`
		set	`label`		= {02}
		,	`comment`	= {03}
		,	`content`	= {04}
		,	`mode`		= {05}
		,	`group`		= {06}
		", null,
		$data['label'],
		$data['comment'],
		$data['content'],
		$data['mode'],
		$data['group'],
		null);

		$this->handle_uploads_persistently($data);
	}
	catch (exception_db_unique $exception) { $this->handle_uploads_temporarily($data); _main_::depend('validations'); validate_add_error($errors, '', 'duplicate'); }
	catch (exception           $exception) { $this->handle_uploads_temporarily($data); throw $exception; }
}

function delete (&$errors, &$data, &$id)
{
	if ($data !== null) $dat = array($data); else
	$this->select_by_ids($dat, $id);
	$this->delete_in_table($dat);
}

function delete_in_table ($table)
{
	_main_::depend('merges');
	$ids = get_fields($table, 'id');

	// Удаляем дочерние элементы (неявно вместе со всеми их файлами и под-дочерними элементами).
	_main_::depend('linked_paras//opers', 'linked_paras//reads'); delete_linked_paras_by_uplinks('inline', $ids);
	_main_::depend('linked_picts//opers', 'linked_picts//reads'); delete_linked_picts_by_uplinks('inline', $ids);
	_main_::depend('linked_files//opers', 'linked_files//reads'); delete_linked_files_by_uplinks('inline', $ids);

	// Удаляем тексты на всех языках 
	delete_texts($table, 'inlines', $this->multilang_fields);

	// Удаляем сами записи и чистим файлы от файловых полей.
	_main_::query(null, "delete from `inlines` where `id` in {1}", $ids);
	foreach ($table as $row) $this->handle_uploads_cleanly($row);
}

function handle_uploads_cleanly (&$data)
{
}

function handle_uploads_temporarily (&$data)
{
}

function handle_uploads_persistently (&$data)
{
}

function remember (&$data)
{
	$this->handle_uploads_temporarily($data);
}


function select_by_ids (&$dat, $ids, $required = null, $details = null)
{
	if (!is_array($ids)) $ids = (array) $ids;
	$dat = !count($ids) ? array() : _main_::query('inline', "
		select	I.*
		from	`inlines` as I
		where	I.`id` in {1}
		", $ids);
	if ($required && !count($dat))
		throw new exception_bl('No such record (by id).', 'inline_absent', 'absent');

	fill_texts($dat,$this->multilang_fields);
	$this->select_details($dat, $details);
}

function select_for_linked (&$dat, $id, $required = null, $details = null)
{
        _main_::depend("multilang");

	$dat = (!$id) ? array() : _main_::query('inline', "
		select	I.*
		from	`inlines` as I
		where	I.`id` = {1}
		", $id);
	if ($required && !count($dat))
		throw new exception_bl('No such record (by id).', 'inline_absent', 'absent');

	fill_texts($dat,$this->multilang_fields);
}


function select_by_labels (&$dat, $labels, $details = null)
{
        _main_::depend("multilang");

	if (!is_array($labels)) $labels = (array) $labels;
	$dat = !count($labels) ? array() : _main_::query('inline', "
		select	I.*
		from	`inlines` as I
		where	I.`label` in {1}
		", $labels);
	fill_texts($dat,$this->multilang_fields);
	$this->select_details($dat, $details);
}

function select_all_words (&$dat, $details = null)
{
        _main_::depend("multilang");

	$dat = _main_::query('inline', "
		select	I.*
		from	`inlines` as I
		where	I.`group` = 'words'
		");
	fill_texts($dat,$this->multilang_fields);
	$this->select_details($dat, $details);
}

function select_for_admin (&$dat, $filters, $sorters, $pager, $details = null)
{
	$where_clause = convert_filters_to_sql_where_clause($filters, 'I', null, 'true');
	$order_clause = convert_sorters_to_sql_order_clause($sorters, 'I',$this->multilang_fields);
	list($select_clause, $join_clause) = join_texts($this->multilang_fields,'I');

	$dat = _main_::query('inline', "
		select	I.*
		,	{$select_clause}
		from	`inlines` as I
		{$join_clause}
		where	{$where_clause}
		order	by {$order_clause}
		");
	$this->select_details($dat, $details);
}

function select_by_words (&$dat, $words, $details = null)
{
	// Без сортировки! Так как сортируем средствами XSLT (у нас в итоге слияния разных типов данных).
	// Убрали прицепленные блоки (для скорости - их нет потому что), но общую структуру сохранили от других сущностей.
	_main_::depend('sql');
	search_clauses($where, $relat, $words, array(
		array('field'=>'I.`content`', 'weight'=>0.75),
		array('field'=>'LP.`name`  ', 'weight'=>0.30),
		array('field'=>'LP.`text`  ', 'weight'=>0.20),
		));
	$dat = !count($words) ? array() : _main_::query('inline', "
		select	I.*
		from	(
				select	I.*
				,	{$relat} as `relativity`
				from	`inlines` I
				left	join `linked_paras` LP on (LP.`uplink_type` = 'inline' and LP.`uplink_id` = I.`id`)
				where	{$where} and I.`search_url` is not null
				group	by I.`id`
				order	by null
			) I
		");
	$this->select_details($dat, $details);
}

function select_details (&$struct, $details = null)
{
	_main_::depend('details');
	select_details_oop('inlines',$struct, $details, array(
//FAKE		'linked_files'	=> 'select_linked_files',
		'linked_paras'	=> 'select_linked_paras',
//FAKE		'linked_picts'	=> 'select_linked_picts',
		));
}

function select_linked_paras (&$struct, $details = null) { _main_::depend('merges', 'linked_paras//reads'); select_linked_paras_by_uplinks($dat, 'inline', get_fields($struct, 'id')); merge_subtable_as_array($struct, $dat, 'linked_paras', 'uplink_id', 'id'); }
function select_linked_picts (&$struct, $details = null) { _main_::depend('merges', 'linked_picts//reads'); select_linked_picts_by_uplinks($dat, 'inline', get_fields($struct, 'id')); merge_subtable_as_array($struct, $dat, 'linked_picts', 'uplink_id', 'id'); }
function select_linked_files (&$struct, $details = null) { _main_::depend('merges', 'linked_files//reads'); select_linked_files_by_uplinks($dat, 'inline', get_fields($struct, 'id')); merge_subtable_as_array($struct, $dat, 'linked_files', 'uplink_id', 'id'); }


}
?>