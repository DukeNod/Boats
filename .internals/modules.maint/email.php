<?php
_main_::depend('configs');
_main_::depend('sql');
_main_::depend('_specific_/fetches');

fetch_inlines(array('mailer:sign'));

$m=_main_::fetchModule('cards');

$dat = _main_::query('row', "
	select	*
	from	`users`
	where	`confirm` = 1
	and	(`anketa` is null or `anketa` = 0)
	and	`card` is null
	and	`sent` is null
");

foreach($dat as $data)
{
	$m->mail($errors, $data, $doc, $data['email'], 'card_confirm', array(), false);
	_main_::query(null, "
		update	`users`
		set	`sent`  = 1
		where	`id` = {1}
	", $data['id']);

	_main_::commit();

	sleep(2);
}

if (in_array('silent', $pathargs)) throw new exception_exit();

?>