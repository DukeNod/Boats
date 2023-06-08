<?php
_main_::depend('multilang');
_main_::depend('base_module');

class Pays extends Base_Module
{
	var $admin;

	function __construct()
	{
		parent::__construct('pays', 'pay', 'Клиенты и оплата');

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
		
		

		$this->make_field('TextField', 'official_organ', true, null, array(
			'title'		=> 'Код подразделения - РФ'
		,	'autocomplete' => [ 'url' => 'search/organ.php' ]
		));

		$this->make_field('TextField', 'official_organ_foreign', true, null, array(
			'title'		=> 'Код подразделения - иностранцы'
		,	'autocomplete' => [ 'url' => 'search/organ.php' ]
		));

		$this->make_field('TextField', 'name', true, null, array(
			'title'		=> 'Юр. лицо'
		));

		$this->make_field('TextField', 'name_full', false, null, array(
			'title'		=> 'Краткое название гостиницы'
		));

		$this->make_field('TextField', 'off_name', false, null, array(
			'title'		=> 'Полное название гостиницы'
		));

		$this->make_field('TextField', 'inn', true, null, array(
			'title'		=> 'ИНН'
		));

		$this->make_field('TextField', 'ogrn', true, null, array(
			'title'		=> 'ОГРН'
		,	'list'		=> 0
		));

		$this->make_field('CheckBox', 'active', false, null, array(
			'title'		=> 'Статус пользоватетеля поставщика'
		));

		$this->make_field('TextField', 'fms_code', true, null, array(
			'title'		=> 'Идентификатор пользоватетеля поставщика'
		));

		$this->make_field('TextField', 'hotel_code', true, null, array(
			'title'		=> 'Код гостиницы'
		,	'list'		=> 0
		));

		$this->make_field('HeaderText', 'h1', false, null, array(
			'title'		=> 'Фактический адрес'
		,	'list'		=> 0
		));
		
		$this->make_field('TextField', 'legal_country', false, null, array(
			'title'		=> 'Страна'
		,	'list'		=> 0
		,	'autocomplete' => [ 'url' => 'search/country.php' ]
		));
		
		$this->make_field('TextField', 'legal_city', false, null, array(
			'title'		=> 'Город'
		,	'autocomplete' => [ 'url' => 'search/city.php' ]
		));
		
		$this->make_field('TextField', 'legal_street', false, null, array(
			'title'		=> 'Улица'
		,	'autocomplete' => [ 'url' => 'search/street.php' ]
		));
		
		$this->make_field('TextField', 'address_guid', false, null, array(
			'title'		=> 'Guid'
		,	'list'		=> 0
		,	'cssClass'	=> 'controlString input-disabled'
		));
		
		$this->make_field('TextField', 'legal_house', false, null, array(
			 'title'	=> 'Дом'
			,'cssClass'	=> 'controlNumber'
		,	'list'		=> 1
		));
		
		$this->make_field('TextField', 'legal_korpus', false, null, array(
			 'title'	=> 'Корпус'
			,'cssClass'	=> 'controlNumber'
		,	'list'		=> 0
		));
		
		$this->make_field('TextField', 'legal_stroenie', false, null, array(
			 'title'	=> 'Строение'
			,'cssClass'	=> 'controlNumber'
		,	'list'		=> 0
		));
		
		$this->make_field('TextField', 'legal_apt', false, null, array(
			 'title'	=> 'Квартира'
			,'cssClass'	=> 'controlNumber'
		,	'list'		=> 0
		));
		
		$this->make_field('HeaderText', 'empty1', false, null, array(
			'title'		=> ' '
		,	'list'		=> 0
		));

		$this->make_field('TextArea', 'address_actual', false, null, array(
			'title'		=> 'Юридический адрес'
		));

		$this->make_field('TextField', 'capacity', true, null, array(
			 'title'	=> 'Вместимость'
			,'cssClass'	=> 'controlNumber'
		,	'list'		=> 1
		));
		
		$this->make_field('TextField', 'initial_count', true, null, array(
			 'title'	=> 'Начальная заполненность'
			,'cssClass'	=> 'controlNumber'
		,	'list'		=> 0
		));
		
		$this->make_field('Select', 'xml_type', true, 0, array(
			 'title'	=> 'Отельная система'
		,	'values_list' =>
			[
				 0		=> 'Нет'
				,1		=> 'HRS'
				,2		=> 'Logus'
				,3		=> 'Корстон'
				,4		=> 'Frontdesk24'
				,5		=> 'Epitome'
				,6		=> 'Интеротель'
				,7		=> '1C-Отель'
				,8		=> 'Эдельвейс'
				,9		=> 'Hotel(Интел-Сфера)'
				,10		=> 'БИТ-Отель'
				,11		=> 'Travelline'
				,12		=> 'ExaHotel'
				,13		=> 'Амадеус'
			]
		));
				
		$this->make_field('DBFunction', 'created_at', false, null, array(
			 'function'	=> 'now()'
		));
		
		$this->make_field('DBFunction', 'updated_at', false, null, array(
			 'function'	=> 'now()'
		));
		
		/*		
		$this->make_field('TextField', 'phone', false, null, array(
			'title'		=> 'Телефон'
		,	'list'		=> 0
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

function data_parce ()
{
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

function select_by_payment (&$dat, $payment, $details = null)
{
	if (!is_array($payment)) $payment = (array) $payment;
	$dat = !count($payment) ? array() : _main_::query($this->outfield, "
		select	C.*, P.name as paytype
		from	`{$this->table}` as C
		left join paytype as P	on (C.paytype = P.id)
		where	C.`payment` in {1}
		", $payment);

	//fill_texts($dat,$this->multilang_fields);
	$this->select_details($dat, $details);
}

function select_for_select (&$dat, $details = null)
{
	_main_::depend('sql');
	
    reset($this->admin_sorters);
    $key = key($this->admin_sorters);
	$order_clause = convert_sorters_to_sql_order_clause(array($key => $this->admin_sorters[$key]), 'N');

	$dat = _main_::query($this->outfield, "
		select	N.id, N.name_full as name
		from	`{$this->table}` as N
		order	by {$order_clause}
		");

	fill_texts($dat,$this->multilang_fields);
	$this->select_details($dat, $details);
}

function select_for_approved (&$dat, $filters, $sorters, $pager, $details = null)
{
	$limit = $pager->limit();

	$order_clause = convert_sorters_to_sql_order_clause($sorters, 'C', [ 'pdate' => 'pdate', 'psumm' => 'psumm', 'tradein_obj' => 'P.tradein_obj' ]);
	$where = $filters->sql_where("C", [ 'pdate' => 'P.date' ]);

	$dat = _main_::query($this->outfield, "
		select SQL_CALC_FOUND_ROWS
			C.*, P.id as pid, P.date as pdate, P.summ as psumm, P.approved, M.name as manager, B.name as branch, R.name as region, PT.name as paytype, P.tradein_obj,
			group_concat(MO.name SEPARATOR ', ') as model, O.name as organization
		from	`{$this->table}` as P
		left	join `payment` as C on (P.payment = C.id)
		left	join users as M on (C.manager = M.id)
		left	join branches as B on (C.branch = B.id)
		left	join `_models4payment_` as m4p on (m4p.payment = C.id)
		left	join models as MO on (m4p.model = MO.id)
		left	join regions as R on (C.region = R.id)
		left	join paytype as PT on (C.paytype = PT.id)
		left	join organization as O on (C.organization = O.id)
		where	P.status = 'yes'
		and		{$where}
		group	by P.id
		order	by {$order_clause}
        {$limit}
	");

	$pager->getTotal();

	fill_texts($dat,$this->multilang_fields);
	$this->select_details($dat, $details);
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
	if (isset($data['refund']) && $data['refund'] == 1) $data['summ'] *= -1;
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
		$this->post_update($id, $data, $orig);

	}
	catch (exception_db_unique $exception) { $this->handle_uploads_temporarily($data); _main_::depend('validations'); validate_add_error($errors, $this->parce_unique_exception($exception->getMessage()), 'duplicate'); }
	catch (exception           $exception) { $this->handle_uploads_temporarily($data); throw $exception; }
//	update_texts($data, $this->table, $this->multilang_fields);

/*
	try
	{
		_main_::query(null, "
			update `{$this->table}`
			set	`phone`				= {02}
			,	`client`			= {03}
			,	`contract_number`	= {04}
			,	`contract_date`		= {05}
			,	`branch`			= {06}
			,	`manager`			= {07}
			,	`model`				= {08}
			,	`type`				= {09}
			,	`boat_number`		= {10}
			,	`avail`				= {11}
			where	`id` = {1}
		"
		,$id
		,$data['phone']
		,$data['client']
		,$data['contract_number']
		,$data['contract_date']
		,$data['branch']
		,$data['manager']
		,$data['model']
		,$data['type']
		,$data['boat_number']
		,$data['avail']
		);
		
		#foreach($this->fields as $f=>$v) $v->post_update($id, $data, $orig);
		$this->post_update($id, $data, $orig);

	}
	catch (exception_db_unique $exception) { $this->handle_uploads_temporarily($data); _main_::depend('validations'); validate_add_error($errors, $this->parce_unique_exception($exception->getMessage()), 'duplicate'); }
	catch (exception           $exception) { $this->handle_uploads_temporarily($data); throw $exception; }
*/
}

function public_insert (&$errors, $fields, &$data, &$id)
{
	if (isset($data['refund']) && $data['refund'] == 1) $data['summ'] *= -1;
	$sql = '';
	foreach($fields as $f=>$v) if($field = $v->sql_set($data)) $sql .= ','.$field;
	$sql = substr($sql, 1);
	
	try
	{
		_main_::query(null, "
			insert 	into `{$this->table}`
			set	{$sql}
			, payment = {1}
		"
		, $data['payment']);
		
		$this->handle_uploads_persistently($data);

		$this->post_update($id, $data);
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
/*
	try 
	{	
		$id = _main_::query(null, "
			insert 	into `{$this->table}`
			set	`phone`				= {02}
			,	`client`			= {03}
			,	`contract_number`	= {04}
			,	`contract_date`		= {05}
			,	`branch`			= {06}
			,	`manager`			= {07}
			,	`model`				= {08}
			,	`type`				= {09}
			,	`boat_number`		= {10}
			,	`avail`				= {11}
		"
		,null
		,$data['phone']
		,$data['client']
		,$data['contract_number']
		,$data['contract_date']
		,$data['branch']
		,$data['manager']
		,$data['model']
		,$data['type']
		,$data['boat_number']
		,$data['avail']
		);

		$this->handle_uploads_persistently($data);

		$this->post_update($id, $data);
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
*/
}

}
?>