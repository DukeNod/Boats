<?php

_main_::depend('configs');
_main_::depend('sql');
_main_::depend('subscribers//reads');
_main_::depend('subscribers//commons');

// Чтение конфига модуля, списков для полей выбора (для валидации и элементов формы) и других данных.
fetch_subscriber_config($pathinfo[0], $config);
fetch_subscriber_enums($enum);

// Формируем селекторы списка (фильтры и сортировки).
$filters = array('email'=>'', 'is_active'=>array(), 'is_tester'=>array());
$sorters = array('email'=>false, 'id'=>false, 'is_active'=>false, 'is_tester'=>false, 'request_ts'=>false, 'confirm_ts'=>false);
_main_::put2dom('filters', $filters = get_requested_filters($filters));
_main_::put2dom('sorters', $sorters = get_requested_sorters($sorters));

// Формируем листатель страниц (только после того как сформированы селекторы, потому что они влияют).
$pager = array('size'=>$config['pager_size'], 'count'=>count_subscribers_for_admin($filters, $sorters));
_main_::put2dom('pager', $pager = get_requested_pager($pager));

// Считываем список записей и все их дочерние субтаблицы.
select_subscribers_for_admin($dat, $filters, $sorters, $pager);

// В DOM!
_main_::put2dom('list', $dat);

?>