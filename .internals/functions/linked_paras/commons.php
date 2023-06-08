<?php

function fetch_config_for_linked_paras ($uplink_type)
{
	_main_::depend('configs');
	$fields = array('small_limit_w', 'small_limit_h', 'large_limit_w', 'large_limit_h','resize','limit','count');
	$config = config_for_module(array('linked_paras', $uplink_type), $fields);

	// По умолчанию 2-е картинки, большая и малеькая
	if ($config['count'] === null) $config['count'] = 2;

	// По умолчанию нет лимита прилинкованых изображений.
	// Поддерживаются только значения 0 и 1. Т.е. одно изображение, или анлим.
	if ($config['limit'] === null) $config['limit'] = 0;

	return $config;
}

function fetch_enums_for_linked_paras ($uplink_type, $uplink_id)
{
	$enums = array('@for' => 'linked_paras');

	_main_::depend('linked_paras//enums');
	enumerate_linked_para_siblings($enums['siblings'], $uplink_type, $uplink_id);
	_main_::put2dom('enums', $enums);
	return $enums;
}

function fetch_uplink_for_linked_paras ($uplink_type, $uplink_id)
{
	_main_::depend('linked//uplink');
	select_uplink_by_type_and_id($dat, $uplink_type, $uplink_id);

	$dat['@type'] = $uplink_type;
	$dat['@id'  ] = $uplink_id  ;
	_main_::put2dom('uplink', $dat);

	return array_shift($dat);
}

?>