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

	$m = _main_::fetchModule('payment');


	_main_::depend('sql');
	_main_::depend('pager');
	_main_::depend('filters_class');

	$filters_fields["client"] = new TextField("client", '');
	$filters_fields["client"]->title = "Клиент";
	
	$filters_fields["contract_number"] = new TextField("contract_number", '');
	$filters_fields["contract_number"]->title = "Номер договора";
	
	$filters_fields["boat_number"] = new TextField("boat_number", '');
	$filters_fields["boat_number"]->title = "Номер катера";
	
	$filters_fields["from"] = new DateField("from", '');
	$filters_fields["from"]->title = "с";
	$filters_fields["from"]->cond = ">=";
	$filters_fields["from"]->sql_field = "contract_date";

	$filters_fields["to"] = new DateField("to", '');
	$filters_fields["to"]->title = "по";
	$filters_fields["to"]->cond = "<=";
	$filters_fields["to"]->sql_field = "contract_date";
	
	$filters_fields["branch"] = new SelectList("branch", "");
	$filters_fields["branch"]->title = 'Филиал';
	$filters_fields["branch"]->empty = 'не учитывать';
	$filters_fields["branch"]->linked_module = 'dictionaries';
	$filters_fields["branch"]->select_function = 'branches';
	/*
	$list_filter =  isset($pathargs[0]) && ($pathargs[0] == 'rf' || $pathargs[0] == 'ino') ? array_shift($pathargs) : '';
	$page =  isset($pathargs[0]) && (strtolower($pathargs[0]) == 'page') && isset($pathargs[1]) ? $pathargs[1] : null;

	$filters_fields["both_names"] = new AutocompleteField("both_names", '');
	$filters_fields["both_names"]->title = "Название / Юр. лицо";
	$filters_fields["both_names"]->placeholder = "не учитывать";
	$filters_fields["both_names"]->autocomplete = [ 'url' => 'search/hotelsboth.php' ];
	$filters_fields["both_names"]->mapping = "H.id";
	$filters_fields["both_names"]->cond = "=";
	$filters_fields["both_names"]->linked_module = "hotels";
	$filters_fields["both_names"]->select_function = "select_for_filters_both_names";

	$filters_fields["address"] = new AutocompleteField("address", '');
	$filters_fields["address"]->title = "Адрес";
	$filters_fields["address"]->placeholder = "не учитывать";
	$filters_fields["address"]->autocomplete = [ 'url' => 'search/hotelsaddr.php' ];
	$filters_fields["address"]->mapping = "H.id";
	$filters_fields["address"]->cond = "=";
	$filters_fields["address"]->linked_module = "hotels";
	$filters_fields["address"]->select_function = "select_for_filters_address";

	$filters_fields["from"] = new DateTimeField("from", '');
	$filters_fields["from"]->title = "с";
	$filters_fields["from"]->cond = ">=";
	$filters_fields["from"]->sql_field = "created_at";

	$filters_fields["to"] = new DateTimeField("to", '');
	$filters_fields["to"]->title = "по";
	$filters_fields["to"]->cond = "<=";
	$filters_fields["to"]->sql_field = "created_at";

	$filters_fields["fms_code"] = new TextField("fms_code", '');
	$filters_fields["fms_code"]->title = "Идентификатор пользователя поставщика";

	$filters_fields["hotelier"] = new AutocompleteField("hotelier", '');
	$filters_fields["hotelier"]->title = "ФИО отельера";
	$filters_fields["hotelier"]->placeholder = "не учитывать";
	$filters_fields["hotelier"]->autocomplete = [ 'url' => 'search/hoteliers.php' ];
	$filters_fields["hotelier"]->mapping = "U.id";
	$filters_fields["hotelier"]->cond = "=";
	$filters_fields["hotelier"]->linked_module = "users";
	$filters_fields["hotelier"]->select_function = "select_for_filters";
	*/	


	//$filters = new Filters([]);
	$filters = new Filters($filters_fields);

	$filters_data = $filters->get_filters();

	$sorters = array(
		'contract_date' => true
	,	'client' => false
	,	'contract_number' => false
	,	'branch' => false
	,	'manager' => false
	,	'model' => false
	,	'type' => false
	,	'boat_number' => false
	);
	_main_::put2dom('sorters', $sorters = get_requested_sorters($sorters));

	$pager = new Pager(50);
	$pager->setPage($page);
	
	$m->select_for_list($dat, $filters, $sorters, $pager, true);

	_main_::put2dom('list', $dat);
	_main_::put2dom('pager', $pager->toDOM());
	_main_::put2dom('filters', $filters->fields2dom());

	_main_::put2dom('main');
}
	
?>