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

$id = $pathargs[0];

$m = _main_::fetchModule('payment');


$fields = [
	Forms::MakeField([
		'type' => 'CheckBox',
		'name' => 'cancel',
		'title' => 'Отмена',
		'value'	=> 1
	])
];

if ($id)
{
	$m->select_by_ids($dat, $id, true);
	$info = array_shift($dat);
	
	$data['cancel'] = ($info['cancel'] == 1) ? 0 : 1;
	
	$form = new Forms($fields);
	$errors = array();
	
	$m->public_update($errors, $form->fields, $data, $id);
	
	if (!count($errors))
	{
		_main_::Redirect(_config_::$dom_info['pub_site']."payment/".$id."/");
		
	}

	$dom = compact('action', 'data', 'errors');
	_main_::put2dom(($action === 'do') && !count($errors) ? 'done' : 'form', $dom);
}
?>