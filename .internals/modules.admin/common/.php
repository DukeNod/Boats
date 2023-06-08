<?php

_main_::depend('configs');
_main_::depend('sql');
_main_::depend('pager');

$module_name = array_shift($pathargs);
$m = _main_::fetchModule($module_name);

if (count($pathargs))
{
	header("HTTP/1.0 404 Not Found");
	_main_::put2dom('unknown');
	return;
}

// Чтение конфига модуля, списков для полей выбора (для валидации и элементов формы) и других данных.
$config = $m->fetch_config();
$m->fetch_enums($enums, $null2);

// Формируем селекторы списка (фильтры и сортировки).
#$filters = $m->admin_filters;
$sorters = $m->admin_sorters;
#_main_::put2dom('filters', $filters = get_requested_filters($filters));
_main_::put2dom('filters', $filters = $m->get_filters());
_main_::put2dom('sorters', $sorters = get_requested_sorters($sorters));

$pager = new Pager($m->on_page);
$pager->setPage(isset($_GET['page']) ? $_GET['page'] : null);

// Считываем список записей и все их дочерние субтаблицы.
try{
	$m->select_for_admin($dat, $filters, $sorters, $pager, $m->admin_list_details);
}
catch (exception_bl $exception)
{
	if ($exception->getType()=='absent' && $exception->getId() == 'page_absent') {
		$pager->setPage(1);
		$m->select_for_admin($dat, $filters, $sorters, $pager, $m->admin_list_details);
	}else
	{
		throw new exception_bl($exception->getMessage(), $exception->getId(), $exception->getMessage());
	}
}
// В DOM!
$dom = $dat;
$dom['@for'] = $m->essence;
_main_::put2dom('list', $dom);
_main_::put2dom('module', $m->fields2dom($null));
_main_::put2dom('pager', $pager->toDOM());

if (isset($_GET['ajax']) && $_GET['ajax'] == 1)
	_main_::set_module_xslt("/common/ajax");
else
	_main_::set_module_xslt("/common");

?>
