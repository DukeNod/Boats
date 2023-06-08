<?php

_main_::depend('configs');
_main_::depend('merges');
_main_::depend('forms');
_main_::depend('multilang');
$m=_main_::fetchModule('pages');

// Чтение исходных данных записи и всех её дочерних элементов при необходимости.
$id = array_shift($pathargs);
$m->select_by_ids($dat, $id, true, null);
$info = array_shift($dat);// не бывает null, потому что required при select'е!

// Определение имени и нового значения поля, проверка их допустимости.
$fields = array('is_on_main');
$field  = array_shift($pathargs);
$value  = array_shift($pathargs);
if (!in_array($field, $fields)) throw new exception_bl("Unsupported field for toggling ({$field}).", "unsupported_field");

// Определение запрошенных действий и получение присланных данных.
$errors = array();
$action = determine_action(null, 'do', true);
$defs   = array();
$data   = array_merge_rol($defs, $info, array($field => $value));

// Чтение конфига модуля, списков для полей выбора (для валидации и элементов формы) и других данных.
$config = $m->fetch_config();
$enums  = $m->fetch_enums();

// Типичный сценарий операции: подгонка файлов, проверка значений, и либо обращение к базе, либо временное запоминание.
if (($action === 'do') && !count($errors)) $m->validate($errors, $data, $config, $enums, true);
if (($action === 'do') && !count($errors))   $m->toggle($errors, $data, $id, $field, $value);

// В DOM!
$dom = compact('id', 'action', 'info', 'data', 'errors', 'field', 'value');
$dom['@for'] = $m->essence;
_main_::put2dom(($action === 'do') && !count($errors) ? 'done' : 'form', $dom);

?>