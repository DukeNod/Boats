<?php
_main_::depend('multilang');
_main_::depend('base_module');

class Payment extends Base_Module
{
	var $admin;

	function __construct()
	{
		parent::__construct('payment', 'payment', 'Клиенты и оплата');

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

function public_update (&$errors, $fields, &$data, &$id, $orig = null)
{	
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

function get_order_type ($data)
{
	$mids = get_fields($data['models'], 'id');
	
	$models =_main_::query(null, "
		select type from `models` where id in {1}
	"
	, $mids);
	
	$types = get_fields($models, 'type');
	
	if (in_array(4, $types) && !in_array(1, $types) && !in_array(2, $types) && !in_array(5, $types))
	{
		return 1; // трак, болотоход (может быть с прицепом)
	}
	
	return 0; // лодка или всё остальное
}

function get_contract_number ($data, $order_type)
{
	if ($order_type == 1)
	{
		$start = 79;
	}
	else
	{
		$start = 957;
	}
	
	while(_main_::query(null, "select id from `{$this->table}` where `order_type` = {1} and `contract_number` = {2}", $order_type, $start)) $start++;
	
	return $start;
}

function public_insert (&$errors, $fields, &$data, &$id)
{
	$u = _main_::fetchModule('users');

	$order_type = $this->get_order_type($data);
	
	if (!$data['contract_number'])
	{
		$data['contract_number'] = $this->get_contract_number($data, $order_type);
	}
	
	$sql = '';
	foreach($fields as $f=>$v) if($field = $v->sql_set($data)) $sql .= ','.$field;
	$sql = substr($sql, 1);
	
	if ($u->is('manager'))
	{
		$sql .= ', `branch` = '._identify_::$info['branch'];
		$sql .= ', `manager` = '._identify_::$info['id'];
	}
	elseif($u->is('rop'))
	{
		$sql .= ', `branch` = '._identify_::$info['branch'];
	}
	
	$sql .= ', `order_type` = '.$order_type;
	
	try
	{
		$id =_main_::query(null, "
			insert 	into `{$this->table}`
			set	{$sql}
		"
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

function select_for_show (&$dat, $ids, $required = null, $details = null)
{
	if (!is_array($ids)) $ids = (array) $ids;
	
	$dat = !count($ids) ? array() : _main_::query($this->outfield, "
		select
			H.*, M.name as manager, MO.name as model, B.name as branch, P.name as paytype, O.name as organization, R.name as region
		from	`{$this->table}` as H
			left join users as M	on (H.manager = M.id)
			left join models as MO	on (H.model = MO.id)
			left join branches as B	on (H.branch = B.id)
			left join paytype as P	on (H.paytype = P.id)
			left join organization as O on (H.organization = O.id)
			left join regions as R on (H.region = R.id)
		where	H.`id` in {1}
		", $ids);

	if ($required && !count($dat))
		throw new exception_bl('No such record (by id).', $this->outfield.'_absent', 'absent');
	fill_texts($dat,$this->multilang_fields);

	$this->select_details($dat, $details);
	$this->data_prepare ($dat);
}

function data_prepare (&$dat)
{
	foreach($dat as &$data)
	{
		$pay = 0;
		$bad_pays = 0;
		$pay_plan = 0;

		if (isset($data['pays']))
		foreach($data['pays'] as &$v)
		{
			if ($v['status'] == 'yes')
			{
				$pay += $v['summ'];
				$v['pstate'] = 'yes';
			}
			elseif ($v['date'])
			{
				if (date('Y-m-d') > $v['date'])
				{
					$v['pstate'] = 'no';
					$bad_pays += $v['summ'];
				}
				else $v['pstate'] = 'wait';
			}
			
			$pay_plan += $v['summ'];
		}
		$data['debt'] = $data['summ'] - $pay;
		$data['bad_pays'] = $bad_pays;
		
		$data['shipping_time'] = (date('Y-m-d') > $data['shipping_date'] && $data['debt'] == 0 && $data['shipping_status'] == 'no') ? 'bad' : 'good';
		
		$data['full_status'] = ($data['debt'] == 0 && $data['shipping_status'] == 'yes') ? 'finish' : 'work';

		if		($data['cancel']) $data['color_status'] = 'orange';
		elseif		($pay_plan != $data['summ']) $data['color_status'] = 'red';
		elseif	($data['full_status'] == 'finish') $data['color_status'] = 'green';
		elseif	($data['bad_pays'] > 0) $data['color_status'] = 'pink';
		elseif	($data['summ'] > 0) $data['color_status'] = 'light_green';
	}
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

function select_for_select_public (&$dat, $details = null)
{
	$where = '';
	if (!in_array('admin', _identify_::$info['roles']))
	{
		$where = 'where active = true';
	}
	
	$dat = _main_::query($this->outfield, "
		select	concat(H.`name_full`, ' (', P.`lastname`, ')') as `name`, P.`id`
		from	`{$this->table}` as H
		inner	join `profiles` P on (P.`hotel_id` = H.`id`)
		{$where}
		order	by H.`name_full`
		");

	fill_texts($dat,$this->multilang_fields);
	$this->select_details($dat, $details);
}

function select_by_users (&$dat, $ids, $required = null, $details = null)
{
	if (!is_array($ids)) $ids = (array) $ids;
	
	$dat = !count($ids) ? array() : _main_::query($this->outfield, "
		select	H.*,
			CASE WHEN H.active THEN 1
				ELSE 0
			END as active
		from	`{$this->table}` as H
		inner	join `profiles` P on (H.`id` = P.`hotel_id`)
		where	P.`user_id` in {1}
		", $ids);

	if ($required && !count($dat))
		throw new exception_bl('No such record (by id).', $this->outfield.'_absent', 'absent');
	fill_texts($dat,$this->multilang_fields);

	$this->select_details($dat, $details);
}

function select_for_list (&$dat, $filters, $sorters, $pager, $details = null)
{
	$u = _main_::fetchModule('users');

	$limit = $pager->limit();

	$order_clause = convert_sorters_to_sql_order_clause($sorters, 'H');
	$where = $filters->sql_where("H");
	
	if ($u->is('track') && _identify_::$info['branch'])
	{
		$where .= ' and (H.branch = '._identify_::$info['branch'].' or H.manager = '._identify_::$info['id'].' or MO.`type` = 4)';
	}
	elseif ($u->is('rop') && _identify_::$info['branch'])
	{
		$where .= ' and (H.branch = '._identify_::$info['branch'].' or H.manager = '._identify_::$info['id'].')';
	}
	elseif ($u->is('manager'))
	{
		$where .= ' and H.manager = '._identify_::$info['id'];
	}
	
	$dat = _main_::query($this->outfield, "
		select SQL_CALC_FOUND_ROWS
			H.*, M.name as manager, B.name as branch, R.name as region,
			group_concat(MO.name SEPARATOR ', ') as model
		from  
			`{$this->table}` as H
		left join users as M on (H.manager = M.id)
		left join branches as B on (H.branch = B.id)
		left join `_models4payment_` as m4p on (m4p.payment = H.id)
		left join models as MO on (m4p.model = MO.id)
		left join regions as R on (H.region = R.id)
        where {$where}
        group by H.id
		order by {$order_clause}
        {$limit}
	");

	$pager->getTotal();
	$this->select_details($dat, $details);
	$this->data_prepare ($dat);
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
		 'payment'	=> 'select_pays'
		,'models'	=> 'select_models'
		));
}

function select_pays(&$struct, $details = null) { _main_::depend('merges');	$m=_main_::fetchModule('pays'); $m->select_by_payment($dat, get_fields($struct, 'id'), $details); merge_subtable_as_array($struct, $dat, 'pays', 'payment' , 'id'); }
function select_models(&$struct, $details = null) { _main_::depend('merges'); $m=_main_::fetchModule('models');$m->select_by_payments($dat, get_fields($struct, 'id'), $details); merge_subtable_as_array($struct, $dat, 'models', 'payment', 'id'); }

function report ($data)
{
#	$limit = $pager->limit();

	#$order_clause = convert_sorters_to_sql_order_clause($sorters, 'H');
	#$where = $filters->sql_where("H");
	#$join = ($data['client'] == 'all') ? '' : "inner join `pays` as P2 on (H.id = P2.payment and P2.status = 'yes')";
	$join = ($data['client'] == 'all') ? '' : "and H.id in (SELECT distinct `payment` FROM `pays` WHERE `status`='yes' and `approved` = 1)";
	//$join = ($data['client'] == 'all') ? '' : "and H.id in (SELECT distinct `payment` FROM `pays` WHERE `status`='yes')";
	
	$dat = _main_::query($this->outfield, "
		select
			H.*, 
			sum(if(P.`approved` = 0 and P.`date` >= now(), P.summ, 0)) as wait_pays,
			sum(if(P.status = 'yes' and P.`approved` = 1, P.summ, 0)) as have_pays
		from  
			`{$this->table}` as H
		inner join `pays` as P on (H.id = P.payment)
		where P.`date` >= {1} and P.date < {2} + interval 1 day
		{$join}
		group by H.id
		having wait_pays > 0 or have_pays > 0
		order by H.client
	"
	, $data['time_from']
	, $data['time_to']
	);
//			sum(if((P.status is null or P.status != 'yes') and P.`date` >= now(), P.summ, 0)) as wait_pays,
	
	$report = [ 'wait_pays' => [], 'have_pays' => [], 'data' => $dat ];
	
	if ($dat)	
	foreach($dat as $v)
	{
		$report['wait_pays'][$v['currency']] += $v['wait_pays'];
		$report['have_pays'][$v['currency']] += $v['have_pays'];
	}

#	$pager->getTotal();
#	$this->select_details($dat, $details);

	return $report;
}

function sales_report ($from, $to)
{
	$u = _main_::fetchModule('users');
	
	$where = ''; $join = '';
	if ($u->is('track'))
	{
		$join = '
			left join `_models4payment_` as m4p on (m4p.payment = c.id)
			left join models as MO on (m4p.model = MO.id)
		';
		$where .= 'and (c.branch = '._main_::sql_quote(_identify_::$info['branch']).' or MO.`type` = 4)';
	}
	elseif ($u->is('rop'))
	{
		$where .= 'and c.branch = '._main_::sql_quote(_identify_::$info['branch']);
	}
#	$limit = $pager->limit();

	#$order_clause = convert_sorters_to_sql_order_clause($sorters, 'H');
	#$where = $filters->sql_where("H");
	$branches = _main_::query('branch:id', "select * from branches where ".($u->is('admin') ? '1' : 'id = {1}')." order by id", _identify_::$info['branch']);

	list($month, $year) = explode('.', $data['time_from']);
	
	/*
	$from	= $data['from'];
	$to		= $data['to'];
	*/

	/*	
	$dat = _main_::query($this->outfield, "
		select
			c.id
		,	max(p.date) as `date`
		,	c.client
		,	mg.name as manager
		,	r.name as region
		,	sum(if(p.status = 'yes', p.summ, 0)) as have_pays
		,	pt.name as paytype
		,	c.branch
		,	c.currency
		,	c.summ
		,	c.discount
		,	c.active
		from  pays p
		inner join `{$this->table}` as c on (c.id = p.payment)
		left  join `users` as mg on (mg.id = c.manager)
		left  join `regions` as r on (r.id = c.region)
		left  join `paytype` as pt on (pt.id = c.paytype)
		where p.`date` >= {1} and p.date < {2} and p.status = 'yes' and p.`approved` = 1
		{$where}
		group by c.id
		order by c.client
	"
	, $from
	, $to
	);
	*/
	//	inner join `_models4payment_` as m4p on (c.id = m4p.payment)
	
	$dat = _main_::query($this->outfield, "
		select
			c.id
		,	max(p.date) as `date`
		,	c.client
		,	mg.name as manager
		,	r.name as region
		,	sum(if(p.status = 'yes', p.summ, 0)) as have_pays
		,	pt.name as paytype
		,	c.paytype as paytype_id
		,	c.branch
		,	c.currency
		,	c.summ
		,	c.discount
		,	c.active
		,	c.plan_date
		,	c.phone
		,	c.cancel
		from  `{$this->table}` as c
		left  join pays p on (c.id = p.payment)
		left  join `users` as mg on (mg.id = c.manager)
		left  join `regions` as r on (r.id = c.region)
		left  join `paytype` as pt on (pt.id = c.paytype)
		{$join}
		where c.`plan_date` >= {1} and c.plan_date < {2}
		or	p.`date` >= {1} and p.date < {2} and p.status = 'yes' and p.`approved` = 1
		{$where}
		group by c.id
		order by c.client
	"
	, $from
	, $to
	);
	
	$this->select_details($dat, [ 'models' => true ]);
	$total = [ 'summ' => [], 'count' => 0 ];
	$models = [];		
	
	if ($dat)	
	foreach($dat as $f => &$v)
	{
		$track = false;
		if ($v['models'])
		{
			$types = get_fields($v['models'], 'model_type');
			if (in_array('болотоход', $types)) $track = true;
		}
		
		if ($v['branch'] == 6) $track = true;

		if ($v['cancel'] != 1)
		{
			if ($track)
			{
				$total['summ']['track'][$v['currency']] += $v['have_pays'];
			}
			else
			{
				$total['summ']['boat'][$v['currency']] += $v['have_pays'];
			}
			
			$total['count']++;
		}

		/*					
		$rows = _main_::query('pays', "
			select
				sum(if(p.`date` < {2} and p.status = 'yes' and p.`approved` = 1, p.summ, 0)) as wos_pays
			,	sum(if(p.`date` >= {2} and p.`date` < {3} and  p.status = 'yes' and p.`approved` = 1, p.summ, 0)) as have_pays
			,	sum(if(p.`date` >= {2} and p.`date` < {3} and  p.status = 'yes' and p.`approved` = 1 and p.tradein = 'yes', p.summ, 0)) as have_pays_tradein
			,	sum(if(p.`date` >= {2} and p.`date` < {3} and  p.status = 'yes' and p.`approved` = 1 and p.tradein = 'no', p.summ, 0)) as have_pays_no_tradein
			from  pays p
			where payment = {1}
			group by payment
		"
		, $v['id']
		, $from
		, $to
		);
		
		$pays = array_shift($rows);
		*/
		
		$rows = _main_::query('pays', "
			select p.*, pt.name as paytype_name from  pays p
			left  join `paytype` as pt on (pt.id = p.paytype)
			where payment = {1} and p.status = 'yes' and p.`approved` = 1
		"
		, $v['id']
		, $from
		, $to
		);
		
		$tr = $track ? 'track' : 'boat';
		
		$paytypes = [];
		
		$pays = [ 'wos_pays' => 0, 'have_pays' => 0, 'have_pays_tradein' => 0, 'have_pays_no_tradein' => 0 ];
		if ($rows)
		foreach($rows as $pay)
		{
			if ($pay['date'] < $from) $pays['wos_pays'] += $pay['summ'];
			
			if ($pay['date'] >= $from && $pay['date'] < $to)
			{
				$pays['have_pays'] += $pay['summ'];
				
				if ($pay['tradein'] == 'yes')
				{
					$pays['have_pays_tradein'] += $pay['summ'];
					
					if (!isset($total['paytypes'][$tr]['paytype:tradein'])) $total['paytypes'][$tr]['paytype:tradein'] = [ 'name' => 'Трейд ин', 'summ' => [] ];
					$total['paytypes'][$tr]['paytype:tradein']['summ'][$v['currency']] += $pay['summ'];
				}
				else
				{
					$pays['have_pays_no_tradein'] += $pay['summ'];
					
					if (!isset($total['paytypes'][$tr]['paytype:'.$pay['paytype']])) $total['paytypes'][$tr]['paytype:'.$pay['paytype']] = [ 'name' => $pay['paytype_name'], 'summ' => [] ];
					$total['paytypes'][$tr]['paytype:'.$pay['paytype']]['summ'][$v['currency']] += $pay['summ'];
				}
			}
			
			if (!in_array($pay['paytype_name'], $paytypes)) $paytypes[] = $pay['paytype_name'];
		}
		
		$v['paytype'] = join(' / ', $paytypes);
		
		if 		($pays['wos_pays'] == 0 && $pays['have_pays'] > 0 && $pays['have_pays'] < $v['summ'] ) $v['status'] = 'предоплата';
		elseif	($pays['wos_pays'] == 0 && $pays['have_pays'] >= $v['summ']) $v['status'] = 'полная оплата';
		elseif	($pays['wos_pays'] >  0 && ($pays['have_pays'] + $pays['wos_pays']) >= $v['summ'] ) $v['status'] = 'полная доплата';
		elseif	($pays['wos_pays'] >  0) $v['status'] = 'доплата ';

		$v['ost'] = $v['summ'] - ($pays['have_pays'] + $pays['wos_pays']);
		//$v['ost'] = $ost > 0 ? $ost : '';

		/*
		if ($pays['have_pays_no_tradein'])
		{
			if (!isset($total['paytypes'][$tr]['paytype:'.$v['paytype_id']])) $total['paytypes'][$tr]['paytype:'.$v['paytype_id']] = [ 'name' => $v['paytype'], 'summ' => [] ];
			$total['paytypes'][$tr]['paytype:'.$v['paytype_id']]['summ'][$v['currency']] += $pays['have_pays_no_tradein'];
		}
		if ($pays['have_pays_tradein'])
		{
			if (!isset($total['paytypes'][$tr]['paytype:tradein'])) $total['paytypes'][$tr]['paytype:tradein'] = [ 'name' => 'Трейд ин', 'summ' => [] ];
			$total['paytypes'][$tr]['paytype:tradein']['summ'][$v['currency']] += $pays['have_pays_tradein'];
		}
		*/
		
		// План		
		if ($v['cancel'] != 1 && $v['plan_date'] >= $from && $v['plan_date'] < $to || !$v['plan_date'] && $pays['wos_pays'] == 0 && $pays['have_pays'] > 0 && $v['active'] == 1)
		{
			$v['plan'] = 1;

			if ($track)
			{
				$total['contract']['track'][$v['currency']] += $v['summ'];
				$total['discount']['track'][$v['currency']] += $v['discount'];
			}
			else
			{
				$total['contract']['boat'][$v['currency']] += $v['summ'];
				$total['discount']['boat'][$v['currency']] += $v['discount'];
			}
			
			if ($v['models'])
			foreach($v['models'] as &$model)
			{
				$code = '';
				switch($model['model_type'])
				{
					case 'тент':		$code = 'tent'; break;
					case 'кабина':		$code = 'cabin'; break;
					case 'болотоход':	$code = 'bolot'; break;
					case 'прицеп':		$code = 'pricep'; break;
				}
				
				if ($code)
				{
					if (!isset($branches['branch:'.$v['branch']]['counts'][$code])) $branches['branch:'.$v['branch']]['counts'][$code] = [ 'name' => $model['model_type'], 'count' => 0 ];
					$branches['branch:'.$v['branch']]['counts'][$code]['count']++;

					$tr = $track ? 'track' : 'boat';
					if (!isset($total['counts'][$tr][$code])) $total['counts'][$tr][$code] = [ 'name' => $model['model_type'], 'count' => 0 ];
					$total['counts'][$tr][$code]['count']++;
					
					#if (!isset($total['counts'][$tr][$code])) $total['counts'][$tr][$code] = [ 'name' => $model['model_type'], 'count' => 0 ];
					#$total['counts'][$tr][$code]['count']++;
					
				}
			}
		}
		
		$branches['branch:'.$v['branch']]['payments'][$f] = $v;
	}
	$branches['total'] = $total;
		#die;

#	$pager->getTotal();
#	$this->select_details($dat, $details);

	return $branches;
}

function sales_models ($from, $to)
{
	$dat = _main_::query($this->outfield, "
		select
			c.id
		,	MO.name
		,	c.branch
		from  `payment` as c
		left  join pays p on (c.id = p.payment)
		left join `_models4payment_` as m4p on (m4p.payment = c.id)
		left join models as MO on (m4p.model = MO.id)
		where p.`date` >= {1} and p.date < {2} and p.status = 'yes' and p.`approved` = 1
		group by c.id
		order by c.client
	"
	, $from
	, $to
	);
	
	$this->select_details($dat, [ 'models' => true ]);
	
	$models = [];
	
	if ($dat)	
	foreach($dat as $f => &$v)
	{
		$track = false;
		
		if ($v['branch'] == 6) $track = true;
		
		if ($v['models'])
		{
			$types = get_fields($v['models'], 'model_type');
			if (in_array('болотоход', $types)) $track = true;
			
			$tr = $track ? 'track' : 'boat';
			
			foreach($v['models'] as $model)
			{
				$models[$tr]['model:'.$model['id']]['name'] = $model['name'];
				@$models[$tr]['model:'.$model['id']]['count'] += 1;
			}
		}
	}

	return $models;	
}

}
?>