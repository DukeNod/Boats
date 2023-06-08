<?php
_main_::depend('configs');
_main_::depend('sql');
_main_::depend('_specific_/fetches');
_main_::depend('forms');
_main_::depend('forms_class');
_main_::depend('types_class');

fetch_inlines(array('mailer:sign'));

$id = array_shift($pathargs);

	$fields = array(
		new TextField('name',null,true)
	,	new Email('email',null,true)
	,	new TextField('deviceid')
	);
	
	$errors = [];
	$enums = [];  // убрать нахуй
	
	$form = new Forms($fields);

$dat = _main_::query('row', "
	select	*
	from	`users`
	where	`id` = {01}
", $id);

foreach($dat as $data)
{
	$eee = $form->mail($errors, $data, $doc, $data['email'], 'user_confirm', array(), false);
}

if (in_array('silent', $pathargs)) throw new exception_exit();

?>