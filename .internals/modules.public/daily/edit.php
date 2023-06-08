<?php

$u = _main_::fetchModule('users');
$u->check('rop');

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

$m = _main_::fetchModule('daily');


$fields = [
	Forms::MakeField([
		'type' => 'DateField',
		'name' => 'date'
	]),
	($u->is('admin')) ? 
	Forms::MakeField([
		'type' => 'TextField',
		'name' => 'branch'
	]) : [],
	Forms::MakeField([
		'type' => 'TextField',
		'name' => 'visit'
	]),
	Forms::MakeField([
		'type' => 'TextField',
		'name' => 'calls'
	]),
	Forms::MakeField([
		'type' => 'TextField',
		'name' => 'sites'
	]),
	Forms::MakeField([
		'type' => 'TextField',
		'name' => 'lids'
	]),
	Forms::MakeField([
		'type' => 'TextField',
		'name' => 'sales'
	]),
	Forms::MakeField([
		'type' => 'TextField',
		'name' => 'summ'
	]),
	Forms::MakeField([
		'type' => 'TextField',
		'name' => 'rub'
	]),
	Forms::MakeField([
		'type' => 'TextField',
		'name' => 'usd'
	])
];



if ($id)
{
	$m->select_by_ids($dat, $id, true);
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
			_main_::returnJSON([ 'result' => "OK" ]);
		}
	}
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
			_main_::returnJSON([ 'result' => "OK", "id" => $new_id ]);
		}
	} 	
}
die("Error");

?>