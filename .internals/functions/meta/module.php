<?php
Class Meta {
	var $table;
	var $essence;
	var $outfield;
	var $uplink;

	function __construct(){
		$this->table='meta';
		$this->essence='meta';
		$this->outfield='meta';
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

	_main_::put2dom('enums', $enums);
	return $enums;
}

################## ENUMS ####################################

################## FORMS ####################################

function form_posted ($action = null)
{
	_main_::depend('forms');
	$result = array();

	// Always posted fields (text/password/textarea/select/radio/...)
	$fields = array('name', 'url', 'title', 'description', 'keywords', 'counters', 'footer', 'h1');
	fields_fill($result, $fields); 
	fields_find($result, $fields);

	// Conditionally posted fields (checkbox)
	$fields = array();
	fields_fill($result, $fields, $action !== null ? 0 : null); 
	fields_find($result, $fields);

	// Full-text fields for auto-typographing.
	$fields = array();
	fields_typograph($result, $fields);

	return $result;
}

function prepare (&$errors, &$data, $config, $enums)
{
}

function validate (&$errors, &$data, $config, $enums, $ignore_uploads = false)
{
	_main_::depend('validations', 'merges');

	validate_optional($errors, $data, 'name' );
	validate_required($errors, $data, 'url' );
	validate_optional($errors, $data, 'title');
	validate_optional($errors, $data, 'description');
	validate_optional($errors, $data, 'keywords');
	validate_optional($errors, $data, 'counters');
	validate_optional($errors, $data, 'footer');	
	validate_optional($errors, $data, 'h1');	

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
		,	`url`		= {03}
		,	`title`		= {04}
		,	`description`	= {05}
		,	`keywords`	= {06}
		,	`counters`	= {07}
		,	`footer`	= {08}
		,	`h1`		= {09}
		where	`id` = {1}
		", $id,
		$data['name'],
		$data['url'],
		$data['title'],
		$data['description'],
		$data['keywords'],
		$data['counters'],
		$data['footer'],
		$data['h1'],
		null);

		$this->handle_uploads_persistently($data);
	}
	catch (exception_db_unique $exception) { $this->handle_uploads_temporarily($data); _main_::depend('validations'); validate_add_error($errors, '', 'duplicate'); }
	catch (exception           $exception) { $this->handle_uploads_temporarily($data); throw $exception; }
}

function insert (&$errors, &$data, &$id)
{
	try { $id = _main_::query(null, "
		insert 	into `{$this->table}`
		set	`name`		= {02}
		,	`url`		= {03}
		,	`title`		= {04}
		,	`description`	= {05}
		,	`keywords`	= {06}
		,	`counters`	= {07}
		,	`footer`	= {08}
		,	`h1`		= {09}
		", null,
		$data['name'],
		$data['url'],
		$data['title'],
		$data['description'],
		$data['keywords'],
		$data['counters'],
		$data['footer'],
		$data['h1'],
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
		select	M.*
		from	`{$this->table}` as M
		where	M.`id` in {1}
		", $ids);
	if ($required && !count($dat))
		throw new exception_bl('No such record (by id).', 'news_absent', 'absent');
	$this->select_details($dat, $details);
}

function select_for_linked (&$dat, $id, $required = null, $details = null)
{
	$dat = (!$id) ? array() : _main_::query($this->outfield, "
		select	M.*
		from	`{$this->table}` as M
		where	M.`id` = {1}
		", $id);
	if ($required && !count($dat))
		throw new exception_bl('No such record (by id).', 'news_absent', 'absent');
}

function select_for_admin (&$dat, $filters, $sorters, $pager, $details = null)
{
	$where_clause = convert_filters_to_sql_where_clause($filters, 'M', null, 'true');
	$order_clause = convert_sorters_to_sql_order_clause($sorters, 'M');
	$limit_clause = convert_pager_to_sql_limit_clause  ($pager  );
	$dat = _main_::query($this->outfield, "
		select	M.*
		from	`{$this->table}` as M
		where	{$where_clause}
		order	by {$order_clause}
		{$limit_clause}
		");
	$this->select_details($dat, $details);
}

function select_where_latest (&$dat, $limit, $details = null)
{
	$limit = (integer) $limit;
	$limit = $limit ? "limit {$limit}" : "";
	$dat = _main_::query($this->outfield, "
		select	M.*
		from	`{$this->table}` as M
		order	by M.`ts` desc, M.`id` desc
		{$limit}
		");
	$this->select_details($dat, $details);
}

function select_by_url (&$dat, $url, $details = null)
{
	$dat = _main_::query($this->outfield, "
		select	M.*
		from	`{$this->table}` as M
		where	`url` = {1}
		", $url);
	$this->select_details($dat, $details);
}

function select_for_read (&$dat, $page, $size, &$pager, $details = null)
{
	$dat = _main_::query(null, "select count(*) from `{$this->table}`");
	$page = (integer) $page;
	$size = (integer) $size;
	$count = array_shift(array_shift($dat)); if (!$size) $size = $count;
	$pages = $size ? floor($count / $size) + ($count % $size ? 1 : 0) : 1;
	if ($page < 1     ) $page = 1;
	if ($page > $pages) $page = $pages;
	$offset = max(0, ($page - 1) * $size);
	$cycle = array(); for ($p = 1; $p <= $pages; $p++) $cycle['page:'.$p] = $p;
	$pager = compact('page', 'size', 'count', 'pages', 'offset', 'cycle');
	$limit = "limit {$size} offset {$offset}";
	$dat = _main_::query($this->outfield, "
		select	M.*
		from	`{$this->table}` as M
		order	by M.`ts` desc, M.`id` desc
		{$limit}
		");
	$this->select_details($dat, $details);
}


function select_details (&$struct, $details = null)
{
	_main_::depend('details');
	select_details_oop($this->essence,$struct, $details, array(
//		'linked_files'	=> 'select_linked_files',
		'linked_paras'	=> 'select_linked_paras',
//		'linked_picts'	=> 'select_linked_picts',
		));
}

function select_linked_paras (&$struct, $details = null) { _main_::depend('merges', 'linked_paras//reads'); select_linked_paras_by_uplinks($dat, $this->outfield, get_fields($struct, 'id'), $details); merge_subtable_as_array($struct, $dat, 'linked_paras', 'uplink_id', 'id'); }
function select_linked_picts (&$struct, $details = null) { _main_::depend('merges', 'linked_picts//reads'); select_linked_picts_by_uplinks($dat, $this->outfield, get_fields($struct, 'id'), $details); merge_subtable_as_array($struct, $dat, 'linked_picts', 'uplink_id', 'id'); }
function select_linked_files (&$struct, $details = null) { _main_::depend('merges', 'linked_files//reads'); select_linked_files_by_uplinks($dat, $this->outfield, get_fields($struct, 'id'), $details); merge_subtable_as_array($struct, $dat, 'linked_files', 'uplink_id', 'id'); }
}

?>