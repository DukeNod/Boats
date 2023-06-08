<?php
$u = _main_::fetchModule('users');
$u->check([ 'admin' ]);

// Читаем и выводим всестраничные данные до начала всех работ.
_main_::depend('_specific_/fetches');
fetch_every_page_content();
print_check($pathargs);

// Подключаем нужные функции.
_main_::depend('configs');
_main_::depend('merges');
_main_::depend('forms');
_main_::depend('search//forms');
_main_::depend('search//opers');
_main_::depend('search//commons');

// Определение запрошенных действий и получение присланных данных.
$errors = array();
$action = determine_action(null, 'do', (isset($_GET['text']) && strlen($_GET['text'])) || (count($pathargs)) ? true : null);
$data   = array_merge_rol(form_posted_search($action, implode(' ', $pathargs)));

// Чтение конфига модуля, списков для полей выбора (для валидации и элементов формы) и других данных.
fetch_search_config($pathinfo[0], $config);
fetch_search_enums($enum);

// Типичный сценарий операции: подгонка файлов, проверка значений, и либо обращение к базе, либо временное запоминание.
if (($action !== null)                   )  prepare_search($errors, $data, $config, $enum);
if (($action === 'do') && !count($errors)) validate_search($errors, $data, $config, $enum);
if (($action === 'do') && !count($errors))  perform_search($errors, $data, $doc, $results);
elseif (($action !== null)               ) remember_search($data);

// В DOM!
$dom = compact('action', 'data', 'errors', 'results');
_main_::put2dom(($action === 'do') && !count($errors) ? 'done' : 'form', $dom);

?>