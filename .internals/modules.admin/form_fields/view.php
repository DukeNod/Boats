<?php

_main_::depend('configs');
_main_::depend('merges');
$m=_main_::fetchModule('form_fields');
/*_main_::depend('info//reads');
_main_::depend('info//commons');*/

// Чтение исходных данных записи и всех её дочерних элементов при необходимости.
$id = array_shift($pathargs);
$m->select_by_ids($dat, $id, true, array('production'=>array(), 'equipments'=>array(), '*'=>true));
/*select_info_by_ids($dat, $id, true, true);*/
$info = array_shift($dat);// не бывает null, потому что required при select'е!
$data = $info;// Important for our XSLT form templates!

// Чтение конфига модуля, списков для полей выбора (для валидации и элементов формы) и других данных.
$config = $m->fetch_config();
$enums  = $m->fetch_enums(get_fields($data['production_list'], 'id'), get_fields($data['equipments_list'], 'id'));
/*$config = fetch_config_for_info();
$enums  = fetch_enums_for_info();*/

// В DOM!
$dom = compact('id', 'info', 'data');
/*$dom['@for'] = 'info';*/
$dom['@for'] = $m->essence;
_main_::put2dom('form', $dom);

?>