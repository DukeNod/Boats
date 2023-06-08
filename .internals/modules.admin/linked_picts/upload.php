<?php

_main_::depend('configs');
_main_::depend('merges');
_main_::depend('forms');
_main_::depend('uploads');
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
$data   = array_merge_rol($defs, $info, form_posted_linked_pict_upload($action));

// Чтение конфига модуля, списков для полей выбора (для валидации и элементов формы) и других данных.
$config = fetch_config_for_linked_picts($data['uplink_type']);
$enums  = fetch_enums_for_linked_picts ($data['uplink_type'], $data['uplink_id']);
$uplink = fetch_uplink_for_linked_picts($data['uplink_type'], $data['uplink_id']);

// debug($data); die;
// Типичный сценарий операции: подгонка файлов, проверка значений, и либо обращение к базе, либо временное запоминание.
// if (($action !== null)                   )  prepare_linked_pict($errors, $data, $config, $enums, $uplink);
if (($action === 'do') && !count($errors)) move_file_from_php_to_tmp($data['Filedata_path'], $data['Filedata_name'], "../../uploads/".$data['path']);

if ($action === 'do') die("FILEID:"."uploads/".$data['path']."/".$data['Filedata_name']);

// В DOM!
$dom = compact('id', 'action', 'info', 'data', 'errors', 'field', 'value', 'config');
$dom['@for'] = 'linked_picts';
_main_::put2dom(($action === 'do') && !count($errors) ? 'done' : (($action === 'list') ? 'list' : 'form'), $dom);

?>