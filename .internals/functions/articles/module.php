<?php
_main_::depend('multilang');

Class Articles
{
	var $table;
	var $essence;
	var $outfield;

	function __construct(){
		$this->table='articles';
		$this->essence='articles';
		$this->outfield='article';
		$this->multilang_fields=array('name', 'short');
	}

################## COMMON ####################################

function fetch_config()
{
	_main_::depend('configs');
	$fields = array();
	return config_for_module($this->essence, $fields);
}

function fetch_enums ($items_ids = null)
{
	$enums = array('@for' => $this->essence);

	$this->enumerate_siblings($enums['siblings']);

	$this->enumerate_names_for_items   ($enums['names-for-items'   ], $items_ids   );

	$this->enumerate_item_categories($enums['item_category_tree']);

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

function enumerate_names_for_items (&$dat, $ids)
{
	$uplink = _main_::fetchModule('items');
	$uplink->select_by_ids ($dat, $ids);
	$uplink->select_parents($dat);
}

function enumerate_item_categories (&$dat)
{
	$uplink = _main_::fetchModule('categories');
	$dat = $uplink->get_tree(1);
}

################## FORMS ####################################

function form_posted (&$action = null)
{
	_main_::depend('forms');
	$result = array();

	// Always posted fields (text/password/textarea/select/radio/...)
	$fields = array('mr', 'position', 'name', 'short');
	fields_fill($result, $fields); 
	fields_find($result, $fields);

	// Conditionally posted fields (checkbox)
	$fields = array();
	fields_fill($result, $fields, $action !== null ? 0 : null); 
	fields_find($result, $fields);

	// Full-text fields for auto-typographing.
	$fields = array('name');
	fields_typograph($result, $fields);

	$fields = array('items_list');
	fields_fill($result, $fields, $action !== null ? array() : null); 
	fields_find($result, $fields);

	//dom-fixes
	if (is_array($result['items_list']))
	{
		$tmp = array();
		foreach ($result['items_list'] as $val)
		{
			$item = array();
			$item['id'    ] = isset($val['id'    ]) && strlen($val['id'    ]) ? $val['id'    ] : null;
			$item['remove'] = isset($val['remove']) && strlen($val['remove']) ? $val['remove'] : null; if ($item['remove']) { $action = 'remove_service'; }
			$item['append'] = isset($val['append']) && strlen($val['append']) ? $val['append'] : null; if ($item['append']) { $action = 'append_service'; }
			if ((strlen($item['id'])) && !$item['remove'])
				$tmp['item:'.count($tmp)] = $item;
		}
		$result['items_list'] = $tmp;
	}

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
	validate_required($errors, $data, 'name'    );
	validate_optional($errors, $data, 'short'   );
	

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
		set	`mr`		= {02}
		,	`position`	= {03}
		,	`name`		= {04}
		,	`short`		= {05}
		where	`id` = {1}
		", $id,
		$data['mr'],
		$this->parse_position($data['position']),
		$data['name'],
		$data['short'],
		null);

		$this->fulfil_items($id, $data['items_list']);

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
		set	`mr`		= {02}
		,	`position`	= {03}
		,	`name`		= {04}
		,	`short`		= {05}
		", null,
		$data['mr'],
		$this->parse_position($data['position']),
		$data['name'],
		$data['short'],
		null);

		$this->fulfil_items($id, $data['items_list']);

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
	_main_::depend('linked_paras//opers', 'linked_paras//reads'); delete_linked_paras_by_uplinks('article', $ids);
	_main_::depend('linked_picts//opers', 'linked_picts//reads'); delete_linked_picts_by_uplinks('article', $ids);
	_main_::depend('linked_files//opers', 'linked_files//reads'); delete_linked_files_by_uplinks('article', $ids);

	// Удаляем тексты на всех языках 
	delete_texts($table, $this->table, $this->multilang_fields);

	_main_::query(null, "delete from `_articles2items_` where `article` in {1}", $ids);	

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

function fulfil_items ($id, $parts_list)
{
	$parts_ids = get_fields($parts_list, 'id');

	// Удаляем ссылки, которые отсутствуют в нашем целевом списке (либо чистим все связи, если целевой список пуст).
	if (count($parts_list))
	_main_::query(null, "
		delete	from `_articles2items_`
		where	`article` = {1} and `item` not in {2}
		", $id, $parts_ids);
	else
	_main_::query(null, "
		delete	from `_articles2items_`
		where	`article` = {1}
		", $id);

	// Добавляем (с игнорированием уже существующих связей) связи на автомодели из целевого списка.
	// Для работы replace важно чтоб связка двух этих id была primary key!
	$list = array(); foreach ($parts_ids as $parts_id) $list[] = _main_::sql_quote($parts_id);
	$list = count($list) ? "({1}," . implode("),({1},", $list) . ")" : null;
	if (strlen($list)) _main_::query(null, "
		insert ignore into `_articles2items_`
			(`article`, `item`)
		values	{$list}
		", $id);
}

################## READS ####################################

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

function select_where_latest (&$dat, $limit, $required = null, $details = null)
{
	$limit = (integer) $limit;
	$limit = $limit ? "limit {$limit}" : "";
	$dat = _main_::query($this->outfield, "
		select	A.*
		from	`{$this->table}` as A
		order by A.`position`, A.`id`
		{$limit}
		");

	fill_texts($dat,$this->multilang_fields);
	$this->select_details($dat, $details);
}

function select_for_read (&$dat, &$pager, $details = null)
{
        $limit=$pager->limit();
	$dat = _main_::query($this->outfield, "
		select	SQL_CALC_FOUND_ROWS N.*
		from	`{$this->table}` as N
		order	by N.`position` asc
		{$limit}
		");
	$pager->getTotal();


	fill_texts($dat,$this->multilang_fields);
	$this->select_details($dat, $details);
}

function select_for_admin (&$dat, $filters, $sorters, $pager, $details = null)
{
	$where_clause = convert_filters_to_sql_where_clause($filters, 'A', null, 'true');
	$order_clause = convert_sorters_to_sql_order_clause($sorters, 'A');
	$limit_clause = convert_pager_to_sql_limit_clause  ($pager);
	list($select_clause, $join_clause) = join_texts($this->multilang_fields,'A');

	$dat = _main_::query($this->outfield, "
		select	A.*
		,	{$select_clause}
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

function select_by_items (&$dat, $items, $details = null)
{
	$items = (is_array($items)) ? $items : (($items!==null) ? array($items) : null);

	$dat = (!count($items))?array():_main_::query($this->outfield, "
		select	O.*
		,	O2I.`item`			as `item`
		from	`{$this->table}` as O
		left join _articles2items_ as O2I on (O.id = O2I.article)
		where 	O2I.item in {1}
		group by O.id
		",$items);
		//where	(O.`actual_ts` is null or O.`actual_ts` < now())
		//and	(O.`expire_ts` is null or O.`expire_ts` > now())
	fill_texts($dat,$this->multilang_fields);
	$this->select_details($dat, $details);
}

function check_articles ()
{
	$dat = _main_::query($this->outfield, "
		select	count(*) as cnt
		from	`{$this->table}` as A
		inner join `linked_paras` as LP on (LP.`uplink_id` = A.`id` and LP.`uplink_type` = 'article' and LP.`lang_id` = {1})
		", LANG_ID);
	return array_shift(array_shift($dat));
}

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

}
?>