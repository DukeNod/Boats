<?php
class Langs
{
	public $table;
	public $essence;
	public $outfield;
	

	public function __construct(){
		$this->table='langs';
		$this->essence='langs';
		$this->outfield='lang';
	}
################## COMMON ####################################

function fetch_config()
{
	_main_::depend('configs');
	$fields = array();
	return config_for_module($this->essence, $fields);
}

function fetch_enums()
{
	$enums = array('@for' => $this->essence);

	$this->enumerate_siblings($enums['siblings']);

	_main_::put2dom('enums', $enums);
	return $enums;
}

################## ENUMS ####################################

function enumerate_siblings (&$dat)
{
	$dat = _main_::query($this->outfield, "
		select	`id`, `name`
		from	`{$this->table}`
		order	by `id` asc
		");
}

################## FORMS ####################################

function form_posted ($action = null)
{
	$result = array();
	_main_::depend('forms');

	// Always posted fields (text/password/textarea/select/radio/...)
	$fields = array('name', 'code');
	fields_fill($result, $fields); 
	fields_find($result, $fields);

	// Conditionally posted fields (checkbox)
	$fields = array();
	fields_fill($result, $fields, $action !== null ? 0 : null); 
	fields_find($result, $fields);

	// Full-text fields for auto-typographing.
	$fields = array();
	fields_typograph($result, $fields);
	
	// Fields with uploaded files.
	#fields_file($result, 'imag' , _config_::$tmp_for_linked, false, true); //  , _config_::$dir_for_linked . 'collections/imag/'

	return $result;
}

function prepare (&$errors, &$data, $config, $enums)
{
}

function validate (&$errors, &$data, $config, $enums, $ignore_uploads = false, $same_parent = false)
{
	_main_::depend('validations', 'merges');

	validate_required($errors, $data, 'name' );
	validate_required($errors, $data, 'code' );

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
	try { _main_::query(null, "
		update 	`{$this->table}`
		set	`name`		= {02}
		,	`code`		= {03}
		where	`id` = {1}
		", $id,
		$data['name'],
		$data['code'],
		null);

	}
	catch (exception_db_unique $exception) { $this->handle_uploads_temporarily($data); _main_::depend('validations'); validate_add_error($errors, '', 'duplicate'); }
	catch (exception           $exception) { $this->handle_uploads_temporarily($data); throw $exception; }
}

function insert (&$errors, &$data, &$id)
{
	try { $id = _main_::query(null, "
		insert 	into `{$this->table}`
		set	`name`		= {02}
		,	`code`		= {03}
		", null,
		$data['name'],
		$data['code'],
		null);

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

	// Удаляем сами записи и чистим файлы от файловых полей.
	_main_::query(null, "delete from `{$this->table}` where `id` in {1}", $ids);
}


function remember (&$data)
{
}

################## READS ####################################

function select_by_ids (&$dat, $ids, $required = null, $details = null)
{
	if (!is_array($ids)) $ids = (array) $ids;
	$dat = !count($ids) ? array() : _main_::query($this->outfield, "
		select	C.*
		from	`{$this->table}` as C
		where	C.`id` in {1}
		", $ids);
	if ($required && !count($dat))
		throw new exception_bl('No such record (by id).', 'record_absent', 'absent');
	$this->select_details($dat, $details);
}

function select_for_linked (&$dat, $id, $required = null)
{
	$dat = (!$id) ? array() : _main_::query($this->outfield, "
		select	C.*
		from	`{$this->table}` as C
		where	C.`id` = {1}
		", $id);
	if ($required && !count($dat))
		throw new exception_bl('No such record (by id).', 'record_absent', 'absent');
}

function select_for_admin (&$dat, $filters, $sorters, $pager, $details = null)
{
	$where_clause = convert_filters_to_sql_where_clause($filters, 'C', null, 'true');
	$order_clause = convert_sorters_to_sql_order_clause($sorters, 'C');
	$limit_clause = convert_pager_to_sql_limit_clause  ($pager  );
	$dat = _main_::query($this->outfield, "
		select	C.*
		from	`{$this->table}` as C
		where	{$where_clause}
		order	by {$order_clause}
		{$limit_clause}
		");
}

function select_for_menu (&$dat, $mr=null, $details = null)
{
	$dat = _main_::query($this->outfield, "
		select	C.*
		from	`{$this->table}` as C
		order	by C.`code` asc, C.`id` asc
		");
}

function select_for_read (&$dat, $details = null)
{
	$dat = _main_::query($this->outfield, "
		select	C.*
		from	`{$this->table}` as C
		order	by C.`id` asc
		");
}


function select_details (&$struct, $details = null)
{
	_main_::depend('details');
	select_details_oop($this->essence,$struct, $details, array(
		'regions'	=> 'select_regions'
		));
}

function select_regions (&$struct, $details = null) { _main_::depend('merges'); $m=_main_::fetchModule('regions'); $m->select_by_domains ($dat, get_fields($struct, 'id'), $details); merge_subtable_as_array($struct, $dat, 'regions', 'domain', 'id'); }

}
	
?>