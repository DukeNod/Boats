<?php

_main_::depend('configs');
_main_::depend('sql');
$m=_main_::fetchModule('langs');

// Чтение конфига модуля, списков для полей выбора (для валидации и элементов формы) и других данных.
$config = $m->fetch_config();
$enums  = $m->fetch_enums();

// Формируем селекторы списка (фильтры и сортировки).
$filters = array('name'=>'');
$sorters = array('id'=>false);
_main_::put2dom('filters', $filters = get_requested_filters($filters));
_main_::put2dom('sorters', $sorters = get_requested_sorters($sorters));

// Считываем список записей и все их дочерние субтаблицы.
$m->select_for_admin($dat, $filters, $sorters, null, null);

// В DOM!
$dom = $dat;
$dom['@for'] = $m->essence;
_main_::put2dom('list', $dom);

?>