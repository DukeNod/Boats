<?php

$u = _main_::fetchModule('users');
$u->check('admin');

// Читаем и выводим всестраничные данные до начала всех работ.
_main_::depend('merges');
_main_::depend('sql');

$id = false; $approved = false;

if (isset($pathargs[0]))
{
	$id = $pathargs[0];
}
if (isset($pathargs[1]))
{
	$approved = $pathargs[1];
}

if ($id === false || $approved === false)
{
	die("Error");
}

_main_::query(null, "
	update 	`pays`
	set		`approved` = {2}
	where	`id` = {1}
"
, $id
, $approved);

_main_::returnJSON([ 'result' => "OK", "id" => $id, "approved" => $approved ]);

?>