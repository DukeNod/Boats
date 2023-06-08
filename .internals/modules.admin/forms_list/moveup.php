<?php

_main_::depend('configs');
_main_::depend('merges');
_main_::depend('forms');
$m=_main_::fetchModule('forms_list');
/*_main_::depend('info//reads');
_main_::depend('info//opers');
_main_::depend('info//commons');*/

// Чтение исходных данных записи и всех её дочерних элементов при необходимости.
$id = array_shift($pathargs);
$m->select_by_ids($dat, $id, true, null);
/*select_info_by_ids($dat, $id, true, true);*/
$info = array_shift($dat);// не бывает null, потому что required при select'е!

// Определение запрошенных действий и получение присланных данных.
$errors = array();
$action = determine_action(null, 'do', true);
$defs   = array();
$data   = array_merge_rol($defs, $info);

// Чтение конфига модуля, списков для полей выбора (для валидации и элементов формы) и других данных.
$config = $m->fetch_config();
$enums  = $m->fetch_enums();
/*$config = fetch_config_for_info();
$enums  = fetch_enums_for_info();*/

// Типичный сценарий операции: подгонка файлов, проверка значений, и либо обращение к базе, либо временное запоминание.
if (($action === 'do') && !count($errors)) $m->moveup($errors, $data, $id);

// В DOM!
$dom = compact('id', 'action', 'info', 'data', 'errors', 'field', 'value');
$dom['@for'] = $m->essence;
/*$dom['@for'] = 'info';*/
_main_::put2dom(($action === 'do') && !count($errors) ? 'done' : 'form', $dom);

?>