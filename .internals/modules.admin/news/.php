<?php

_main_::depend('configs');
_main_::depend('sql');
$m=_main_::fetchModule('news');

$group = (isset($_GET['group'])) ? $_GET['group'] : 'news';
// Чтение конфига модуля, списков для полей выбора (для валидации и элементов формы) и других данных.
$config = $m->fetch_config();
$enums  = $m->fetch_enums();

// Формируем селекторы списка (фильтры и сортировки).
#$filters = array('group'=>$group, 'domain'=>LANG_ID, 'title'=>'', 'short'=>'');
$filters = array('title'=>'', 'short'=>''); //'group'=>$group, 
$sorters = array('ts'=>true, 'id'=>false, 'title'=>false);
_main_::put2dom('filters', $filters = get_requested_filters($filters));
_main_::put2dom('sorters', $sorters = get_requested_sorters($sorters));

// Считываем список записей и все их дочерние субтаблицы.
$m->select_for_admin($dat, $filters, $sorters, null, null);

// В DOM!
$dom = $dat;
$dom['@for'] = $m->essence;
_main_::put2dom('list', $dom);
_main_::put2dom('news_group', $group);

?>