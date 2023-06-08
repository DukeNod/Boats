<?php

$u = _main_::fetchModule('users');
$u->check();

// Читаем и выводим всестраничные данные до начала всех работ.
_main_::depend('_specific_/fetches');
fetch_every_page_content();


	$page = null;
	$id = false;

	if (!$id = array_shift($pathargs))
	{
		throw new exception_bl('No such record (by id).', 'id_absent', 'absent');
	}

	$m = _main_::fetchModule('payment');

	$m->select_for_show($dat, $id, true, true);
	
	
	_main_::put2dom('payment', array_shift($dat));
	
?>
