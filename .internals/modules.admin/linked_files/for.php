<?php

_main_::depend('configs');
_main_::depend('sql');
_main_::depend('linked_files//reads');
_main_::depend('linked_files//commons');

// Определение запрошенных действий и получение присланных данных.
$data   = array('uplink_type' => array_shift($pathargs),
		'uplink_id'   => array_shift($pathargs));

// Чтение конфига модуля, списков для полей выбора (для валидации и элементов формы) и других данных.
$config = fetch_config_for_linked_files($data['uplink_type']);
$enums  = fetch_enums_for_linked_files ($data['uplink_type'], $data['uplink_id']);
$uplink = fetch_uplink_for_linked_files($data['uplink_type'], $data['uplink_id']);

// Формируем селекторы списка (фильтры и сортировки).
$filters = array('name'=>'');
$sorters = array('position'=>false, 'id'=>false, 'name'=>false, 'attach_size'=>false, 'attach_file'=>false, 'attach_type'=>false);
_main_::put2dom('filters', $filters = get_requested_filters($filters));
_main_::put2dom('sorters', $sorters = get_requested_sorters($sorters));

// Считываем список записей и все их дочерние субтаблицы.
$filters['uplink_type'] = array($data['uplink_type']);
$filters['uplink_id'  ] = array($data['uplink_id'  ]);
select_linked_files_for_admin($dat, $filters, $sorters, null, null);

// В DOM!
$dom = $dat;
$dom['@for'] = 'linked_files';
_main_::put2dom('list', $dom);

?>