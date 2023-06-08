<?php

_main_::depend('configs');
_main_::depend('merges');
_main_::depend('forms');
_main_::depend('sql');

$module_name = array_shift($pathargs);
$m = _main_::fetchModule($module_name);

// Определение запрошенных действий и получение присланных данных.
$errors = array();
$action = determine_action(array('move', 'toggle', 'delete'));
$defs   = array();
$data   = array_merge_rol($defs, $m->form_posted_multi($action));

$null = null;

// Чтение конфига модуля, списков для полей выбора (для валидации и элементов формы) и других данных.
$config = $m->fetch_config();
#$m->fetch_enums($enums);

// Типичный сценарий операции: подгонка файлов, проверка значений, и либо обращение к базе, либо временное запоминание.

if (($action === 'delete'))			$m->predelete($errors, $data, $config, $enums);
if (($action === 'delete') && !count($errors))	$m->delete($errors, $null, $data['items']);

// В DOM!
$dom = compact('id', 'action', 'info', 'data', 'errors', 'field', 'value');
$dom['@for'] = $m->essence;
_main_::put2dom($action && !count($errors) ? 'done' : 'form', $dom);

?>
