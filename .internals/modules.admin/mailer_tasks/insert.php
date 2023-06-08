<?php

_main_::depend('configs');
_main_::depend('merges');
_main_::depend('forms');
_main_::depend('mailer_tasks//reads');
_main_::depend('mailer_tasks//opers');
_main_::depend('mailer_tasks//forms');
_main_::depend('mailer_tasks//commons');

// Заглушки чтобы все алгоритмы ниже выглядели как в update (легче потом менять через copy-paste).
$id     = null;
$info   = null;

// Определение запрошенных действий и получение присланных данных.
$errors = array();
$action = determine_action(null, 'do');
$defs   = array();
$data   = array_merge_rol($defs, $info, form_posted_mailer_task($action));

// Чтение конфига модуля, списков для полей выбора (для валидации и элементов формы) и других данных.
fetch_mailer_task_config($pathinfo[0], $config);
fetch_mailer_task_enums($enum);

// Типичный сценарий операции: подгонка файлов, проверка значений, и либо обращение к базе, либо временное запоминание.
if (($action !== null)                   )  prepare_mailer_task($errors, $data, $config, $enum);
if (($action === 'do') && !count($errors)) validate_mailer_task($errors, $data, $config, $enum);
if (($action === 'do') && !count($errors))   insert_mailer_task($errors, $data, $id);
elseif (($action !== null)               ) remember_mailer_task($data);

// В DOM!
$dom = compact('id', 'action', 'info', 'data', 'errors', 'field', 'value');
_main_::put2dom(($action === 'do') && !count($errors) ? 'done' : 'form', $dom);

?>