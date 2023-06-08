<?php
_main_::depend('types_class');

Class Base_Module
{
	var $table;
	var $essence;
	var $outfield;
	var $multilang_fields;
	var $multilang_fields_select;
	var $fields;
	var $order_field;
	var $name_field;
	var $essence_title;
	var $update_details;
	var $admin_list_details;
	var $admin_filters;
	var $admin_sorters;
	var $on_page;
	var $return_to_list;
	var $isInsert;


	function __construct($table, $outfield, $essence_title, $essence='')
	{		
		$this->table = $table;
		$this->outfield = $outfield;
		$this->essence = ($essence) ? $essence : $table;
		$this->essence_title = $essence_title;
		$this->multilang_fields = array();
		$this->multilang_fields_select = $this->multilang_fields;
		$this->name_field = 'name';
		$this->update_details = true;
		$this->admin_list_details = null;
		$this->return_to_list = false;
	}

	// make_field('field_type', 'field_name', [required], [defauilt value], [fields = array()])
	function make_field()
	{
		$args  = func_get_args();
		$class  = array_shift($args);
		$name  = array_shift($args);
		$required = array_shift($args);
		$value = array_shift($args);
		$fields = array_shift($args);

		$this->fields[$name] = new $class($name, $value, $required);

		$this->fields[$name]->module = $this;

		if ($fields)
		foreach($fields as $f=>$v)
		{
			$this->fields[$name]->{$f} = $v;
		}
	}

	// make_filter(filter_type, filter_name, filter_title, defauilt value, [fields = array()])
	function make_filter($filter_type, $filter_name, $filter_title, $defauilt = '', $fields = array())
	{
		$this->admin_filters[$filter_name] = new $filter_type($filter_name, $defauilt, false);

		$this->admin_filters[$filter_name]->module = $this;
		$this->admin_filters[$filter_name]->title = $filter_title;

		if ($fields)
		foreach($fields as $f=>$v)
		{
			$this->admin_filters[$filter_name]->{$f} = $v;
		}
	}

	function fields2dom(&$data)
	{
	        $fields = array();

	    $i = 0;
		foreach($this->fields as $f=>$v)
		{
			$i++;
			$key = (isset($v->template) && $v->template) ? $v->template.":$i" : get_class($v).":$i";
			$fields[$key] = clone $v->field2dom($data);
			unset($fields[$key]->module); // удаляем рекурсивную ссылку на родительский модуль
		}

		$vars = get_object_vars($this);
		
		foreach($vars as $f=>$v)
		{
		        if ($f != 'fields' and $f != 'admin_filters' and $f != 'unique_keys' and $f != 'update_details') $return[$f] = $v;
		}

		$return['fields'] = ($fields) ? $fields : null;

		return $return;
	}

################## COMMON ####################################

function get_filters()
{
	$this->filter_fields = $filters = array();

	if ($this->admin_filters)
	{
		foreach($this->admin_filters as $f=>$fl) $fl->prepare_filter($filters); //$filters[$f] = $fl->value;

		$filters = get_requested_filters($filters);
		
		foreach($this->admin_filters as $f=>$fl) $fl->set_filter($errors, $filters); // зачем?

		foreach($this->admin_filters as $f=>$v)
		{
			$key = get_class($v).":$f";
			$this->filter_fields[$key] = clone $v->field2dom($filters);

			unset($this->filter_fields[$key]->module); // удаляем рекурсивную ссылку на родительский модуль
		}

		//_main_::put2dom('filter_fields', $filter_fields);
	}

	return $filters;
}

function fetch_config()
{
	_main_::depend('configs');
	$fields = array();
	return config_for_module($this->essence, $fields);
}

function fetch_enums (&$enums, &$data)
{
	$enums = array('@for' => $this->essence);

	foreach($this->fields as $f=>$v) $v->fetch_enums($enums, $data);

	_main_::put2dom('enums', $enums);
	return $enums;
}

function defs ()
{
        $return = array();
	foreach($this->fields as $f=>$v) if ($v->value) $return[$f] = $v->value;

	return $return;
}

################## ENUMS ####################################

################## FORMS ####################################

function form_posted (&$action = null)
{
	$result = array();
	_main_::depend('forms');

	foreach($this->fields as $f=>$v) $v->form_posted($result, $action);
	
	return $result;
}

function form_posted_multi ($action = null)
{
	$result = array();
	_main_::depend('forms');

	$fields = array('items');
	fields_fill($result, $fields, $action !== null ? array() : null); 
	fields_find($result, $fields);

	//dom-fixes
	if ($result['items'])
	{
		$tmp = array();
		foreach ($result['items'] as $val)
		{
			if ((is_numeric($val)) && $val)
				$tmp['item:'.count($tmp)] = $val;
		}
		$result['items'] = $tmp;
	}

	return $result;
}

function prepare (&$errors, &$data, $config, $enums)
{
	foreach($this->fields as $f=>$v) $v->prepare($errors, $data, $config, $enums);
}

function validate (&$errors, &$data, $config, $enums, $ignore_uploads = false)
{
	_main_::depend('validations', 'merges');

	foreach($this->fields as $f=>$v) $v->validate($errors, $data, $config, $enums, $ignore_uploads);
}

function predelete (&$errors, &$data, $config, $enums)
{
	foreach($this->fields as $f=>$v) $v->predelete($errors, $data, $config, $enums);
}

################## OPERS ####################################

function toggle (&$errors, &$data, &$id, $field, $value)
{
	update_texts($data, $this->table, $this->multilang_fields);

	$sql = $this->fields[$field]->sql_set($data);

	try { _main_::query(null, "
		update 	`{$this->table}`
		set	{$sql}
		where	`id` = {1}
		", $id);

		if ($field == 'position') $this->reorder();

		#foreach($this->fields as $f=>$v) $v->post_update($id, $data);
		$this->post_update($id, $data);
	}
	catch (exception_db_unique $exception) { $this->handle_uploads_temporarily($data); _main_::depend('validations'); validate_add_error($errors, $this->parce_unique_exception($exception->getMessage()), 'duplicate'); }
	catch (exception           $exception) { $this->handle_uploads_temporarily($data); throw $exception; }
}

function update (&$errors, &$data, &$id, $orig = null)
{	
	update_texts($data, $this->table, $this->multilang_fields);

	$sql = '';
	foreach($this->fields as $f=>$v) if($field = $v->sql_set($data)) $sql .= ','.$field;
	$sql = substr($sql, 1);

	try { _main_::query(null, "
		update 	`{$this->table}`
		set	{$sql}
		where	`id` = {1}
		", $id);

		$this->handle_uploads_persistently($data);
		if ($this->order_field == 'position')
			$this->reorder($data, $orig);

		#foreach($this->fields as $f=>$v) $v->post_update($id, $data, $orig);
		$this->post_update($id, $data, $orig);

	}
	catch (exception_db_unique $exception) { $this->handle_uploads_temporarily($data); _main_::depend('validations'); validate_add_error($errors, $this->parce_unique_exception($exception->getMessage()), 'duplicate'); }
	catch (exception           $exception) { $this->handle_uploads_temporarily($data); throw $exception; }
}

function insert (&$errors, &$data, &$id)
{
	insert_texts($data, $this->multilang_fields);

	$fields = '';
	$values = '';
	foreach($this->fields as $f=>$v)
	{
		if($field = $v->sql_set($data))
		{
			$field = explode(' = ', $field);
			$fields .= ','.$field[0];
			$values .= ','.$field[1];
		}
	}
	
	$fields = substr($fields, 1);
	$values = substr($values, 1);
	
	try { $id = _main_::query(null, "
		insert 	into `{$this->table}` ({$fields})
		values ({$values})
		");

		$this->handle_uploads_persistently($data);
		if ($this->order_field == 'position')
			$this->reorder($data);

		#foreach($this->fields as $f=>$v) $v->post_update($id, $data);
		$this->post_update($id, $data);
	}
	catch (exception_db_unique $exception) { $this->handle_uploads_temporarily($data); _main_::depend('validations'); validate_add_error($errors, $this->parce_unique_exception($exception->getMessage()), 'duplicate'); }
	catch (exception           $exception) { $this->handle_uploads_temporarily($data); throw $exception; }
}

function post_update($id, &$data, &$orig = null)
{
	foreach($this->fields as $f=>$v) $v->post_update($id, $data, $orig);
}

function parce_unique_exception($message)
{
	if (preg_match('|for key \'(\w+)\'|', $message, $matches))
		#return $this->unique_keys[$matches[1]];
		return $matches[1];
	else
		return '';
}

function delete (&$errors, &$data, &$id)
{
	if ($data !== null) $dat = array($data); else
	$this->select_by_ids($dat, $id);
	$this->delete_in_table($dat);
	if ($this->order_field == 'position')
		$this->reorder();
}

function delete_in_table ($table)
{
	_main_::depend('merges');
	$ids = get_fields($table, 'id');

	// Удаляем дочерние элементы (неявно вместе со всеми их файлами и под-дочерними элементами).
	#_main_::depend('linked_paras//opers', 'linked_paras//reads'); delete_linked_paras_by_uplinks($this->outfield, $ids);
	#_main_::depend('linked_picts//opers', 'linked_picts//reads'); delete_linked_picts_by_uplinks($this->outfield, $ids);
	#_main_::depend('linked_files//opers', 'linked_files//reads'); delete_linked_files_by_uplinks($this->outfield, $ids);

	// Удаляем тексты на всех языках 
	delete_texts($table, $this->table, $this->multilang_fields);

	foreach($this->fields as $f=>$v) $v->delete($ids);

	// Удаляем сами записи и чистим файлы от файловых полей.
	_main_::query(null, "delete from `{$this->table}` where `id` in {1}", $ids);
	foreach ($table as $row) $this->handle_uploads_cleanly($row);
}

function moveup (&$errors, &$data, $id)
{
	_main_::query(null, "update `{$this->table}` set `position` = (@position := `position` - 1) where `id` = {1}              ", $id);
	_main_::query(null, "update `{$this->table}` set `position` = (`position` + 1) where `id`<> {1} and `position` = @position", $id);
}

function movedn (&$errors, &$data, $id)
{
	_main_::query(null, "update `{$this->table}` set `position` = (@position := `position` + 1) where `id` = {1}              ", $id);
	_main_::query(null, "update `{$this->table}` set `position` = (`position` - 1) where `id`<> {1} and `position` = @position", $id);
}

function reorder ()
{
	_main_::query(null, "select @position := 0");
	_main_::query(null, "update `{$this->table}` set `position` = (@position := @position + 1) order by `position` asc, `id` asc", null);
}

function parse_position ($position)
{
	_main_::depend('sql');
	return parse_position($position, "`{$this->table}`", '`position`');//NB: no parent, nor where-clause
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
	
	$sql = '';
	foreach($this->fields as $f=>$v) if ($str = $v->sql_list('A')) $sql .= ','.$str;
	$sql = substr($sql, 1);

	$dat = !count($ids) ? array() : _main_::query($this->outfield, "
		select	A.id, {$sql}
		from	`{$this->table}` as A
		where	A.`id` in {1}
		", $ids);

	if ($required && !count($dat))
		throw new exception_bl('No such record (by id).', $this->outfield.'_absent', 'absent');
	fill_texts($dat,$this->multilang_fields);

	$this->select_details($dat, $details);
}

function select_by_field (&$dat, $field, $ids, $required = null, $details = null)
{
	if (!is_array($ids)) $ids = (array) $ids;
	
	if (!preg_match('/^[\w\d\_\-]+$/ui', $field))
	{
		throw new exception_bl('Select field wrong.', $field.'_wrong', 'wrong');
	}
	
	$sql = '';
	foreach($this->fields as $f=>$v) if ($str = $v->sql_list('A')) $sql .= ','.$str;
	$sql = substr($sql, 1);

	$dat = !count($ids) ? array() : _main_::query($this->outfield, "
		select	A.id, {$sql}
		from	`{$this->table}` as A
		where	A.`{$field}` in {1}
		", $ids);

	if ($required && !count($dat))
		throw new exception_bl('No such record (by id).', $this->outfield.'_absent', 'absent');
	fill_texts($dat,$this->multilang_fields);

	$this->select_details($dat, $details);
}

function select_for_linked (&$dat, $id, $required = null, $details = null)
{
	$dat = (!$id) ? array() : _main_::query($this->outfield, "
		select	A.*
		from	`{$this->table}` as A
		where	A.`id` = {1}
		", $id);

	if ($required && !count($dat))
		throw new exception_bl('No such record (by id).', $this->outfield.'_absent', 'absent');

	fill_texts($dat,$this->multilang_fields);
}

function select_for_select (&$dat, $details = null)
{
        reset($this->admin_sorters);
        $key = key($this->admin_sorters);
	$order_clause = convert_sorters_to_sql_order_clause(array($key => $this->admin_sorters[$key]), 'N');

	$dat = _main_::query($this->outfield, "
		select	N.*
		from	`{$this->table}` as N
		order	by {$order_clause}
		");

	fill_texts($dat,$this->multilang_fields);
	$this->select_details($dat, $details);
}

function select_for_admin (&$dat, $filters, $sorters, $pager, $details = null)
{
        $mapping = array();

        if ($this->admin_filters)
	foreach($this->admin_filters as $f=>$v)
	{
		if (isset($v->mapping) && $v->mapping)
			$mapping = array_merge($mapping, $v->mapping);
	}

	$where_clause = convert_filters_to_sql_where_clause($filters, 'A', $mapping, 'true');
	$order_clause = convert_sorters_to_sql_order_clause($sorters, 'A');
	#$limit_clause = convert_pager_to_sql_limit_clause  ($pager);
	$limit=$pager->limit();
	list($select_clause, $join_clause) = join_texts($this->multilang_fields,'A');
	if ($select_clause) $select_clause = ',	'.$select_clause;

	$sql = '';
	foreach($this->fields as $f=>$v) if ($v->list && !in_array($v->name, $this->multilang_fields)) if ($field = $v->sql_list('A')) $sql .= ','.$field;
	$sql = substr($sql, 1);

	$dat = _main_::query($this->outfield, "
		select	SQL_CALC_FOUND_ROWS A.`id`, {$sql}
		{$select_clause}
		from	`{$this->table}` as A
		{$join_clause}
		where	{$where_clause}
		order	by {$order_clause}
		{$limit}
		");
	$pager->getTotal();
	$this->select_details($dat, $details);
}

function select_details (&$struct, $details = null)
{
        if ($struct && $this->fields) foreach($struct as &$v) foreach($this->fields as $f=>$field) $field->post_select($v);
}

/*
function select_by_words (&$dat, $words, $details = null)
{
	if ($lang===null) $lang=LANG_ID;

	// Без сортировки! Так как сортируем средствами XSLT (у нас в итоге слияния разных типов данных).
	// Убрали прицепленные блоки (для скорости - их нет потому что), но общую структуру сохранили от других сущностей.
	_main_::depend('sql');
	search_clauses_multilang($where, $relat, $join, $select, $words, array(
		array('field'=>' A.`name` ', 'weight'=>1.00, 'multilang'=>true),
		array('field'=>' A.`short` ', 'weight'=>0.50, 'multilang'=>true),
		array('field'=>'LP.`name` ', 'weight'=>0.30),
		array('field'=>'LP.`text` ', 'weight'=>0.20),
		));
	$dat = !count($words) ? array() : _main_::query($this->outfield, "
		select	A.*
		from	(
				select	A.`id`, A.`mr`, A.`position`, A.`last_modified`
				,	{$select}
				,	{$relat} as `relativity`
				from	`{$this->table}` A
				left	join `linked_paras` LP on (LP.`uplink_type` = '{$this->outfield}' and LP.`uplink_id` = A.`id` and LP.`lang_id` = '$lang')
				{$join}
				where	{$where}
				group	by A.`id`
				order	by null
			) A
		");

//	fill_texts($dat,$this->multilang_fields);
	$this->select_details($dat, $details);
}

function select_details (&$struct, $details = null)
{
	_main_::depend('details');
	select_details_oop($this->essence,$struct, $details, array(
		'linked_files'	=> 'select_linked_files',
		'linked_paras'	=> 'select_linked_paras',
		'linked_picts'	=> 'select_linked_picts',
		'items'		=> 'select_items',
		));
}

function select_linked_paras (&$struct, $details = null) { _main_::depend('merges', 'linked_paras//reads'); select_linked_paras_by_uplinks($dat, $this->outfield, get_fields($struct, 'id'), $details); merge_subtable_as_array($struct, $dat, 'linked_paras'       , 'uplink_id', 'id'); }
function select_linked_picts (&$struct, $details = null) { _main_::depend('merges', 'linked_picts//reads'); select_linked_picts_by_uplinks($dat, $this->outfield, get_fields($struct, 'id'), $details); merge_subtable_as_array($struct, $dat, 'linked_picts'       , 'uplink_id', 'id'); }
function select_linked_files (&$struct, $details = null) { _main_::depend('merges', 'linked_files//reads'); select_linked_files_by_uplinks($dat, $this->outfield, get_fields($struct, 'id'), $details); merge_subtable_as_array($struct, $dat, 'linked_files'       , 'uplink_id', 'id'); }
function select_items        (&$struct, $details = null) { _main_::depend('merges'); $m=_main_::fetchModule('items'); $m->select_by_articles($dat		, get_fields($struct, 'id'), $details); merge_subtable_as_array($struct, $dat, 'items_list'         , 'article'  , 'id'); }
*/
}
?>