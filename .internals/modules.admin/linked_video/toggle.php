<?php

_main_::depend('configs');
_main_::depend('merges');
_main_::depend('forms');
_main_::depend('linked_video//reads');
_main_::depend('linked_video//opers');
_main_::depend('linked_video//forms');
_main_::depend('linked_video//commons');

// Чтение исходных данных записи и всех её дочерних элементов при необходимости.
$id = array_shift($pathargs);
select_linked_video_by_ids($dat, $id, true, true);
$info = array_shift($dat);// не бывает null, потому что required при select'е!

// Определение имени и нового значения поля, проверка их допустимости.
$fields = array();
$field  = array_shift($pathargs);
$value  = array_shift($pathargs);
if (!in_array($field, $fields)) throw new exception_bl("Unsupported field for toggling ({$field}).", "unsupported_field");

// Определение запрошенных действий и получение присланных данных.
$errors = array();
$action = determine_action(null, 'do', true);
$defs   = array('uplink_type' => (($key = array_search('for', $pathargs)) !== false) && isset($pathargs[$key+1]) ? $pathargs[$key+1] : null,
		'uplink_id'   => (($key = array_search('for', $pathargs)) !== false) && isset($pathargs[$key+2]) ? $pathargs[$key+2] : null);
$data   = array_merge_rol($defs, $info, array($field => $value));

// Чтение конфига модуля, списков для полей выбора (для валидации и элементов формы) и других данных.
$config = fetch_config_for_linked_video($data['uplink_type']);
$enums  = fetch_enums_for_linked_video ($data['uplink_type'], $data['uplink_id']);
$uplink = fetch_uplink_for_linked_video($data['uplink_type'], $data['uplink_id']);

// Типичный сценарий операции: подгонка файлов, проверка значений, и либо обращение к базе, либо временное запоминание.
if (($action === 'do') && !count($errors)) validate_linked_video($errors, $data, $config, $enums, $uplink, true);
if (($action === 'do') && !count($errors))   toggle_linked_video($errors, $data, $id, $field, $value);

// В DOM!
$dom = compact('id', 'action', 'info', 'data', 'errors', 'field', 'value');
$dom['@for'] = 'linked_video';
_main_::put2dom(($action === 'do') && !count($errors) ? 'done' : 'form', $dom);

?>