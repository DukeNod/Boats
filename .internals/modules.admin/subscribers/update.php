<?php

_main_::depend('configs');
_main_::depend('merges');
_main_::depend('forms');
_main_::depend('subscribers//reads');
_main_::depend('subscribers//opers');
_main_::depend('subscribers//forms');
_main_::depend('subscribers//commons');

// Чтение исходных данных записи и всех её дочерних элементов при необходимости.
$id = isset($pathargs[0]) ? $pathargs[0] : null;
select_subscriber_by_id($dat, $id, true, 'subscriber_absent');
select_subscribers_details($dat);
$info = array_shift($dat);// не бывает null, потому что required при select'е!

// Определение запрошенных действий и получение присланных данных.
$errors = array();
$action = determine_action(null, 'do');
$defs   = array('code'=>generate_subscriber_code());
$data   = array_merge_rol($defs, $info, form_posted_subscriber($action));

// Чтение конфига модуля, списков для полей выбора (для валидации и элементов формы) и других данных.
fetch_subscriber_config($pathinfo[0], $config);
fetch_subscriber_enums($enum);

// Типичный сценарий операции: подгонка файлов, проверка значений, и либо обращение к базе, либо временное запоминание.
if (($action !== null)                   )  prepare_subscriber($errors, $data, $config, $enum);
if (($action === 'do') && !count($errors)) validate_subscriber($errors, $data, $config, $enum);
if (($action === 'do') && !count($errors))   update_subscriber($errors, $data, $id, $info);
elseif (($action !== null)               ) remember_subscriber($data);

// В DOM!
$dom = compact('id', 'action', 'info', 'data', 'errors', 'field', 'value');
_main_::put2dom(($action === 'do') && !count($errors) ? 'done' : 'form', $dom);

?>