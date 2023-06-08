<?php

_main_::depend('configs');
_main_::depend('merges');
$m=_main_::fetchModule('meta');

// Чтение исходных данных записи и всех её дочерних элементов при необходимости.
$id = array_shift($pathargs);
$m->select_by_ids($dat, $id, true, true);
$info = array_shift($dat);// не бывает null, потому что required при select'е!
$data = $info;// Important for our XSLT form templates!

// Чтение конфига модуля, списков для полей выбора (для валидации и элементов формы) и других данных.
$config = $m->fetch_config();
$enums  = $m->fetch_enums();

// В DOM!
$dom = compact('id', 'info', 'data');
$dom['@for'] = $m->essence;
_main_::put2dom('form', $dom);

?>