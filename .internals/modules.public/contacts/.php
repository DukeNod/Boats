<?php
$u = _main_::fetchModule('users');
$u->check([ 'admin' ]);

// Читаем и выводим всестраничные данные до начала всех работ.
_main_::depend('_specific_/fetches');
fetch_every_page_content();
print_check($pathargs);

fetch_inlines(array(
	'contacts:sent',
	'mailer:sign'
));

if ($pathargs)
	throw new exception_bl('No such record (by id).', 'record_absent', 'absent');	

$pathargs=array('contacts');

$p = _main_::fetchModule('pages');
$p->fetch_page($pathargs);

_main_::depend('forms');
_main_::depend('mail');
_main_::depend('gp');
_main_::depend('forms_class');
_main_::depend('types_class');

// Чтение конфига модуля, списков для полей выбора (для валидации и элементов формы) и других данных.
$config=array();
$enums=array();

$fields = array(
	new TextField('name',_identify_::field("first_name"),true),
	new TextField('phone',_identify_::field("phone"),true),
	new TextField('email',_identify_::field("email"), true),
//	new TextField('post',null,true),
	new TextArea ('comments',null,true),
	new Gp('gp')
);

$form = new Forms($fields);
// Определение запрошенных действий и получение присланных данных.
$errors = array();
$action = determine_action(null, 'do');
$data   = array_merge_rol($form->defs(), $form->form_posted($action));

// Типичный сценарий операции: подгонка файлов, проверка значений, и либо обращение к базе, либо временное запоминание.
if (($action !== null)                   )  $form->prepare  ($errors, $data, $config, $enums);
if (($action === 'do') && !count($errors))  $form->validate ($errors, $data, $config, $enums);
if (($action === 'do') && !count($errors))  $form->mail     ($errors, $data, $doc, _config_::$mail_for_contacts, 'contact_applied');
elseif (($action !== null)               )  $form->remember ($data);

// В DOM!
#list($gp_id, $gp_w, $gp_h) = gp_new_question();
#$fields=$form->fields2dom($data);
$dom = compact('action', 'data', 'errors', 'gp_id', 'gp_w', 'gp_h');
_main_::put2dom(($action === 'do') && !count($errors) ? 'done' : 'form', $dom);
_main_::put2dom('fields', $form->fields2dom($data));

?>