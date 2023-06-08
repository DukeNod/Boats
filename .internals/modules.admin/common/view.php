<?php

_main_::depend('configs');
_main_::depend('merges');
_main_::depend('sql');

$module_name = array_shift($pathargs);
$m = _main_::fetchModule($module_name);

// Чтение исходных данных записи и всех её дочерних элементов при необходимости.
$id = array_shift($pathargs);
$m->select_by_ids($dat, $id, true, $m->update_details);

$info = array_shift($dat);// не бывает null, потому что required при select'е!
$data = $info;// Important for our XSLT form templates!

// Чтение конфига модуля, списков для полей выбора (для валидации и элементов формы) и других данных.
$config = $m->fetch_config();
$m->fetch_enums($enums, $data);

// В DOM!
$dom = compact('id', 'info', 'data');

$dom['@for'] = $m->essence;
_main_::put2dom('form', $dom);
_main_::put2dom('module', $m->fields2dom($data));

_main_::set_module_xslt("/common/view");

?>