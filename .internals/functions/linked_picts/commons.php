<?php

function fetch_config_for_linked_picts ($uplink_type)
{
	_main_::depend('configs');
	$fields = array('small_limit_w', 'small_limit_h', 'middle_limit_w', 'middle_limit_h', 'large_limit_w', 'large_limit_h','resize','limit','count','cut');
	$config = config_for_module(array('linked_picts', $uplink_type), $fields);

	// По умолчанию 2-е картинки, большая и малеькая
	if ($config['count'] === null) $config['count'] = 2;

	// По умолчанию нет лимита прилинкованых изображений.
	// Поддерживаются только значения 0 и 1. Т.е. одно изображение, или анлим.
	if ($config['limit'] === null) $config['limit'] = 0;

	return $config;
}

function fetch_enums_for_linked_picts ($uplink_type, $uplink_id)
{
	$enums = array('@for' => 'linked_picts');

	_main_::depend('linked_picts//enums');
	enumerate_linked_pict_siblings($enums['siblings'], $uplink_type, $uplink_id);
	
	_main_::put2dom('enums', $enums);
	return $enums;
}

function fetch_uplink_for_linked_picts ($uplink_type, $uplink_id)
{
	_main_::depend('linked//uplink');
	select_uplink_by_type_and_id($dat, $uplink_type, $uplink_id);

	$dat['@type'] = $uplink_type;
	$dat['@id'  ] = $uplink_id  ;
	_main_::put2dom('uplink', $dat);

	return array_shift($dat);
}

function linked_picts_include_prepare(&$errors, $uplink, $uplink_type, $uplink_id, &$dom)
{
        if (count($uplink['linked_picts']))
        {
        	linked_picts_update_prepare($errors, $uplink, $uplink_type, $dom);
        }else
        {
        	linked_picts_insert_prepare($errors, $uplink, $uplink_type, $uplink_id, $dom);
        }
}

function linked_picts_include(&$errors, &$dom, $uplink_id)
{
        if ($dom['update'])
        {
        	linked_picts_include_update($errors, $dom);
        }else
        {
        	linked_picts_include_insert($errors, $dom, $uplink_id);
        }
}

function linked_picts_update_prepare(&$errors, &$uplink, $uplink_type, &$dom)
{
	$id = $uplink['linked_picts']['linked_pict:0']['id'];

	_main_::depend('linked_picts//reads');
	_main_::depend('linked_picts//opers');
	_main_::depend('linked_picts//forms');

	select_linked_picts_by_ids($dat, $id, true, true);
	$info = array_shift($dat);// не бывает null, потому что required при select'е!

	// Определение запрошенных действий и получение присланных данных.
	$action = determine_action(null, 'do');
	$defs   = array('uplink_type' => $uplink_type,
			'uplink_id'   => $id);
	$data   = array_merge_rol($defs, $info, form_posted_linked_pict($action));
	$data['position'] = 1;

	// Чтение конфига модуля, списков для полей выбора (для валидации и элементов формы) и других данных.
	$config = fetch_config_for_linked_picts($data['uplink_type']);
	$enums  = fetch_enums_for_linked_picts ($data['uplink_type'], $data['uplink_id']);
	//$uplink = fetch_uplink_for_linked_picts($data['uplink_type'], $data['uplink_id']);

	// Типичный сценарий операции: подгонка файлов, проверка значений, и либо обращение к базе, либо временное запоминание.
	if (($action !== null)                   )  prepare_linked_pict($errors, $data, $config, $enums, $uplink);
	if (($action === 'do') && !count($errors)) validate_linked_pict($errors, $data, $config, $enums, $uplink);

	$update = true;

	// В DOM!
	$dom = compact('id', 'action', 'info', 'data', 'field', 'value', 'config', 'update');
	$dom['@for'] = 'linked_picts';
}

function linked_picts_include_update(&$errors, &$dom)
{
	if (($dom['action'] === 'do') && !count($errors))   update_linked_pict($errors, $dom['data'], $dom['id'], $dom['info']);
	elseif (($dom['action'] !== null)               ) remember_linked_pict($dom['data']);
}

function linked_picts_insert_prepare(&$errors, &$uplink, $uplink_type, $id, &$dom)
{
	_main_::depend('linked_picts//reads');
	_main_::depend('linked_picts//opers');
	_main_::depend('linked_picts//forms');

	// Заглушки чтобы все алгоритмы ниже выглядели как в update (легче потом менять через copy-paste).
	$info   = null;
	if ($id == null) $id = 999; // тупой фокус что обойти проверку на наличие аплинка (потом верну null)

	// Определение запрошенных действий и получение присланных данных.
	$action = determine_action(null, 'do');
	$defs   = array('uplink_type' => $uplink_type,
			'uplink_id'   => $id);
	$data   = array_merge_rol($defs, $info, form_posted_linked_pict($action));
	$data['position'] = 1;

	// Чтение конфига модуля, списков для полей выбора (для валидации и элементов формы) и других данных.
	$config = fetch_config_for_linked_picts($data['uplink_type']);
	//$enums  = fetch_enums_for_linked_picts ($data['uplink_type'], $data['uplink_id']);
	$enums  = array('siblings' => array());
	// $uplink = fetch_uplink_for_linked_picts($data['uplink_type'], $data['uplink_id']);

	// Типичный сценарий операции: подгонка файлов, проверка значений, и либо обращение к базе, либо временное запоминание.
	if (($action !== null)                   )  prepare_linked_pict($errors, $data, $config, $enums, $uplink);
	if (($action === 'do') && !count($errors)) validate_linked_pict($errors, $data, $config, $enums, $uplink);

	$update = false;
	$data['uplink_id'] = null;

	// В DOM!
	$dom = compact('action', 'info', 'data', 'field', 'value', 'config', 'update');
	$dom['@for'] = 'linked_picts';
}

function linked_picts_include_insert(&$errors, &$dom, $uplink_id)
{
	$dom['data']['uplink_id'] = $uplink_id;

	if (($dom['action'] === 'do') && !count($errors))   insert_linked_pict($errors, $dom['data'], $uplink_id);
	elseif (($dom['action'] !== null)               ) remember_linked_pict($dom['data']);

	$dom['id'] = $uplink_id;
}
?>