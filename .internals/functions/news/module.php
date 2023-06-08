<?php
_main_::depend('multilang');

Class News {
	var $table;
	var $essence;
	var $outfield;
	var $uplink;

	function __construct(){
		$this->table='news';
		$this->essence='news';
		$this->outfield='news';
//		$this->multilang_fields=array('title', 'short');
		$this->multilang_fields=array();
	}

################## COMMON ####################################

function fetch_config()
{
	_main_::depend('configs');
	$fields = array();
	return config_for_module($this->essence, $fields);
}

function fetch_enums($items_ids = null)
{
	$enums = array('@for' => $this->essence);
	$this->enumerate_domains($enums['domains']);

	$this->enumerate_groups($enums['gallery_groups']);
	$this->enumerate_names_for_items   ($enums['names-for-items'   ], $items_ids);

	_main_::put2dom('enums', $enums);
	return $enums;
}

################## ENUMS ####################################
function enumerate_domains (&$dat)
{
	$uplink = _main_::fetchModule('langs');
	$uplink->select_for_read($dat);
}

function enumerate_groups (&$dat)
{
	$uplink = _main_::fetchModule('gallery_groups');
	$uplink->select_for_read($dat);
}

function enumerate_names_for_items(&$dat, $ids)
{
	$uplink = _main_::fetchModule('gallery');
	$uplink->select_by_ids($dat, $ids);
}

################## FORMS ####################################

function form_posted ($action = null)
{
	_main_::depend('forms');
	$result = array();

	// Always posted fields (text/password/textarea/select/radio/...)
	$fields = array('ts', 'title', 'listname', 'short', 'domain', 'items_list'); // ,'group'
	fields_fill($result, $fields); 
	fields_find($result, $fields);

	// Conditionally posted fields (checkbox)
	$fields = array();
	fields_fill($result, $fields, $action !== null ? 0 : null); 
	fields_find($result, $fields);

	// Full-text fields for auto-typographing.
	$fields = array('title', 'short', 'listname');
	fields_typograph($result, $fields);

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
				$tmp['gallery:'.count($tmp)] = $item;
		}
		$result['items_list'] = $result['gallery'] = $tmp;
	}

	return $result;
}

function prepare (&$errors, &$data, $config, $enums)
{
}

function validate (&$errors, &$data, $config, $enums, $ignore_uploads = false)
{
	_main_::depend('validations', 'merges');

	validate_required($errors, $data, 'ts'   ) && validate_datetime($errors, $data, 'ts');
	validate_required($errors, $data, 'title');
	validate_optional($errors, $data, 'short');
	validate_required($errors, $data, 'group');
	validate_required($errors, $data, 'domain');
	validate_optional($errors, $data, 'listname');

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
	update_texts($data, $this->table, $this->multilang_fields);

	try { _main_::query(null, "
		update 	`{$this->table}`
		set	`ts`		= ifnull({02}, `ts`)
		,	`title`		= {03}
		,	`short`		= {04}
		,	`group`		= {05}
		,	`domain`	= {06}
		,	`listname`	= {07}
		where	`id` = {1}
		", $id,
		$data['ts'],
		$data['title'],
		$data['short'],
		$data['group'],
		$data['domain'],
		$data['listname'],
		null);

		$this->fulfil_items($id, $data['items_list']);

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
		set	`ts`		= ifnull({02}, now())
		,	`title`		= {03}
		,	`short`		= {04}
		,	`group`		= {05}
		,	`domain`	= {06}
		,	`listname`	= {07}
		", null,
		$data['ts'],
		$data['title'],
		$data['short'],
		$data['group'],
		$data['domain'],
		$data['listname'],
		null);

		$this->fulfil_items($id, $data['items_list']);

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
	_main_::depend('linked_paras//opers', 'linked_paras//reads'); delete_linked_paras_by_uplinks('news', $ids);
	_main_::depend('linked_picts//opers', 'linked_picts//reads'); delete_linked_picts_by_uplinks('news', $ids);
	delete_linked_picts_by_uplinks('news_gallery', $ids);
	delete_linked_picts_by_uplinks('news_preview', $ids);
	
	_main_::depend('linked_files//opers', 'linked_files//reads'); delete_linked_files_by_uplinks('news', $ids);
	delete_linked_files_by_uplinks('news_pr', $ids);

	// Удаляем тексты на всех языках 
	delete_texts($table, $this->table, $this->multilang_fields);

	_main_::query(null, "delete from `_gallery2news_` where `news` in {1}", $ids);

	// Удаляем сами записи и чистим файлы от файловых полей.
	_main_::query(null, "delete from `news` where `id` in {1}", $ids);
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

function fulfil_items ($id, $parts_list)
{
	$parts_ids = get_fields($parts_list, 'id');

	if (count($parts_list))
	_main_::query(null, "
		delete	from `_gallery2news_`
		where	`news` = {1} and `gallery` not in {2}
		", $id, $parts_ids);
	else
	_main_::query(null, "
		delete	from `_gallery2news_`
		where	`news` = {1}
		", $id);

	$list = array(); foreach ($parts_ids as $parts_id) $list[] = _main_::sql_quote($parts_id);
	$list = count($list) ? "({1}," . implode("),({1},", $list) . ")" : null;
	if (strlen($list)) _main_::query(null, "
		insert ignore into `_gallery2news_`
			(`news`, `gallery`)
		values	{$list}
		", $id);
}

################## READS ####################################


function select_by_ids (&$dat, $ids, $required = null, $details = null)
{
	if (!is_array($ids)) $ids = (array) $ids;
	$dat = !count($ids) ? array() : _main_::query($this->outfield, "
		select	N.*
		from	`{$this->table}` as N
		where	N.`id` in {1}
		", $ids);
	if ($required && !count($dat))
		throw new exception_bl('No such record (by id).', 'news_absent', 'absent');

	fill_texts($dat,$this->multilang_fields);
	$this->select_details($dat, $details);
}

function select_for_linked (&$dat, $id, $required = null, $details = null)
{
	$dat = (!$id) ? array() : _main_::query($this->outfield, "
		select	N.*
		from	`{$this->table}` as N
		where	N.`id` = {1}
		", $id);
	if ($required && !count($dat))
		throw new exception_bl('No such record (by id).', 'news_absent', 'absent');

	fill_texts($dat,$this->multilang_fields);
}

function select_for_admin (&$dat, $filters, $sorters, $pager, $details = null)
{
	$where_clause = convert_filters_to_sql_where_clause($filters, 'N', null, 'true');
	$order_clause = convert_sorters_to_sql_order_clause($sorters, 'N');
	$order_clause = convert_sorters_to_sql_order_clause($sorters, 'N');
	list($select_clause, $join_clause) = join_texts($this->multilang_fields,'N');

	$limit_clause = convert_pager_to_sql_limit_clause  ($pager  );
	$dat = _main_::query($this->outfield, "
		select	N.*
		from	`{$this->table}` as N
		{$join_clause}
		where	{$where_clause}
		order	by {$order_clause}
		{$limit_clause}
		");
//	,	{$select_clause}
	$this->select_details($dat, $details);
}

function select_news_years (&$dat, $group, $details = null)
{
        global $domain_id;

	$dat = _main_::query('year', "
		select	distinct YEAR(N.`ts`) as `year`
		from	`{$this->table}` as N
		where	N.`group` = {1}
		and	N.`domain` = {2}
		order	by `year` desc
		", $group, $domain_id);

}

function select_where_latest (&$dat, $limit, $details = null)
{
        global $domain_id;

	$limit = (integer) $limit;
	$limit = $limit ? "limit {$limit}" : "";
	$curr_date = date('Y-m-d');
	$dat = _main_::query($this->outfield, "
		select	N.*
		from	`{$this->table}` as N where N.`ts`<='$curr_date'
		order	by N.`ts` desc, N.`id` desc
		{$limit}
		", $domain_id);
//		where	N.`ts` >= date_add(now(), INTERVAL '-2' MONTH)
//		where	N.`group` = 'news'
//		and	N.`domain` = {1}

	fill_texts($dat,$this->multilang_fields);
	$this->select_details($dat, $details);
}

function select_news_by_page (&$dat, $group, &$pager, $details = null)
{
        global $domain_id;
	$limit=$pager->limit();
	$curr_date = date('Y-m-d');
	$dat = _main_::query('news', "
		select	SQL_CALC_FOUND_ROWS N.*
		from		`news`		as N
		where	N.`group` = 'news' and N.`ts`<='$curr_date'
		order	by N.`ts` desc, N.`id` asc
		{$limit}
		", $group
		, $domain_id);
//		and	N.`domain` = {2}
	$pager->getTotal();

	fill_texts($dat,$this->multilang_fields);
	$this->select_details($dat, $details);
}

function select_news_by_year (&$dat, $year, $group = 'news', $details = null)
{
        global $domain_id;
	$dat = _main_::query('news', "
		select	N.*
		from		`news`		as N
		where	N.`ts` >= {1} and N.`ts` <= {2}
		and	N.`domain` = {3}
		and	N.`group` = {4}
		order	by N.`ts` desc, N.`id` asc
		"
		, "$year-01-01"
		, "$year-12-31"
		, $domain_id
		, $group
		);

	fill_texts($dat,$this->multilang_fields);
	$this->select_details($dat, $details);
}

function select_news_by_group (&$dat, $group, $details = null)
{
        global $domain_id;
	$dat = _main_::query('news', "
		select	N.*
		from		`news`		as N
		where	N.`group` = {1}
		and	N.`domain` = {2}
		order	by N.`ts` desc, N.`id` asc
		"
		, $group
		, $domain_id);

	fill_texts($dat,$this->multilang_fields);
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
		select	N.*
		from	`{$this->table}` as N
		where	N.`type` = 'global'
		order	by N.`ts` desc, N.`id` desc
		{$limit}
		");

	fill_texts($dat,$this->multilang_fields);
	$this->select_details($dat, $details);
}

function select_by_words (&$dat, $words, $details = null)
{
	if ($lang===null) $lang=LANG_ID;

	// Без сортировки! Так как сортируем средствами XSLT (у нас в итоге слияния разных типов данных).
	// Убрали прицепленные блоки (для скорости - их нет потому что), но общую структуру сохранили от других сущностей.
	_main_::depend('sql');
	search_clauses($where, $relat, $words, array(
		array('field'=>' N.`title` ', 'weight'=>1.00),
		array('field'=>' N.`short` ', 'weight'=>0.90),
		array('field'=>'LP.`name`  ', 'weight'=>0.30),
		array('field'=>'LP.`text`  ', 'weight'=>0.20),
		));
	$dat = !count($words) ? array() : _main_::query($this->outfield, "
		select	N.*
		from	(
				select	N.*
				,	{$relat} as `relativity`
				from	`{$this->table}` N
				left	join `linked_paras` LP on (LP.`uplink_type` in ('news') and LP.`uplink_id` = N.`id`)
				where	N.`domain` = {1}
				and	{$where}
				group	by N.`id`
				order	by null
			) N
		", 0); //$lang);

	//fill_texts($dat,$this->multilang_fields);
	$this->select_details($dat, $details);
}

function select_details (&$struct, $details = null)
{
        $lang_id = _config_::$lang_id;
        _config_::$lang_id = 1;
	_main_::depend('details');
	select_details_oop($this->essence,$struct, $details, array(
		'linked_files'	=> 'select_linked_files',
		'linked_paras'	=> 'select_linked_paras',
		'linked_picts'	=> 'select_linked_picts',
		'linked_gallery'=> 'select_linked_gallery',
		'gallery'	=> 'select_gallery',
		));
	_config_::$lang_id = $lang_id;
}

function select_linked_paras (&$struct, $details = null) { _main_::depend('merges', 'linked_paras//reads'); select_linked_paras_by_uplinks($dat, 'news', get_fields($struct, 'id'), $details); merge_subtable_as_array($struct, $dat, 'linked_paras', 'uplink_id', 'id'); }
function select_linked_picts (&$struct, $details = null) { _main_::depend('merges', 'linked_picts//reads'); select_linked_picts_by_uplinks($dat, 'news', get_fields($struct, 'id'), $details); merge_subtable_as_array($struct, $dat, 'linked_picts', 'uplink_id', 'id'); }
function select_linked_files (&$struct, $details = null) { _main_::depend('merges', 'linked_files//reads'); select_linked_files_by_uplinks($dat, 'news', get_fields($struct, 'id'), $details); merge_subtable_as_array($struct, $dat, 'linked_files', 'uplink_id', 'id'); }
function select_linked_gallery(&$struct, $details = null){ _main_::depend('merges', 'linked_picts//reads'); select_linked_picts_by_uplinks($dat, 'news_gallery', get_fields($struct, 'id'), $details); merge_subtable_as_array($struct, $dat, 'linked_gallery', 'uplink_id', 'id'); }
function select_gallery      (&$struct, $details = null) { $m=_main_::fetchModule('gallery');		    $m->select_by_news		  ($dat       , get_fields($struct, 'id'), $details); merge_subtable_as_array($struct, $dat, 'gallery'      , 'news'     , 'id'); }

}

?>