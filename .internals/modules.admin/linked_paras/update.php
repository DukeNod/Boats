<?php

_main_::depend('configs');
_main_::depend('merges');
_main_::depend('forms');
_main_::depend('linked_paras//reads');
_main_::depend('linked_paras//opers');
_main_::depend('linked_paras//forms');
_main_::depend('linked_paras//commons');

// Чтение исходных данных записи и всех её дочерних элементов при необходимости.
$id = array_shift($pathargs);
select_linked_paras_by_ids($dat, $id, true, true);
$info = array_shift($dat);// не бывает null, потому что required при select'е!

// Определение запрошенных действий и получение присланных данных.
$errors = array();
$action = determine_action(null, 'do');
$defs   = array('uplink_type' => (($key = array_search('for', $pathargs)) !== false) && isset($pathargs[$key+1]) ? $pathargs[$key+1] : null,
		'uplink_id'   => (($key = array_search('for', $pathargs)) !== false) && isset($pathargs[$key+2]) ? $pathargs[$key+2] : null);
$data   = array_merge_rol($defs, $info, form_posted_linked_para($action));

// Чтение конфига модуля, списков для полей выбора (для валидации и элементов формы) и других данных.
$config = fetch_config_for_linked_paras($data['uplink_type']);
$enums  = fetch_enums_for_linked_paras ($data['uplink_type'], $data['uplink_id']);
$uplink = fetch_uplink_for_linked_paras($data['uplink_type'], $data['uplink_id']);

// Типичный сценарий операции: подгонка файлов, проверка значений, и либо обращение к базе, либо временное запоминание.
if (($action !== null)                   )  prepare_linked_para($errors, $data, $config, $enums, $uplink);
if (($action === 'do') && !count($errors)) validate_linked_para($errors, $data, $config, $enums, $uplink);
if (($action === 'do') && !count($errors))   update_linked_para($errors, $data, $id, $info);
elseif (($action !== null)               ) remember_linked_para($data);

// В DOM!
$dom = compact('id', 'action', 'info', 'config', 'data', 'errors', 'field', 'value');
$dom['@for'] = 'linked_paras';
_main_::put2dom(($action === 'do') && !count($errors) ? 'done' : 'form', $dom);

?>