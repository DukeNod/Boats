<?php

_main_::depend('configs');
_main_::depend('merges');
_main_::depend('forms');
_main_::depend('mailer_tasks//reads');
_main_::depend('mailer_tasks//opers');
_main_::depend('mailer_tasks//forms');
_main_::depend('mailer_tasks//commons');

// „тение исходных данных записи и всех еЄ дочерних элементов при необходимости.
$id = isset($pathargs[0]) ? $pathargs[0] : null;
select_mailer_task_by_id($dat, $id, true, 'mailer_task_absent');
select_mailer_tasks_details($dat);
$info = array_shift($dat);// не бывает null, потому что required при select'е!

// ѕровер€ем принципиальную допустимость как выполнени€ операции, так и вывода формы.
if (strlen($info['stop_ts'])) // Ќаличие (not null) даты останова означает что задание остановлено или закончено.
	throw new exception_bl("Operation prohibited (task done).", "mailer_task_stop");
if (strlen($info['send_ts'])) // Ќаличие (not null) даты запуска означает что задание уже в обработке и измен€ть поздно.
	throw new exception_bl("Operation prohibited (task is in work).", "mailer_task_send");

// ќпределение запрошенных действий и получение присланных данных.
$errors = array();
$action = determine_action(null, 'do');
$defs   = array();
$data   = array_merge_rol($defs, $info, form_posted_mailer_task($action));

// „тение конфига модул€, списков дл€ полей выбора (дл€ валидации и элементов формы) и других данных.
fetch_mailer_task_config($pathinfo[0], $config);
fetch_mailer_task_enums($enum);

// “ипичный сценарий операции: подгонка файлов, проверка значений, и либо обращение к базе, либо временное запоминание.
if (($action !== null)                   )  prepare_mailer_task($errors, $data, $config, $enum);
if (($action === 'do') && !count($errors)) validate_mailer_task($errors, $data, $config, $enum);
if (($action === 'do') && !count($errors))   update_mailer_task($errors, $data, $id, $info);
elseif (($action !== null)               ) remember_mailer_task($data);

// ¬ DOM!
$dom = compact('id', 'action', 'info', 'data', 'errors', 'field', 'value');
_main_::put2dom(($action === 'do') && !count($errors) ? 'done' : 'form', $dom);

?>