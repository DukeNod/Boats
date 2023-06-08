<?php

_main_::depend('configs');
_main_::depend('merges');
_main_::depend('forms');
_main_::depend('subscribers//reads');
_main_::depend('subscribers//opers');
_main_::depend('subscribers//forms');
_main_::depend('subscribers//commons');

// Определение запрошенных действий и получение присланных данных.
$errors = array();
$action = determine_action(null, 'do');
$data   = form_posted_import($action);

// Чтение конфига модуля, списков для полей выбора (для валидации и элементов формы) и других данных.
fetch_subscriber_config($pathinfo[0], $config);
fetch_subscriber_enums($enum);

// Типичный сценарий операции: подгонка файлов, проверка значений, и либо обращение к базе, либо временное запоминание.
if (($action !== null)                   )  prepare_import($errors, $data, $config, $enum);
if (($action === 'do') && !count($errors))   $result = import_subscribers($errors, $data);


// В DOM!
$dom = compact('id', 'action', 'errors', 'result');
_main_::put2dom(($action === 'do') && !count($errors) ? 'done' : 'form', $dom);

?>