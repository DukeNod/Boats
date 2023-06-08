<?php

$u = _main_::fetchModule('users');
$u->check();

// Читаем и выводим всестраничные данные до начала всех работ.
_main_::depend('_specific_/fetches');
_main_::depend('forms');
_main_::depend('forms_class');
_main_::depend('types_class');
_main_::depend('merges');
_main_::depend('sql');
_main_::depend('embed_files');
fetch_every_page_content();

$id = false;

if (isset($pathargs[0]))
{
	$id = $pathargs[0];
}

$m = _main_::fetchModule('payment');
/*
$fields = [
	Forms::MakeField([
			'type' => 'SelectList'
		,	'name' => 'branch'
		,	'title' => 'Филиал'
		,	'empty' => 'Выберите из списка'
		,	'linked_module' => 'dictionaries'
		,	'select_function' => 'branches'
		,	'value' => _identify_::$info['branch']
	])
];

$form = new Forms($fields);
	$form->fetch_enums($enums, $data);
debug($form->fields2dom($data));die;
*/
$fields = [
	Forms::MakeField([
		'type' => 'TextFieldPrefix'
	,	'name' => 'phone'
	,	'title' => 'Номер телефона'
	,	'prefix' => '+7 '
	,	'placeholder' => "ххх ххх хх хх"
	,	'regexp' => "\\d\\d\\d \\d\\d\\d \\d\\d \\d\\d"
	]),
	Forms::MakeField([
		'type' => 'TextField',
		'name' => 'client',
		'title' => 'Клиент (ФИО или название юрлица)',
		'required' => true
	]),
	Forms::MakeField([
		'type' => 'TextField',
		'name' => 'contract_number',
		'title' => 'Номер договора',
		'placeholder' => 'Оставьте пустым для автоматического заполнения'
//		'required' => true
	]),
	Forms::MakeField([
		'type' => 'DateField',
		'name' => 'contract_date',
		'title' => 'Дата заключения договора',
		//'required' => true
	]),
	($u->is('admin')) ? 
	Forms::MakeField([
			'type' => 'SelectList'
		,	'name' => 'branch'
		,	'title' => 'Филиал'
		,	'empty' => 'Выберите из списка'
		,	'linked_module' => 'dictionaries'
		,	'select_function' => 'branches'
		,	'value' => _identify_::$info['branch']
	]) : [],
	Forms::MakeField([
			'type' => 'SelectList'
		,	'name' => 'region'
		,	'title' => 'Регион'
		,	'empty' => 'Выберите из списка'
		,	'linked_module' => 'dictionaries'
		,	'select_function' => 'regions'
	]),
	($u->is('admin') || $u->is('rop')) ? 
	Forms::MakeField([
			'type' => 'SelectList'
		,	'name' => 'manager'
		,	'title' => 'Менеджер'
		,	'required' => true
		,	'empty' => 'Выберите из списка'
		,	'linked_module' => 'dictionaries'
		,	'select_function' => 'managers'
		,	'value' => _identify_::$info['id']
	]) : [],
	/*
	Forms::MakeField([
			'type' => 'SelectList'
		,	'name' => 'model'
		,	'title' => 'Модель катера'
		,	'required' => true
		,	'empty' => 'Выберите из списка'
		,	'linked_module' => 'dictionaries'
		,	'select_function' => 'models'
	]),
	*/
	Forms::MakeField([
			'type' => 'ItemsList'
		,	'name' => 'models'
		,	'title' => 'Модель катера'
		,	'required' => true
		,	'empty' => 'Выберите из списка'
		//,	'linked_module' => 'dictionaries'
		//,	'select_function' => 'models'
		
		,	'linked_module'	=> 'models'
		,	'table'		=> '_models4payment_'
		,	'id_field'	=> 'payment'
		,	'link_field'	=> 'model'
		,	'outfield'	=> 'model'
	]),
	Forms::MakeField([
		'type' => 'Select',
		'name' => 'type',
		'title' => 'Новый/БУ',
		'required' => true,
		'values_list' =>
		[
			 'новый'	=> 'новый'
			,'б/у'		=> 'б/у'
		]
	]),
	Forms::MakeField([
		'type' => 'TextField',
		'name' => 'boat_number',
		'title' => 'Номер катера'
		//'required' => true
	]),
	Forms::MakeField([
		'type' => 'Select',
		'name' => 'avail',
		'title' => 'Наличие / Заказ'
	,	'values_list' => [
			'' => ' '
		,	'yes' => 'В наличии'
		,	'no' => 'Под заказ'
		]
	]),
	Forms::MakeField([
		'type' => 'Select',
		'name' => 'slugebka',
		'title' => 'Служебка'
	,	'values_list' => [
			'' => ' '
		,	'sent' => 'Отправлена'
		,	'not sent' => 'Не отправлена'
		]
	]),
	Forms::MakeField([
			'type' => 'SelectList'
		,	'name' => 'paytype'
		,	'title' => 'Форма оплаты'
		//,	'required' => true
		,	'empty' => 'Выберите из списка'
		,	'linked_module' => 'dictionaries'
		,	'select_function' => 'paytypes'
	]),
	Forms::MakeField([
			'type' => 'SelectList'
		,	'name' => 'organization'
		,	'title' => 'Организация'
		//,	'required' => true
		,	'empty' => 'Выберите из списка'
		,	'linked_module' => 'dictionaries'
		,	'select_function' => 'organizations'
	]),
	Forms::MakeField([
		'type' => 'Select',
		'name' => 'docs',
		'title' => 'Документы отданы клиенту'
	,	'values_list' => [
			'' => ''
		,	'yes' => 'Да'
		,	'no' => 'Нет'
		]
	]),
	Forms::MakeField([
		'type' => 'Select',
		'name' => 'docs_buh',
		'title' => 'Документы отданы в бухгалтерию'
	,	'values_list' => [
			'' => ''
		,	'yes' => 'Да'
		,	'no' => 'Нет'
		]
	]),
	Forms::MakeField([
		'type' => 'TextField',
		'name' => 'summ',
		'title' => 'Сумма к оплате',
		//'required' => true
	]),
	Forms::MakeField([
		'type' => 'Select',
		'name' => 'currency',
		'title' => 'Валюта'
	,	'values_list' => [
			'rub' => '₽'
		,	'usd' => '$'
		,	'euro' => '€'
		]
	]),
	Forms::MakeField([
		'type' => 'TextField',
		'name' => 'discount',
		'title' => 'Размер скидки',
		//'required' => true
	]),
	Forms::MakeField([
		'type' => 'DateField'
	,	'name' => 'shipping_date'
	,	'title' => 'Планируемая дата отгрузки'
	//,	'required' => true
	]),
	Forms::MakeField([
		'type' => 'Select',
		'name' => 'shipping_status',
		'title' => 'Статус отгрузки'
	,	'values_list' => [
			'' => ''
		,	'yes' => 'Да'
		,	'no' => 'Нет'
		]
	]),
	/*
	Forms::MakeField([
		'type' => 'TextField',
		'name' => 'tradein',
		'title' => 'Трейд ин (сумма зачета)'
	]),
	Forms::MakeField([
		'type' => 'TextField',
		'name' => 'tradein_obj',
		'title' => 'Трейд ин - предмет зачета'
	]),
	*/
	Forms::MakeField([
		'type' => 'TextField',
		'name' => 'gift',
		'title' => 'Подарок (что дарили)'
	]),
	Forms::MakeField([
		'type' => 'TextField',
		'name' => 'gift_summ',
		'title' => 'Подарок (сумма подарка)'
	]),
	($u->is('admin')) ? 
	Forms::MakeField([
		'type' => 'CheckBox',
		'name' => 'active',
		'title' => 'Считать в план',
		'value'	=> 1
	]) : [],
	($u->is('admin')) ? 
	Forms::MakeField([
		'type' => 'DateField'
	,	'name' => 'plan_date'
	,	'title' => 'В план на дату'
	//,	'required' => true
	]) : [],
	Forms::MakeField([
		'type' => 'TextButton',
		'name' => 'subbutton',
		'title' => 'Сохранить',
		'nodb'	=> true
	])
];



if ($id)
{
	$m->select_by_ids($dat, $id, true, [ 'models' => true ]);
	$info = array_shift($dat);
	$config=array();
	
	$form = new Forms($fields);
	$errors = array();
	$action = determine_action(null, 'do');
	$data = array_merge_rol($form->defs(), $info, $form->form_posted($action));

	$enums = [];
	$form->fetch_enums($enums, $data);
	
	if (($action !== null))						$form->prepare  ($errors, $data, $config, $enums);
	if (($action === 'do') && !count($errors))	$form->validate ($errors, $data, $config, $enums);
	if (($action === 'do') && !count($errors))
	{
		$m->public_update($errors, $form->fields, $data, $id);
		if (!count($errors))
		{
			$form->post_update($id, $data);
			_main_::Redirect(_config_::$dom_info['pub_site']."payment/$id/");
		}
	}

	$dom = compact('action', 'data', 'errors');
	_main_::put2dom(($action === 'do') && !count($errors) ? 'done' : 'form', $dom);
	_main_::put2dom('fields', $form->fields2dom($data));

}
else
{
	
	$config=array();
	
	$form = new Forms($fields);
	$errors = array();
	
	$action = determine_action(null, 'do');
	#$data = $form->form_posted($action);
	$data = array_merge_rol($form->defs(), $form->form_posted($action));

	$enums = [];
	$form->fetch_enums($enums, $data);
	
	if (($action !== null))						$form->prepare  ($errors, $data, $config, $enums);
	if (($action === 'do') && !count($errors))	$form->validate ($errors, $data, $config, $enums);
	if (($action === 'do') && !count($errors))
	{
		$new_id = "";
		$m->public_insert($errors, $form->fields, $data, $new_id);
		
		if (!count($errors))
		{
			$form->post_update($new_id, $data);
			
			_main_::Redirect(_config_::$dom_info['pub_site']."payment/$new_id");
		}
	} 
	
	$dom = compact('action', 'data', 'errors');
	_main_::put2dom(($action === 'do') && !count($errors) ? 'done' : 'form', $dom);
	_main_::put2dom('fields', $form->fields2dom($data));
}
?>