<?php

_main_::depend('configs');
_main_::depend('merges');
_main_::depend('forms');
_main_::depend('linked_picts//reads');
_main_::depend('linked_picts//opers');
_main_::depend('linked_picts//forms');
_main_::depend('linked_picts//commons');

// Заглушки чтобы все алгоритмы ниже выглядели как в update (легче потом менять через copy-paste).
$id     = null;
$info   = null;

// Определение запрошенных действий и получение присланных данных.
$errors = array();
$action = determine_action(null, 'do');
$defs   = array('uplink_type' => (($key = array_search('for', $pathargs)) !== false) && isset($pathargs[$key+1]) ? $pathargs[$key+1] : null,
		'uplink_id'   => (($key = array_search('for', $pathargs)) !== false) && isset($pathargs[$key+2]) ? $pathargs[$key+2] : null);
$data   = array_merge_rol($defs, $info, form_posted_linked_pict($action));

// Чтение конфига модуля, списков для полей выбора (для валидации и элементов формы) и других данных.
$config = fetch_config_for_linked_picts($data['uplink_type']);
$enums  = fetch_enums_for_linked_picts ($data['uplink_type'], $data['uplink_id']);
$uplink = fetch_uplink_for_linked_picts($data['uplink_type'], $data['uplink_id']);

// Типичный сценарий операции: подгонка файлов, проверка значений, и либо обращение к базе, либо временное запоминание.
if (($action !== null)                   )  prepare_linked_pict($errors, $data, $config, $enums, $uplink);
if (($action === 'do') && !count($errors)) validate_linked_pict($errors, $data, $config, $enums, $uplink);
if (($action === 'do') && !count($errors))   insert_linked_pict($errors, $data, $id);
elseif (($action !== null)               ) remember_linked_pict($data);


// В DOM!
$dom = compact('id', 'action', 'info', 'data', 'errors', 'field', 'value', 'config');
$dom['@for'] = 'linked_picts';
_main_::put2dom(($action === 'do') && !count($errors) ? 'done' : 'form', $dom);

?>