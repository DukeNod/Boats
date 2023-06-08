<?php

_main_::depend('configs');
_main_::depend('merges');
_main_::depend('forms');
$m=_main_::fetchModule('form_fields');

// Чтение исходных данных записи и всех её дочерних элементов при необходимости.
$id = array_shift($pathargs);

$m->select_by_ids($dat, $id, true, array('production'=>array(), 'equipments'=>array(), '*'=>true));
$info = array_shift($dat);// не бывает null, потому что required при select'е!

// Определение запрошенных действий и получение присланных данных.

$errors = array();
$action = determine_action(null, 'do', in_array('now', $pathargs) ? true : null);
$defs   = array();
$data   = array_merge_rol($defs, $info);

// Чтение конфига модуля, списков для полей выбора (для валидации и элементов формы) и других данных.
$config = $m->fetch_config();
$enums  = $m->fetch_enums(get_fields($data['production_list'], 'id'), get_fields($data['equipments_list'], 'id'));

// Типичный сценарий операции: подгонка файлов, проверка значений, и либо обращение к базе, либо временное запоминание.
if (($action === 'do') && !count($errors)) $m->predelete($errors, $data, $config, $enums);
if (($action === 'do') && !count($errors)) $m->delete($errors, $data, $id);

// В DOM!
$dom = compact('id', 'action', 'info', 'data', 'errors', 'field', 'value');
$dom['@for'] = $m->essence;

_main_::put2dom(($action === 'do') && !count($errors) ? 'done' : 'form', $dom);

?>