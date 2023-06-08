<?php
_main_::depend('multilang');

Class Forms_list
{
	var $table;
	var $essence;
	var $outfield;

	function __construct(){
		$this->table = 'forms_list';
		$this->essence = 'forms_list';
		$this->outfield = 'form';
		$this->multilang_fields = array('name');
	}

################## COMMON ####################################

function fetch_config()
{
	_main_::depend('configs');
	$fields = array();
	return config_for_module($this->essence, $fields);
}

function fetch_enums ($services_ids = null, $equipments_ids = null)
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
		select	`id`, `position`
		from	`{$this->table}`
		order	by `position` asc, `id` asc
		");

	fill_texts($dat,$this->multilang_fields);
}

################## FORMS ####################################

function form_posted (&$action = null)
{
	_main_::depend('forms');
	$result = array();

	// Always posted fields (text/password/textarea/select/radio/...)
	$fields = array('mr', 'position', 'name', 'short', 'email', 'sent');
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

	validate_required($errors, $data, 'mr'      ) && validate_mr($errors, $data, 'mr');
	validate_required($errors, $data, 'position') && validate_position($errors, $data, 'position', get_fields($enums['siblings'], 'id'), false);
	validate_required($errors, $data, 'email'   ); // && validate_email($errors, $data, 'email');
	validate_required($errors, $data, 'name'    );
	validate_optional($errors, $data, 'short'   );
	validate_optional($errors, $data, 'sent'    );

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
		set	`position`	= {02}
		,	`name`		= {03}
		,	`mr`		= {04}
		,	`short`		= {05}
		,	`email`		= {06}
		,	`sent`		= {07}
		where	`id` = {1}
		", $id,
		$this->parse_position($data['position']),
		$data['name'],
		$data['mr'],
		$data['short'],
		$data['email'],
		$data['sent'],
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
		,	`mr`		= {04}
		,	`short`		= {05}
		,	`email`		= {06}
		,	`sent`		= {07}
		", null,
		$this->parse_position($data['position']),
		$data['name'],
		$data['mr'],
		$data['short'],
		$data['email'],
		$data['sent'],
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

	// Удаляем тексты на всех языках 
	delete_texts($table, $this->table, $this->multilang_fields);

	_main_::query(null, "delete from `form_fields`   where `form` in {1}", $ids);	

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

function make_form_action(&$form, &$data, &$doc, $action = null, $mailto, $mail_template)
{
        $form->fetch_enums();

	// Определение запрошенных действий и получение присланных данных.
	$config = array();
	$enums = array();
	$errors = array();
//	debug($data);die;
	if ($form->email) $mailto = $form->email;

	// Типичный сценарий операции: подгонка файлов, проверка значений, и либо обращение к базе, либо временное запоминание.
	if (($action !== null)                   )  $form->prepare  ($errors, $data, $config, $enums);
	if (($action === 'do') && !count($errors))  $form->validate ($errors, $data, $config, $enums);
	if (($action === 'do') && !count($errors))  $form->mail     ($errors, $data, $doc, $mailto, $mail_template);
	elseif (($action !== null)               )  $form->remember ($data);

//	debug($data);die;
	// В DOM!
	$dom = compact('action', 'data', 'errors', 'gp_id', 'gp_w', 'gp_h', 'form');
	_main_::put2dom(($action === 'do') && !count($errors) ? 'done' : 'form', $dom);
	_main_::put2dom('fields', $form->fields2dom($data));
}

################## READS ####################################

function get_form_by_mr($mr)
{
	_main_::depend('forms');
	_main_::depend('mail');
	_main_::depend('gp');
	_main_::depend('forms_class');
	_main_::depend('types_class');

	$this->select_by_mrs($dat, $mr, true, true);

	$data = array_shift($dat);

	$i = 0;
	$fields = array();

	foreach($data['fields'] as $v)
	{
	        $type = $v['type'];

	        $fields[$i] = new $type($v['code'], null, ($v['required'] == 1));
	        $fields[$i]->comment = $v['comment']; 
	        $fields[$i]->title = $v['name']; 

		switch($v['type'])
		{
			case 'SelectList': $fields[$i]->table = $v['table'];
			break;
			case 'Select': $fields[$i]->values = $v['values'];
			break;
		}

	        $i++;
	}

	$form = new Forms($fields);
	$form->short =  $data['short'];
	$form->email =  $data['email'];
	$form->sent =  $data['sent'];
	$form->name =  $data['name'];
	$form->mr =  $data['mr'];
	return $form;
}

function select_by_ids (&$dat, $ids, $required = null, $details = null)
{
	if (!is_array($ids)) $ids = (array) $ids;
	$dat = !count($ids) ? array() : _main_::query($this->outfield, "
		select	A.*
		from	`{$this->table}` as A
		where	A.`id` in {1}
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

function select_by_mrs (&$dat, $mrs, $required = null, $details = null)
{
	if (!is_array($mrs)) $mrs = (array) $mrs;
	$dat = !count($mrs) ? array() : _main_::query($this->outfield, "
		select	A.*
		from	`{$this->table}` as A
		where	A.`mr` in {1}
		", $mrs);
	if ($required && !count($dat))
		throw new exception_bl('No such record (by mr).', $this->outfield.'_absent', 'absent');

	fill_texts($dat,$this->multilang_fields);
	$this->select_details($dat, $details);
}

function select_for_read (&$dat, $details = null)
{
	$dat = _main_::query($this->outfield, "
		select	N.*
		from	`{$this->table}` as N
		order	by N.`position` asc
		");

	fill_texts($dat,$this->multilang_fields);
	$this->select_details($dat, $details);
}

function select_for_admin (&$dat, $filters, $sorters, $pager, $details = null)
{
	$where_clause = convert_filters_to_sql_where_clause($filters, 'A', null, 'true');
	$order_clause = convert_sorters_to_sql_order_clause($sorters, 'A');
	$limit_clause = convert_pager_to_sql_limit_clause  ($pager);
	list($select_clause, $join_clause) = join_texts($this->multilang_fields,'A');

	if ($select_clause) $select_clause = ", ".$select_clause;

	$dat = _main_::query($this->outfield, "
		select	A.*
		{$select_clause}
		from	`{$this->table}` as A
		{$join_clause}
		where	{$where_clause}
		order	by {$order_clause}
		{$limit_clause}
		");
	$this->select_details($dat, $details);
}

function select_for_menu (&$dat, $details = null)
{
	$dat = _main_::query($this->outfield, "
		select	A.*
		from	`{$this->table}` as A
		order	by A.`position` asc, A.`id` asc
		");

	fill_texts($dat,$this->multilang_fields);
	$this->select_details($dat, $details);
}

function select_details (&$struct, $details = null)
{
	_main_::depend('details');
	select_details_oop($this->essence,$struct, $details, array(
		'fields' => 'select_fields',
		));
}

function select_fields (&$struct, $details = null) { _main_::depend('merges'); $m=_main_::fetchModule('form_fields'); $m->select_by_form($dat, get_fields($struct, 'id'), $details); merge_subtable_as_array($struct, $dat, 'fields', 'form' , 'id'); }

}
?>