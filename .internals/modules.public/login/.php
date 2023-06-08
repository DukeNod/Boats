<?php
$u = _main_::fetchModule('users');
$u->check();

_main_::depend('forms');
_main_::depend('mail');
_main_::depend('gp');
_main_::depend('forms_class');
_main_::depend('types_class');

_main_::depend('_specific_/fetches');
fetch_every_page_content();

if ($pathargs)
print_check($pathargs);

#fetch_inlines ("register:sent");

$u = _main_::fetchModule("users");

// Чтение конфига модуля, списков для полей выбора (для валидации и элементов формы) и других данных.
$config=array();
$enums=array();

$fields = array(
	new TextField('email',null,true), 
	new TextField('password',null,true),
	new TextField('newpassword1'),
	new TextField('newpassword2'),
	new TextField('back'),
	new CheckBox('remember_pass')
);

$form = new Forms($fields);

// Определение запрошенных действий и получение присланных данных.
$errors = array();
#$action = determine_action(null, 'do');
$action = determine_action("login_submit");
if ($action === 'login_submit') $action = 'do'; // Просто костыль
$data   = $form->form_posted($action);

// Типичный сценарий операции: подгонка файлов, проверка значений, и либо обращение к базе, либо временное запоминание.
if (($action !== null)                   )  $form->prepare  ($errors, $data, $config, $enums);
if (($action === 'do') && !count($errors))  $form->validate ($errors, $data, $config, $enums);
if (($action === 'do') && !count($errors))  $u->login ($errors, $data);
if (($action === 'do') && !count($errors))  $_SESSION['delivery_region'] = _identify_::field('delivery_region');
if (($action === 'do') && !count($errors))
{
	if (strpos($_SERVER['PHP_SELF'], '/login/') !== false)
		$u->redirect ($errors, $data);
	else
		return;
}
elseif (($action !== null)               )  $form->remember ($data);

// В DOM!
#list($gp_id, $gp_w, $gp_h) = gp_new_question();

$dom = compact('action', 'data', 'errors', 'gp_id', 'gp_w', 'gp_h');
_main_::put2dom(($action === 'do') && !count($errors) ? 'done' : 'form', $dom);
_main_::put2dom('fields', $form->fields2dom($data));
_main_::put2dom('auth_extended_policy', _config_::$auth_extended_policy);


?>