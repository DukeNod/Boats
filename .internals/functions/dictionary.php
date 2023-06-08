<?php
// Универсальный словарь/справочник.
// Версия 2.0 (многоязычная)

_main_::depend('multilang');

Class Dictionary {
	var $table;
	var $essence;
	var $outfield;

	function __construct($table,$outfield,$essence='')
	{		
		$this->table=$table;
		$this->outfield=$outfield;
		$this->essence=($essence)?$essence:$table;
		$this->multilang_fields = array('name');
		$this->multilang_fields_select = $this->multilang_fields;
	}

################## COMMON ####################################

function fetch_config ()
{
	_main_::depend('configs');
	$fields = array();
	return config_for_module($this->table, $fields);
}

function fetch_enums ()
{
	$enums = array('@for' => $this->table);

	_main_::put2dom('enums', $enums);
	return $enums;
}

################## FORMS ####################################

function form_posted (&$action = null)
{
	_main_::depend('forms');
	$result = array();

	// Always posted fields (text/password/textarea/select/radio/...)
	$fields = array('name');
	fields_fill($result, $fields); 
	fields_find($result, $fields);

	// Conditionally posted fields (checkbox)
	$fields = array();
	fields_fill($result, $fields, $action !== null ? 0 : null); 
	fields_find($result, $fields);

	// Full-text fields for auto-typographing.
	$fields = array('name');
	fields_typograph($result, $fields);

	return $result;
}

function prepare (&$errors, &$data, $config, $enums)
{
}

function validate (&$errors, &$data, $config, $enums, $ignore_uploads = false)
{
	_main_::depend('validations', 'merges');

	validate_required($errors, $data, 'name');

	if (!$ignore_uploads)
	{
	}
}

function predelete (&$errors, &$data, $config, $enums)
{
}

################## OPERS ####################################

function toggle (&$errors, &$data, &$id, $field, $value)
{
	update_texts($data, $this->table, $this->multilang_fields);

	$field = _main_::sql_field($field);
	try { _main_::query(null, "
		update 	`{$this->table}`
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
		update 	`{$this->table}`
		set	`name`		= {02}
		where	`id` = {1}
		", $id,
		$data['name'],
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
		insert 	into `{$this->table}`
		set	`name`		= {02}
		", null,
		$data['name'],
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

	/*
	// Удаляем дочерние элементы (неявно вместе со всеми их файлами и под-дочерними элементами).
	_main_::depend('linked_paras//opers', 'linked_paras//reads'); delete_linked_paras_by_uplinks('car_brand', $ids);
	_main_::depend('linked_picts//opers', 'linked_picts//reads'); delete_linked_picts_by_uplinks('car_brand', $ids);
	_main_::depend('linked_files//opers', 'linked_files//reads'); delete_linked_files_by_uplinks('car_brand', $ids);
	 */

	// Удаляем тексты на всех языках 
	delete_texts($table, $this->table, $this->multilang_fields);

	// Удаляем сами записи и чистим файлы от файловых полей.
	_main_::query(null, "delete from `{$this->table}` where `id` in {1}", $ids);
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



################## READS ####################################

function select_by_ids (&$dat, $ids, $required = null, $details = null)
{
	if (!is_array($ids)) $ids = (array) $ids;
	$dat = !count($ids) ? array() : _main_::query($this->outfield, "
		select	CB.*
		from	`{$this->table}` as CB
		where	CB.`id` in {1}
		", $ids);
	if ($required && !count($dat))
		throw new exception_bl('No such record (by id).', $this->outfield.'_absent', 'absent');

	fill_texts($dat,$this->multilang_fields);
	$this->select_details($dat, $details);
}

function select_name_by_id ($id)
{
	$dat = (is_numeric($id)&&$id>0) ? _main_::query(null, "
		select	`name`
		from	`{$this->table}`
		where	`id` = {1}
		", $id):array();
	fill_texts($dat,$this->multilang_fields);
	$dat=array_shift($dat);
	return $dat['name'];
}

function select_for_admin (&$dat, $filters, $sorters, &$pager, $details = null)
{
	$where_clause = convert_filters_to_sql_where_clause($filters, 'CB', null, 'true');
	$order_clause = convert_sorters_to_sql_order_clause($sorters, 'CB');
//	$limit_clause = convert_pager_to_sql_limit_clause  ($pager);
        $limit_clause=$pager->limit();
	$dat = _main_::query($this->outfield, "
		select SQL_CALC_FOUND_ROWS CB.*
		from	`{$this->table}` as CB
		where	{$where_clause}
		order	by {$order_clause}
		{$limit_clause}
		");
	$pager->getTotal();
	//$pager['count']=get_selected_count();
	fill_texts($dat,$this->multilang_fields);
	$this->select_details($dat, $details);
}

function select_for_select (&$dat, $details = null)
{
	$dat = _main_::query($this->outfield, "
		select	CB.*
		from	`{$this->table}` as CB
		order	by CB.`name` asc, CB.`id` asc
		");
	fill_texts($dat,$this->multilang_fields);
	$this->select_details($dat, $details);
}

function select_details (&$struct, $details = null)
{
}

}
?>
