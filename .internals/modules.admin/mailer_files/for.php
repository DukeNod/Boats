<?php

_main_::depend('configs');
_main_::depend('sql');
_main_::depend('mailer_files//reads');
_main_::depend('mailer_files//commons');

// Определение запрошенных действий и получение присланных данных.
$data   = array('mailer_task' => isset($pathargs[0]) ? $pathargs[0] : null);

// Чтение конфига модуля, списков для полей выбора (для валидации и элементов формы) и других данных.
fetch_mailer_file_config($pathinfo[0], $config);
fetch_mailer_file_enums($enum, $data['mailer_task']);
fetch_mailer_file_uplink($data['mailer_task'], $uplink);

// Формируем селекторы списка (фильтры и сортировки).
$filters = array('name'=>'');
$sorters = array('position'=>false, 'id'=>false, 'name'=>false, 'attach_size'=>false, 'attach_file'=>false, 'attach_type'=>false);
_main_::put2dom('filters', $filters = get_requested_filters($filters));
_main_::put2dom('sorters', $sorters = get_requested_sorters($sorters));

// Считываем список записей и все их дочерние субтаблицы.
$filters['mailer_task'] = array($data['mailer_task']);
select_mailer_files_for_admin($dat, $filters, $sorters);

// В DOM!
_main_::put2dom('list', $dat);

?>