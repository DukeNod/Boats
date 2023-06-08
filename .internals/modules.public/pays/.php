<?php

$u = _main_::fetchModule('users');
$u->check();

_main_::depend('sql');
_main_::depend('pager');
_main_::depend('filters_class');
_main_::depend('validations');

// Читаем и выводим всестраничные данные до начала всех работ.
_main_::depend('_specific_/fetches');
fetch_every_page_content();

$page = null;
if (isset($pathargs[0]) && (strtolower($pathargs[0]) == 'page'))
{
	array_shift($pathargs);
	$page = isset($pathargs[0]) ? array_shift($pathargs) : null;
}

$filters_fields = [];

if (count($pathargs))
{
	_main_::set_module_file("/404/");
	_main_::set_module_xslt("/404/");
	_main_::execute_module();
}
else
{

	$m = _main_::fetchModule('pays');

	$filters_fields["approved"] = new Select("approved", '0'); // Тип данных дефолта имеет значение. Но какое - не помню.
	$filters_fields["approved"]->title = 'Подтвержденные';
	#$filters_fields["approved"]->empty = 'Все';
	$filters_fields["approved"]->mapping = "P.approved";
	$filters_fields["approved"]->cond = "=";
	$filters_fields["approved"]->values_list = [
		0 => 'Нет'
	,	1 => 'Да'
	,	'' => 'Все'
	];
	
	$filters_fields["client"] = new TextField("client", '');
	$filters_fields["client"]->title = "Клиент";
	
	$filters_fields["contract_number"] = new TextField("contract_number", '');
	$filters_fields["contract_number"]->title = "Номер договора";
	
	$filters_fields["from"] = new DateField("from", '');
	$filters_fields["from"]->title = "с";
	$filters_fields["from"]->cond = ">=";
	$filters_fields["from"]->sql_field = "date";

	$filters_fields["to"] = new DateField("to", '');
	$filters_fields["to"]->title = "по";
	$filters_fields["to"]->cond = "<=";
	$filters_fields["to"]->sql_field = "date";
	
	$filters_fields["boat_number"] = new TextField("boat_number", '');
	$filters_fields["boat_number"]->title = "Номер катера";
	
	$filters_fields["branch"] = new SelectList("branch", "");
	$filters_fields["branch"]->title = 'Филиал';
	$filters_fields["branch"]->empty = 'не учитывать';
	$filters_fields["branch"]->linked_module = 'dictionaries';
	$filters_fields["branch"]->select_function = 'branches';


	$filters_fields["pfrom"] = new DateField("pfrom", '');
	$filters_fields["pfrom"]->title = "с";
	$filters_fields["pfrom"]->cond = ">=";
	#$filters_fields["pfrom"]->sql_field = "P.date";
	$filters_fields["pfrom"]->mapping = "P.date";

	$filters_fields["pto"] = new DateField("pto", '');
	$filters_fields["pto"]->title = "по";
	$filters_fields["pto"]->cond = "<=";
#	$filters_fields["pto"]->sql_field = "P.date";
	$filters_fields["pto"]->mapping = "P.date";
	
	//$filters = new Filters([]);
	$filters = new Filters($filters_fields);

	$filters_data = $filters->get_filters();

	$sorters = array(
		'pdate' => true
	,	'psumm' => false
	,	'client' => false
	,	'contract_number' => false
	,	'branch' => false
	,	'manager' => false
	,	'model' => false
	,	'paytype' => false
	,	'tradein_obj' => false
	);
	_main_::put2dom('sorters', $sorters = get_requested_sorters($sorters));

	$pager = new Pager(250);
	$pager->setPage($page);
	
	$m->select_for_approved($dat, $filters, $sorters, $pager, true);

	_main_::put2dom('list', $dat);
	_main_::put2dom('pager', $pager->toDOM());
	_main_::put2dom('filters', $filters->fields2dom());

	_main_::put2dom('main');
}
	
?>