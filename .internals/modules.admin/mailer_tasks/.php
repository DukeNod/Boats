<?php

_main_::depend('configs');
_main_::depend('sql');
_main_::depend('mailer_tasks//reads');
_main_::depend('mailer_tasks//enums');
_main_::depend('mailer_tasks//commons');

// Чтение конфига модуля, списков для полей выбора (для валидации и элементов формы) и других данных.
fetch_mailer_task_config($pathinfo[0], $config);
fetch_mailer_task_enums($enum);

// Формируем селекторы списка (фильтры и сортировки).
$filters = array('subject'=>null, 'message'=>null);
$sorters = array('id'=>true, 'progress'=>false, 'progress_done'=>false, 'progress_total'=>false, 'send_ts'=>true, 'stop_ts'=>true, 'subject'=>false, 'message'=>false);
_main_::put2dom('filters', $filters = get_requested_filters($filters));
_main_::put2dom('sorters', $sorters = get_requested_sorters($sorters));

// Считываем список записей и все их дочерние субтаблицы.
select_mailer_tasks_for_admin($dat, $filters, $sorters);

// В DOM!
_main_::put2dom('list', $dat);

?>