<?php

_main_::depend('configs');
_main_::depend('merges');
_main_::depend('forms');
_main_::depend('subscribers//reads');
_main_::depend('subscribers//opers');
_main_::depend('subscribers//forms');
_main_::depend('subscribers//commons');

// Чтение исходных данных записи и всех её дочерних элементов при необходимости.
$id = isset($pathargs[0]) ? $pathargs[0] : null;
select_subscriber_by_id($dat, $id, true, 'subscriber_absent');
$info = array_shift($dat);// не бывает null, потому что required при select'е!

// Определение имени и нового значения поля, проверка их допустимости.
$fields = array('is_active', 'is_tester');
$field  = isset($pathargs[1]) ? $pathargs[1] : null;
$value  = isset($pathargs[2]) ? $pathargs[2] : null;
if (!in_array($field, $fields)) throw new exception_bl("Unsupported field for switching ({$field}).", "unsupported_field");

// Определение запрошенных действий и получение присланных данных.
$errors = array();
$action = determine_action(null, 'do', true);
$defs   = array('code'=>generate_subscriber_code());
$data   = array_merge_rol($defs, $info, array($field => $value));

// Чтение конфига модуля, списков для полей выбора (для валидации и элементов формы) и других данных.
fetch_subscriber_config($pathinfo[0], $config);
fetch_subscriber_enums($enum);

// Типичный сценарий операции: подгонка файлов, проверка значений, и либо обращение к базе, либо временное запоминание.
if (($action === 'do') && !count($errors)) validate_subscriber($errors, $data, $config, $enum, true);
if (($action === 'do') && !count($errors))   switch_subscriber($errors, $data, $id, $field, $value);

// В DOM!
$dom = compact('id', 'action', 'info', 'data', 'errors', 'field', 'value');
_main_::put2dom(($action === 'do') && !count($errors) ? 'done' : 'form', $dom);

?>