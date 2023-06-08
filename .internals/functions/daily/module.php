<?php
_main_::depend('multilang');
_main_::depend('base_module');

class Daily extends Base_Module
{
	var $admin;

	function __construct()
	{
		parent::__construct('daily', 'daily', 'Ежедневный отчёт');

		#$this->order_field = 'last_name'; // Специальное поле position позволяет управлять сортировкой (стрелочки)
		$this->name_field = 'name'; // Какое поле представляет название записи. default 'name'
		#$this->update_details = array(); // Список линков для страницы редактирования записи. default true (все линки)
		$this->on_page = 100;
		$this->return_to_list = true; // Возвтрат к списку после добавления/радктирования. default: false (возврат к редактированию)

		$this->additional_js = 'hotels.js'; // Возвтрат к списку после добавления/радктирования. default: false (возврат к редактированию)
		// make_filter(filter_type, filter_name, filter_title, defauilt value, [fields = array()])
		/*
		$this->make_filter('Select', 'with_card', 'Наличие карты', '', array(
			'values_list'	=> array('not null'=>'имеют карту', 'null'=>'не имеют карту')
		,	'empty'		=> 'не учитывать'
		,	'mapping'	=> array('with_card'=>'A.`card`')
		));
		$this->make_filter('TextField', 'card', 'Номер карты', array());
		$this->make_filter('TextField', 'last_name', 'Фамилия', '');
		$this->make_filter('TextField', 'email', 'E-mail', '');
		*/
		$this->make_filter('TextField', 'name_full', 'Краткое название гостиницы', '');
		$this->make_filter('TextField', 'name', 'Юр. лицо', '');
		
//		$this->admin_filters = array('last_name'=>''); // , 'mr'=>'', 'short'=>''
		$this->admin_sorters = array('created_at'=>true); // 'position'=>false, 'mr'=>false, 
		//$this->unique_keys = array(2=>'email', 4=>'card'); // ???

		// Добавление полей модуля
		// make_field('field_type', 'field_name', [required], [defauilt value], [parameters = array()])
		
		
		/*
		$this->make_field('TextField', 'official_organ', true, null, array(
			'title'		=> 'Код подразделения - РФ'
		,	'autocomplete' => [ 'url' => 'search/organ.php' ]
		));
		*/
	}

################## COMMON ####################################

################## ENUMS ####################################

################## FORMS ####################################

################## OPERS ####################################
/*
function insert (&$errors, &$data, &$id)
{
	try 
	{
		$id = _main_::query(null, "
			insert 	into `users` (`encrypted_password`, `email`, `created_at`, `updated_at`)
			values ({02}, {03}, now(), now())
		", null,
		$this->pwd_hash($data['password1']),
		$data['email'],
		null);
		
		_main_::query(null, "
			insert 	into `profiles` (`type`,`user_id`,`hotel_id`,`umms_id`,`lastname`,`middlename`,`firstname`,`passport_type`,`passport_series`
			,	`passport_number`,`passport_source`,`passport_date`,`passport_end_date`,`citizen`,`birth_place`,`reg_country`,`reg_city`
			,	`reg_street`,`reg_house`,`reg_korpus`,`reg_stroenie`,`reg_apt`,`phone`,`created_at`,`updated_at`,`reg_address`)
			values ({02},{03},{04},{05},{06},{07},{08},{09},{10},{11},{12},{13},{14},{15},{16},{17},{18},{19},{20},{21},{22},{23},{24},now(),now(),{25})
		"
		,null
		,'hotelier'
		,$id
		,1 //$data['hotel_id']
		,$data['umms_id']
		,$data['lastname']
		,$data['middlename']
		,$data['firstname']
		,$data['passport_type']
		,$data['passport_series']
		,$data['passport_number']
		,$data['passport_source']
		,$data['passport_date']
		,$data['passport_end_date']
		,$data['citizen']
		,$data['birth_place']
		,$data['reg_country']
		,$data['reg_city']
		,$data['reg_street']
		,$data['reg_house']
		,$data['reg_korpus']
		,$data['reg_stroenie']
		,$data['reg_apt']
		,$data['phone']
		,$data['reg_address']
		);

		$this->handle_uploads_persistently($data);

		#foreach($this->fields as $f=>$v) $v->post_update($id, $data);
		$this->post_update($id, $data);
	}
	catch (exception_db_unique $exception) { $this->handle_uploads_temporarily($data); _main_::depend('validations'); validate_add_error($errors, $this->parce_unique_exception($exception->getMessage()), 'duplicate'); }
	catch (exception           $exception) { $this->handle_uploads_temporarily($data); throw $exception; }
}

function update (&$errors, &$data, &$id, $orig = null)
{	
//	update_texts($data, $this->table, $this->multilang_fields);

//	$sql = '';
//	foreach($this->fields as $f=>$v) if($field = $v->sql_set($data)) $sql .= ','.$field;
//	$sql = substr($sql, 1);

	try
	{
		_main_::query(null, "
			update	`users`
			set		`email`	= {02}
			where	`id` 	= {01}
		", $id,
		$data['email'],
		null);

		if (isset($data['password1']) && $data['password1'])
		{
			_main_::query(null, "
				update `users`
				set	`encrypted_password`		= {02}
				where	`id` = {1}
			", $id,
			$this->pwd_hash($data['password1']),
			null);
		}
		
		_main_::query(null, "
			update `profiles`
			set	`type`				= {02}
			,	`user_id`			= {03}
			,	`hotel_id`			= {04}
			,	`umms_id`			= {05}
			,	`lastname`			= {06}
			,	`middlename`		= {07}
			,	`firstname`			= {08}
			,	`passport_type`		= {09}
			,	`passport_series`	= {10}
			,	`passport_number`	= {11}
			,	`passport_source`	= {12}
			,	`passport_date`		= {13}
			,	`passport_end_date`	= {14}
			,	`citizen`			= {15}
			,	`birth_place`		= {16}
			,	`reg_country`		= {17}
			,	`reg_city`			= {18}
			,	`reg_street`		= {19}
			,	`reg_house`			= {20}
			,	`reg_korpus`		= {21}
			,	`reg_stroenie`		= {22}
			,	`reg_apt`			= {23}
			,	`phone`				= {24}
			,	`reg_address`		= {25}
			where	`user_id` = {1}
		"
		,$id
		,'hotelier'
		,$id
		,$data['hotel_id']
		,$data['umms_id']
		,$data['lastname']
		,$data['middlename']
		,$data['firstname']
		,$data['passport_type']
		,$data['passport_series']
		,$data['passport_number']
		,$data['passport_source']
		,$data['passport_date']
		,$data['passpost_end_date']
		,$data['citizen']
		,$data['birth_place']
		,$data['reg_country']
		,$data['reg_city']
		,$data['reg_street']
		,$data['reg_house']
		,$data['reg_korpus']
		,$data['reg_stroenie']
		,$data['reg_apt']
		,$data['phone']
		,$data['reg_address']
		);
		
		#foreach($this->fields as $f=>$v) $v->post_update($id, $data, $orig);
		$this->post_update($id, $data, $orig);

	}
	catch (exception_db_unique $exception) { $this->handle_uploads_temporarily($data); _main_::depend('validations'); validate_add_error($errors, $this->parce_unique_exception($exception->getMessage()), 'duplicate'); }
	catch (exception           $exception) { $this->handle_uploads_temporarily($data); throw $exception; }
}
*/

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
	$this->data_prepare ($dat);
}

function data_prepare (&$dat)
{
}

function select_for_admin (&$dat, $filters, $sorters, $pager, $details = null)
{
	$mapping = array();

	if ($this->admin_filters)
	foreach($this->admin_filters as $f=>$v)
	{
		if ($v->mapping)
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
		select SQL_CALC_FOUND_ROWS
			A.*
		from  
			`{$this->table}` as A
        where {$where}
		order by {$order_clause}
        {$limit}
	");
		
	$pager->getTotal();
	$this->select_details($dat, $details);
}

function select_details (&$struct, $details = null)
{
	_main_::depend('details');
	select_details_oop($this->essence,$struct, $details, array(
		//'status'	=> 'select_status'
		));
}

function public_update (&$errors, $fields, &$data, &$id, $orig = null)
{	
	$u = _main_::fetchModule('users');
	
	$sql = '';
	foreach($fields as $f=>$v) if($field = $v->sql_set($data)) $sql .= ','.$field;
	$sql = substr($sql, 1);
	
	try
	{
		_main_::query(null, "
			update 	`{$this->table}`
			set	{$sql}
			where	`id` = {1}
		"
		, $id
		);
		
		#foreach($this->fields as $f=>$v) $v->post_update($id, $data, $orig);
		#$this->post_update($id, $data, $orig);

	}
	catch (exception_db_unique $exception) { $this->handle_uploads_temporarily($data); _main_::depend('validations'); validate_add_error($errors, $this->parce_unique_exception($exception->getMessage()), 'duplicate'); }
	catch (exception           $exception) { $this->handle_uploads_temporarily($data); throw $exception; }
//	update_texts($data, $this->table, $this->multilang_fields);
}

function public_insert (&$errors, $fields, &$data, &$id)
{
	$u = _main_::fetchModule('users');
	
	$sql = '';
	foreach($fields as $f=>$v) if($field = $v->sql_set($data)) $sql .= ','.$field;
	$sql = substr($sql, 1);
	
	if($u->is('rop'))
	{
		$sql .= ', `branch` = '._identify_::$info['branch'];
	}
	
	try
	{
		$id =_main_::query(null, "
			insert 	into `{$this->table}`
			set	{$sql}
		"
		);
		
		$this->handle_uploads_persistently($data);

		#$this->post_update($id, $data);
	}
	catch (exception_db_unique $exception) { 
		$this->handle_uploads_temporarily($data); 
		_main_::depend('validations'); 
		validate_add_error($errors, $this->parce_unique_exception($exception->getMessage()), 'duplicate'); 
	}
	catch (exception $exception) { 
		$this->handle_uploads_temporarily($data); 
		throw $exception; 
	}
}

function select_for_report ($data)
{
#	$limit = $pager->limit();

	#$order_clause = convert_sorters_to_sql_order_clause($sorters, 'H');
	#$where = $filters->sql_where("H");
	
	list($month, $year) = explode('.', $data['time']);
	
	$from	= date('Y-m-d', mktime(0, 0, 0, $month, 1, $year));
	$to		= date('Y-m-d', mktime(0, 0, 0, $month+1, 1, $year));

	if (!$data['branch'] || $data['branch'] == 'all')
	{
		$dat = _main_::query('daily:date', "
			select	`date`
			,		sum(`visit`) as `visit`
			,		sum(`calls`) as `calls`
			,		sum(`sites`) as `sites`
			,		sum(`lids`)  as `lids`
			,		sum(`sales`) as `sales`
			,		sum(`summ`)  as `summ`
			,		sum(`rub`)   as `rub`
			,		sum(`usd`)   as `usd`
			from	`daily`
			where	`date` >= {1} and date < {2}
			group	by `date`
			order	by `date` desc
		"
		, $from
		, $to
		);
	}
	else
	{
		$dat = _main_::query('daily:date', "
			select	*
			from	`daily`
			where	`date` >= {1} and date < {2}
			and		({3} is null or branch = {3})
			order	by `date` desc
		"
		, $from
		, $to
		, $data['branch']
		);
	}
	
	$end = ($data['time'] == date('m.Y')) ? date('d') : date('t', strtotime($from));
	
	$report = [];
	
	for($i = 1; $i <= $end; $i++)
	{
		$day = "$year-$month-".($i > 9 ? $i : '0'.$i);
		
		$report['day:'.$day] = isset($dat['daily:'.$day]) ? $dat['daily:'.$day] : [ 'date' => $day ];
		
	}
	
	$report = array_reverse($report);
	
	return $report;
}

}
?>