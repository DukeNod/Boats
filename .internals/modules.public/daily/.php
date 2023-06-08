<?php

$u = _main_::fetchModule('users');
$u->check('rop');

// Читаем и выводим всестраничные данные до начала всех работ.
_main_::depend('configs');
_main_::depend('sql');
_main_::depend('types_class');
_main_::depend('filters_class');
_main_::depend('_specific_/fetches');
fetch_every_page_content();

$filters_fields["branch"] = new TextField("branch", '');
#if ($u->is('rop'))
#	$filters_fields["branch"]->value = 	_identify_::$info['branch'];

$filters_fields["time"]=new DateField("time", '');
$filters_fields["time"]->title="Месяц";
$filters_fields["time"]->value = date("m.Y", mktime(0, 0, 0, date("m"), 1, date("Y")));
$filters_fields["time"]->format = 'MM.YYYY';
$filters_fields["time"]->submit = 1;

$filters = new Filters($filters_fields);

$filters_data = $filters->get_filters();

if ($u->is('rop'))
	$filters_data["branch"] = _identify_::$info['branch'];
	
$m = _main_::fetchModule('daily');

$report = $m->select_for_report($filters_data);

_main_::put2dom('filters', $filters->fields2dom());
_main_::put2dom('report', $report);
?>
