<?php
_main_::depend('multilang');

class Subscriber_groups
{
	public $table;
	public $essence;
	public $outfield;
	public $tree = array();
	public $tree_helper;
	public $menu = null;
	

	public function __construct()
	{
		_main_::depend('tree_class');
		$this->table='subscriber_groups';
		$this->essence='subscriber_groups';
		$this->outfield='group';
		$this->multilang_fields=array();
	}
################## COMMON ####################################

function fetch_config()
{
	_main_::depend('configs');
	$fields = array();
	return config_for_module($this->essence, $fields);
}

function fetch_enums ($domain = null)
{
	$enums = array('@for' => $this->essence);

	$this->enumerate_siblings($enums['siblings'], $domain);

	_main_::put2dom('enums', $enums);

	return $enums;
}

################## ENUMS ####################################

function enumerate_siblings (&$dat)
{
	$dat = _main_::query($this->outfield, "
		select	`id`, `name`, `position`
		from	`{$this->table}`
		order	by `position` asc, `id` asc
		");
	fill_texts($dat,$this->multilang_fields);
}

################## FORMS ####################################

function form_posted ($action = null)
{
	$result = array();
	_main_::depend('forms');

	// Always posted fields (text/password/textarea/select/radio/...)
	$fields = array('position', 'name');
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

function validate (&$errors, &$data, $config, $enums, $ignore_uploads = false, $same_parent = false)
{
	_main_::depend('validations', 'merges');
	
	validate_required($errors, $data, 'position'  ) && validate_position($errors, $data, 'position', get_fields($enums['siblings'], 'id'), false);
	validate_required($errors, $data, 'name'      );
}

function predelete (&$errors, &$data, $config, $enums)
{
	_main_::depend('validations');
	validate_prohibit($errors, $data, "subscribers");
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
	update_texts($data, $this->table, $this->multilang_fields);

	try { _main_::query(null, "
		update 	`{$this->table}`
		set	`position`	= {02}
		,	`name`		= {03}
		where	`id` = {1}
		", $id,
		$this->parse_position($data['position']),
		$data['name'],
		null);

		$this->handle_uploads_persistently($data);
		$this->reorder();
	}
	catch (exception_db_unique $exception) { $this->handle_uploads_temporarily($data); _main_::depend('validations'); validate_add_error($errors, '', 'duplicate'); }
	catch (exception           $exception) { $this->handle_uploads_temporarily($data); throw $exception; }
}

function insert (&$errors, &$data, &$id)
{
	insert_texts($data, $this->multilang_fields);

	try { $id = _main_::query(null, "
		insert 	into `{$this->table}`
		set	`position`	= {02}
		,	`name`		= {03}
		", null,
		$this->parse_position($data['position']),
		$data['name'],
		null);

		$this->handle_uploads_persistently($data);
		$this->reorder();
	}
	catch (exception_db_unique $exception) { $this->handle_uploads_temporarily($data); _main_::depend('validations'); validate_add_error($errors, '', 'duplicate'); }
	catch (exception           $exception) { $this->handle_uploads_temporarily($data); throw $exception; }
}

function delete (&$errors, &$data, &$id)
{
	if ($data !== null) $dat = array($data); else
	$this->select_by_ids($dat, $id);
	$this->delete_in_table($dat);
	$this->reorder();
}

function delete_in_table ($table)
{
	_main_::depend('merges');
	$ids = get_fields($table, 'id');

	// Удаляем дочерние элементы (неявно вместе со всеми их файлами и под-дочерними элементами).
	_main_::depend('linked_paras//opers', 'linked_paras//reads'); delete_linked_paras_by_uplinks($this->outfield, $ids);
	_main_::depend('linked_picts//opers', 'linked_picts//reads'); delete_linked_picts_by_uplinks($this->outfield, $ids);
	_main_::depend('linked_files//opers', 'linked_files//reads'); delete_linked_files_by_uplinks($this->outfield, $ids);

	// Удаляем тексты на всех языках 
	delete_texts($table, $this->table, $this->multilang_fields);

	// Удаляем сами записи и чистим файлы от файловых полей.
	_main_::query(null, "delete from `{$this->table}` where `id` in {1}", $ids);
	foreach ($table as $row) $this->handle_uploads_cleanly($row);
}

function moveup(&$errors, &$data, $id)
{
	_main_::query(null, "update `{$this->table}` set `position` = (@position := `position` - 1) where `id` = {1}                           ", $id);
	_main_::query(null, "update `{$this->table}` set `position` = (             `position` + 1) where `id`<> {1} and `position` = @position", $id);
}

function movedn(&$errors, &$data, $id)
{
	_main_::query(null, "update `{$this->table}` set `position` = (@position := `position` + 1) where `id` = {1}                           ", $id);
	_main_::query(null, "update `{$this->table}` set `position` = (             `position` - 1) where `id`<> {1} and `position` = @position", $id);
}

function reorder()
{
	_main_::query(null, "select @position := 0");
	_main_::query(null, "update `{$this->table}` set `position` = (@position := @position + 1) order by `position` asc, `id` asc", null);
}

function parse_position ($position)
{
	_main_::depend('sql');
	return parse_position($position, "`{$this->table}`", '`position`');
}

function handle_uploads_cleanly (&$data)
{
}

function handle_uploads_temporarily (&$data)
{
}

function handle_uploads_persistently (&$data)
{
#	_main_::depend('uploads');
#	handle_upload_persistently($data, 'imag' , _config_::$dir_for_linked . 'collections/imag/' , _config_::$tmp_for_linked);	
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
		select	C.*
		from	`{$this->table}` as C
		where	C.`id` in {1}
		order by `position`
		", $ids);
	if ($required && !count($dat))
		throw new exception_bl('No such record (by id).', 'record_absent', 'absent');

	fill_texts($dat,$this->multilang_fields);
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

	fill_texts($dat,$this->multilang_fields);
}

function select_for_admin (&$dat, $filters, $sorters, $pager, $details = null)
{
	$where_clause = convert_filters_to_sql_where_clause($filters, 'C', null, 'true');
	$order_clause = convert_sorters_to_sql_order_clause($sorters, 'C', null, $this->multilang_fields);
	$limit_clause = convert_pager_to_sql_limit_clause  ($pager  );
	list($select_clause, $join_clause) = join_texts($this->multilang_fields,'C');
	if ($select_clause) $select_clause = ",	$select_clause";

	$dat = _main_::query($this->outfield, "
		select	C.*
		{$select_clause}
		from	`{$this->table}` as C
		{$join_clause}
		where	{$where_clause}
		order	by {$order_clause}
		{$limit_clause}
		");
	$this->select_details($dat, $details);
}


function select_for_read (&$dat, $details = null)
{
	$dat = _main_::query($this->outfield, "
		select	C.*
		from	`{$this->table}`	as C
		order	by C.`position` asc, C.`id` asc
		");

	fill_texts($dat,$this->multilang_fields);
	$this->select_details($dat, $details);
}

function select_by_subscribers(&$dat, $subscribers, $details = null)
{
        if (!is_array($subscribers)) $subscribers = ($subscribers === null) ? null : array($subscribers);

	$dat = (!$subscribers) ? array() : _main_::query($this->outfield, "
		select	G.*
		,	G2S.`subscriber`
		from	`subscriber_groups` as G
		inner	join `_groups2subscribers_` G2S on (G2S.`group` = G.`id`)
		where	G2S.`subscriber` in {1}
		", $subscribers);
}

function select_by_mailer_tasks(&$dat, $tasks, $details = null)
{
        if (!is_array($tasks)) $tasks = ($tasks === null) ? null : array($tasks);

	$dat = (!$tasks) ? array() : _main_::query($this->outfield, "
		select	G.*
		,	G2T.`task`
		,	if (G.`id` is null, 0, G.`id`) as `id`
		from	`_groups2mailer_tasks_` G2T
		left	join `subscriber_groups` as G on (G2T.`group` = G.`id`)
		where	G2T.`task` in {1}
		", $tasks);
}

function select_details (&$struct, $details = null)
{
	_main_::depend('details');
	select_details_oop($this->essence,$struct, $details, array(
//		'linked_files'	=> 'select_linked_files',
//		'linked_paras'	=> 'select_linked_paras',
//		'linked_picts'	=> 'select_linked_picts',
//		'subscribers'	=> 'select_subscribers',
	));
}

function select_linked_paras (&$struct, $details = null) { _main_::depend('merges', 'linked_paras//reads'); select_linked_paras_by_uplinks($dat, $this->outfield, get_fields($struct, 'id'), $details); merge_subtable_as_array($struct, $dat, 'linked_paras'       , 'uplink_id', 'id'); }
function select_linked_picts (&$struct, $details = null) { _main_::depend('merges', 'linked_picts//reads'); select_linked_picts_by_uplinks($dat, $this->outfield, get_fields($struct, 'id'), $details); merge_subtable_as_array($struct, $dat, 'linked_picts'       , 'uplink_id', 'id'); }
function select_linked_files (&$struct, $details = null) { _main_::depend('merges', 'linked_files//reads'); select_linked_files_by_uplinks($dat, $this->outfield, get_fields($struct, 'id'), $details); merge_subtable_as_array($struct, $dat, 'linked_files'       , 'uplink_id', 'id'); }
function select_subscribers  (&$struct, $details = null) { _main_::depend('merges',  'subscribers//reads'); select_subscribers_by_groups  ($dat, $this->outfield, get_fields($struct, 'id'), $details); merge_subtable_as_array($struct, $dat, 'subscribers'        , 'group'    , 'id'); }

}
	
?>