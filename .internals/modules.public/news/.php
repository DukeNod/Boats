<?php
$u = _main_::fetchModule('users');
$u->check([ 'admin' ]);

// Читаем и выводим всестраничные данные до начала всех работ.
_main_::depend('_specific_/fetches');
print_check($pathargs);
fetch_every_page_content();

//if (!$pathargs)
//{
	$p = _main_::fetchModule('pages');
	$p->fetch_page(array('news'));
//}

// Подключаем нужные функции.
$m=_main_::fetchModule('news');
_main_::depend('pager');

global $domain_id;

// Читаем и выводим запрошенную информацию.
$news_id =  isset($pathargs[0]) && (strtolower($pathargs[0]) != 'page')? $pathargs[0] : null;
$page       =  isset($pathargs[0]) && (strtolower($pathargs[0]) == 'page') && isset($pathargs[1]) ? $pathargs[1] : null;

if(isset($pathargs[0]) && (strtolower($pathargs[0]) == 'page') && (!isset($pathargs[1])))
	throw new exception_bl('No such record (by id).', 'record_absent', 'absent');

/*$id   = isset($pathargs[0]) && (strtolower($pathargs[0]) != 'page')                        ? $pathargs[0] : null;
$page = isset($pathargs[0]) && (strtolower($pathargs[0]) == 'page') && isset($pathargs[1]) ? $pathargs[1] : null;
$size = _config_::$news_per_page;*/


if ($news_id===null)
{
	$pager = new Pager(_config_::$news_per_page);
	$pager->setPage($page);

	$m->select_news_by_page($dat, $group, $pager, true);

	_main_::put2dom('list', $dat);
	_main_::put2dom('pager', $pager->toDOM());
}
else
{
	$m->select_by_ids($dat, $news_id, true, true);
	_main_::put2dom('news', array_shift($dat));
}

?>