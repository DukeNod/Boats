<?php

_main_::depend('configs');
_main_::depend('merges');
_main_::depend('forms');
_main_::depend('mailer_files//reads');
_main_::depend('mailer_files//opers');
_main_::depend('mailer_files//forms');
_main_::depend('mailer_files//commons');

// Чтение исходных данных записи и всех её дочерних элементов при необходимости.
$id = isset($pathargs[0]) ? $pathargs[0] : null;
select_mailer_file_by_id($dat, $id, true, 'mailer_file_absent');
$info = array_shift($dat);// не бывает null, потому что required при select'е!

// Определение имени и нового значения поля, проверка их допустимости.
$fields = array();
$field  = isset($pathargs[1]) ? $pathargs[1] : null;
$value  = isset($pathargs[2]) ? $pathargs[2] : null;
if (!in_array($field, $fields)) throw new exception_bl("Unsupported field for switching ({$field}).", "unsupported_field");

// Определение запрошенных действий и получение присланных данных.
$errors = array();
$action = determine_action(null, 'do', true);
$defs   = array('mailer_task' => (($key = array_search('for', $pathargs)) !== false) && isset($pathargs[$key+1]) ? $pathargs[$key+1] : null);
$data   = array_merge_rol($defs, $info, array($field => $value));

// Чтение конфига модуля, списков для полей выбора (для валидации и элементов формы) и других данных.
fetch_mailer_file_config($pathinfo[0], $config);
fetch_mailer_file_enums($enum, $data['mailer_task']);
fetch_mailer_file_uplink($data['mailer_task'], $uplink);

// Типичный сценарий операции: подгонка файлов, проверка значений, и либо обращение к базе, либо временное запоминание.
if (($action === 'do') && !count($errors)) validate_mailer_file($errors, $data, $config, $enum, $uplink, true);
if (($action === 'do') && !count($errors))   switch_mailer_file($errors, $data, $id, $field, $value);

// В DOM!
$dom = compact('id', 'action', 'info', 'data', 'errors', 'field', 'value');
_main_::put2dom(($action === 'do') && !count($errors) ? 'done' : 'form', $dom);

?>