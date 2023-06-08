<?php

$u = _main_::fetchModule('users');
$u->check();

// Читаем и выводим всестраничные данные до начала всех работ.
_main_::depend('_specific_/fetches');
_main_::depend('forms');
_main_::depend('forms_class');
_main_::depend('types_class');
_main_::depend('embed_files');
fetch_every_page_content();

$id = false;

if (isset($pathargs[0]))
{
	$payment_id = $pathargs[0];
}
else
{
		throw new exception_bl('No such record (by id).', 'record_absent', 'absent');	
}

if (isset($pathargs[1]))
{
	$id = $pathargs[1];
}

$m = _main_::fetchModule('pays');
$p = _main_::fetchModule('payment');

$p->select_by_ids($pdat, $payment_id, true);

$payment = array_shift($pdat);

$fields = [
	Forms::MakeField([
		'type' => 'DateField',
		'name' => 'date',
		'title' => 'Дата',
		//'required' => true
	]),
	Forms::MakeField([
		'type' => 'TextField',
		'name' => 'summ',
		'title' => 'Сумма',
		//'required' => true
	]),
	Forms::MakeField([
			'type' => 'SelectList'
		,	'name' => 'paytype'
		,	'title' => 'Форма оплаты'
		//,	'required' => true
		,	'empty' => 'Выберите из списка'
		,	'linked_module' => 'dictionaries'
		,	'select_function' => 'paytypes'
		,	'value' => $payment['paytype']
	]),
	Forms::MakeField([
		'type' => 'Select',
		'name' => 'status',
		'title' => 'Статус оплаты'
	,	'values_list' => [
			'' => ' '
		,	'yes' => 'Оплачено'
		,	'no' => 'Не оплачено'
		]
	]),
	Forms::MakeField([
		'type' => 'Select',
		'name' => 'tradein',
		'title' => 'Трейд ин'
	,	'values_list' => [
			'no' => 'Нет'
		,	'yes' => 'Да'
		]
	]),
	Forms::MakeField([
		'type' => 'TextField',
		'name' => 'tradein_obj',
		'title' => 'Трейд ин - предмет зачета'
	]),
	Forms::MakeField([
		'type' => 'TextButton',
		'name' => 'subbutton',
		'title' => 'Сохранить',
		'nodb'	=> true
	])
];

/*
update `pays` p, `payment` c
set p.paytype=c.paytype
where p.payment = c.id
*/

if ($id)
{
	$m->select_by_ids($dat, $id, true);
	$info = array_shift($dat);
	$config=array();
	
	if (!$u->is('admin') && $info['approved'] == 1)
	{
		throw new exception_bl('No such record (by id).', 'record_absent', 'absent');	
	}
	
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
		if ($info['summ'] < 0) $data['refund'] = 1;
		$m->public_update($errors, $fields, $data, $id);
		_main_::Redirect(_config_::$dom_info['pub_site']."payment/".$data['payment']."/");
		
	}

	if ($data['summ'] < 0)
	{
		$data['summ'] *= -1;
		_main_::put2dom('refund', 1);
	}
		
	$dom = compact('action', 'data', 'errors');
	_main_::put2dom(($action === 'do') && !count($errors) ? 'done' : 'form', $dom);
	_main_::put2dom('fields', $form->fields2dom($data));
	_main_::put2dom('payment', $payment);

}
else
{
	
	$config=array();
	
	$form = new Forms($fields);
	$errors = array();
	
	$action = determine_action(null, 'do');
	$data = $form->form_posted($action);

	$enums = [];
	$form->fetch_enums($enums, $data);
	
	if (($action !== null))						$form->prepare  ($errors, $data, $config, $enums);
	if (($action === 'do') && !count($errors))	$form->validate ($errors, $data, $config, $enums);
	if (($action === 'do') && !count($errors))
	{
		if ($_GET['refund'] == 1) $data['refund'] = 1;
		$data['payment'] = $payment_id;
		$m->public_insert($errors, $fields, $data, $new_id);
		
		_main_::Redirect(_config_::$dom_info['pub_site']."payment/$payment_id/");
	} 

	if ($_GET['refund'] == 1)	
		_main_::put2dom('refund', 1);

	$dom = compact('action', 'data', 'errors');
	_main_::put2dom(($action === 'do') && !count($errors) ? 'done' : 'form', $dom);
	_main_::put2dom('fields', $form->fields2dom(null));
	_main_::put2dom('payment', $payment);
}
?>