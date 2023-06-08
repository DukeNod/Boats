<?php

_main_::depend('configs');
_main_::depend('merges');
_main_::depend('forms');
_main_::depend('linked_picts//reads');
_main_::depend('linked_picts//opers');
_main_::depend('linked_picts//forms');
_main_::depend('linked_picts//commons');

// Чтение исходных данных записи и всех её дочерних элементов при необходимости.
$id = array_shift($pathargs);
select_linked_picts_by_ids($dat, $id, true, true);
$info = array_shift($dat);// не бывает null, потому что required при select'е!

// Определение запрошенных действий и получение присланных данных.
$errors = array();
$action = determine_action(null, 'do', in_array('now', $pathargs) ? true : null);
$defs   = array('uplink_type' => (($key = array_search('for', $pathargs)) !== false) && isset($pathargs[$key+1]) ? $pathargs[$key+1] : null,
		'uplink_id'   => (($key = array_search('for', $pathargs)) !== false) && isset($pathargs[$key+2]) ? $pathargs[$key+2] : null);
$data   = array_merge_rol($defs, $info);

// Чтение конфига модуля, списков для полей выбора (для валидации и элементов формы) и других данных.
$config = fetch_config_for_linked_picts($data['uplink_type']);
$enums  = fetch_enums_for_linked_picts ($data['uplink_type'], $data['uplink_id']);
$uplink = fetch_uplink_for_linked_picts($data['uplink_type'], $data['uplink_id']);

// Типичный сценарий операции: подгонка файлов, проверка значений, и либо обращение к базе, либо временное запоминание.
if (($action === 'do') && !count($errors)) predelete_linked_pict($errors, $data, $config, $enums, $uplink);
if (($action === 'do') && !count($errors))    delete_linked_pict($errors, $data, $id);

// В DOM!
$dom = compact('id', 'action', 'info', 'data', 'errors', 'field', 'value', 'config');
$dom['@for'] = 'linked_picts';
_main_::put2dom(($action === 'do') && !count($errors) ? 'done' : 'form', $dom);

?>