<?php

_main_::depend('configs');
_main_::depend('merges');
_main_::depend('forms');
_main_::depend('sql');

$module_name = array_shift($pathargs);
$m = _main_::fetchModule($module_name);

// Чтение исходных данных записи и всех её дочерних элементов при необходимости.
$id = array_shift($pathargs);
$m->select_by_ids($dat, $id, true, $m->update_details);
	
$info = array_shift($dat);// не бывает null, потому что required при select'е!

// Определение запрошенных действий и получение присланных данных.
$errors = array();
$action = determine_action(null, 'do');
#$defs   = array();
$data   = array_merge_rol($m->defs(), $info, $m->form_posted($action));

// Чтение конфига модуля, списков для полей выбора (для валидации и элементов формы) и других данных.
$config = $m->fetch_config();
$m->fetch_enums($enums, $data);

#_main_::depend('linked_paras//commons'); $enum_unused = fetch_enums_for_linked_paras($m->outfield, $id);
#_main_::depend('linked_picts//commons'); $enum_unused = fetch_enums_for_linked_picts($m->outfield, $id);
#_main_::depend('linked_files//commons'); $enum_unused = fetch_enums_for_linked_files($m->outfield, $id);

// Типичный сценарий операции: подгонка файлов, проверка значений, и либо обращение к базе, либо временное запоминание.
if (($action !== null)                   )  $m->prepare($errors, $data, $config, $enums);
if (($action === 'do') && !count($errors)) $m->validate($errors, $data, $config, $enums);
if (($action === 'do') && !count($errors))   $m->update($errors, $data, $id, $info);
elseif (($action !== null)               ) $m->remember($data);

// В DOM!
$dom = compact('id', 'action', 'info', 'data', 'errors', 'field', 'value');
$dom['@for'] = $m->essence;

_main_::put2dom(($action === 'do') && !count($errors) ? 'done' : 'form', $dom);
_main_::put2dom('module', $m->fields2dom($data));

if (_main_::$module_xslt == '../../.internals/modules.admin//.xslt')
	_main_::set_module_xslt("/common/update");
?>