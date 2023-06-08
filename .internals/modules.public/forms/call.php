<?php
$u = _main_::fetchModule('users');
$u->check([ 'admin' ]);

// Читаем и выводим всестраничные данные до начала всех работ.
_main_::depend('_specific_/fetches');

fetch_inlines(array(
	'mailer:sign'
));

$f = _main_::fetchModule('forms_list');

$form = $f->get_form_by_mr('call');
$action = determine_action(null, 'do');
$data   = $form->form_posted($action);
//if ($action == 'do') $data['orders']
$f->make_form_action($form, $data, $doc, $action, _config_::$mail_for_contacts, 'common_applied');

?>