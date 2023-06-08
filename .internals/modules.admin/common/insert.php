<?php

_main_::depend('configs');
_main_::depend('merges');
_main_::depend('forms');
_main_::depend('sql');

$module_name = array_shift($pathargs);
$m = _main_::fetchModule($module_name);
$m->isInsert = true;

// Заглушки чтобы все алгоритмы ниже выглядели как в update (легче потом менять через copy-paste).
$id     = null;
$info   = null;

// Определение запрошенных действий и получение присланных данных.
$errors = array();
$action = determine_action(null, 'do');
#$defs   = array();
$data   = array_merge_rol($m->defs(), $info, $m->form_posted($action));

// Чтение конфига модуля, списков для полей выбора (для валидации и элементов формы) и других данных.
$config = $m->fetch_config();
$m->fetch_enums($enums, $data);

// Типичный сценарий операции: подгонка файлов, проверка значений, и либо обращение к базе, либо временное запоминание.
if (($action !== null)                   ) $m->prepare($errors, $data, $config, $enums);
if (($action === 'do') && !count($errors)) $m->validate($errors, $data, $config, $enums);
if (($action === 'do') && !count($errors)) $m->insert($errors, $data, $id);
elseif (($action !== null)               ) $m->remember($data);

// В DOM!
$dom = compact('id', 'action', 'info', 'data', 'errors', 'field', 'value');
$dom['@for'] = $m->essence;
_main_::put2dom(($action === 'do') && !count($errors) ? 'done' : 'form', $dom);
_main_::put2dom('module', $m->fields2dom($data));

_main_::set_module_xslt("/common/insert");
?>