<?php

_main_::depend('configs');
_main_::depend('merges');
_main_::depend('forms');
$m=_main_::fetchModule('forms_list');

// Заглушки чтобы все алгоритмы ниже выглядели как в update (легче потом менять через copy-paste).
$id     = null;
$info   = null;

// Определение запрошенных действий и получение присланных данных.
$errors = array();
$action = determine_action(null, 'do');
$defs   = array();
$data   = array_merge_rol($defs, $info, $m->form_posted($action));


// Чтение конфига модуля, списков для полей выбора (для валидации и элементов формы) и других данных.
$config = $m->fetch_config();
$enums  = $m->fetch_enums(get_fields($data['production_list'], 'id'), get_fields($data['equipments_list'], 'id'));

// Типичный сценарий операции: подгонка файлов, проверка значений, и либо обращение к базе, либо временное запоминание.
if (($action !== null)                   ) $m->prepare($errors, $data, $config, $enums);
if (($action === 'do') && !count($errors)) $m->validate($errors, $data, $config, $enums);
if (($action === 'do') && !count($errors)) $m->insert($errors, $data, $id);
elseif (($action !== null)               ) $m->remember($data);

// В DOM!
$dom = compact('id', 'action', 'info', 'data', 'errors', 'field', 'value');
$dom['@for'] = $m->essence;
/*$dom['@for'] = 'info';*/
_main_::put2dom(($action === 'do') && !count($errors) ? 'done' : 'form', $dom);

?>