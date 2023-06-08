<?php

_main_::depend('configs');
_main_::depend('merges');
_main_::depend('forms');
_main_::depend('mailer_files//reads');
_main_::depend('mailer_files//opers');
_main_::depend('mailer_files//forms');
_main_::depend('mailer_files//commons');

// Заглушки чтобы все алгоритмы ниже выглядели как в update (легче потом менять через copy-paste).
$id     = null;
$info   = null;

// Определение запрошенных действий и получение присланных данных.
$errors = array();
$action = determine_action(null, 'do');
$defs   = array('mailer_task' => (($key = array_search('for', $pathargs)) !== false) && isset($pathargs[$key+1]) ? $pathargs[$key+1] : null);
$data   = array_merge_rol($defs, $info, form_posted_mailer_file($action));

// Чтение конфига модуля, списков для полей выбора (для валидации и элементов формы) и других данных.
fetch_mailer_file_config($pathinfo[0], $config);
fetch_mailer_file_enums($enum, $data['mailer_task']);
fetch_mailer_file_uplink($data['mailer_task'], $uplink);

// Типичный сценарий операции: подгонка файлов, проверка значений, и либо обращение к базе, либо временное запоминание.
if (($action !== null)                   )  prepare_mailer_file($errors, $data, $config, $enum, $uplink);
if (($action === 'do') && !count($errors)) validate_mailer_file($errors, $data, $config, $enum, $uplink);
if (($action === 'do') && !count($errors))   insert_mailer_file($errors, $data, $id);
elseif (($action !== null)               ) remember_mailer_file($data);

// В DOM!
$dom = compact('id', 'action', 'info', 'data', 'errors', 'field', 'value');
_main_::put2dom(($action === 'do') && !count($errors) ? 'done' : 'form', $dom);

?>