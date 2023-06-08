<?php

_main_::depend('configs');
_main_::depend('merges');
_main_::depend('mailer_tasks//reads');
_main_::depend('mailer_tasks//commons');

// Чтение исходных данных записи и всех её дочерних элементов при необходимости.
$id = isset($pathargs[0]) ? $pathargs[0] : null;
select_mailer_task_by_id($dat, $id, true, 'mailer_task_absent');
select_mailer_tasks_details($dat);
$info = array_shift($dat);// не бывает null, потому что required при select'е!
$data = $info;// Important for our XSLT form templates!

// Чтение конфига модуля, списков для полей выбора (для валидации и элементов формы) и других данных.
fetch_mailer_task_config($pathinfo[0], $config);
fetch_mailer_task_enums($enum);

// В DOM!
$dom = compact('id', 'info', 'data');
_main_::put2dom('form', $dom);

?>