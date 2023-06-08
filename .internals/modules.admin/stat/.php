<?php
_main_::depend('configs');
_main_::depend('sql');
_main_::depend('types_class');
_main_::depend('filters_class');

$m = _main_::fetchModule('requests');

$filters_fields["from"] = new DateField("from", '');
$filters_fields["from"]->title = "С";

$filters_fields["to"] = new DateField("to", '');
$filters_fields["to"]->title = "По";
$filters_fields["to"]->daytime = 24*3600-1;

$filters = new Filters($filters_fields);

$filters_data = $filters->get_filters();

_main_::put2dom('filters', $filters->fields2dom());

_main_::put2dom('stat', $m->get_stat($filters_data));
?>