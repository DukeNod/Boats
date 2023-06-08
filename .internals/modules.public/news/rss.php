<?php
$u = _main_::fetchModule('users');
$u->check([ 'admin' ]);

// Подключаем нужные функции.
$m=_main_::fetchModule('news');

// Читаем и выводим запрошенную информацию.
$m->select_for_read($dat, null, null, $pager, array('linked_picts'=>true));
_main_::put2dom('news', $dat);

//
header("Content-type: application/rss+xml");

?>