<?php

function fetch_config_for_linked_files ($uplink_type)
{
	_main_::depend('configs');
	$fields = array('attach_limit_size', 'preview_limit_w', 'preview_limit_h');
	return config_for_module(array('linked_files', $uplink_type), $fields);
}

function fetch_enums_for_linked_files ($uplink_type, $uplink_id)
{
	$enums = array('@for' => 'linked_files');

	_main_::depend('linked_files//enums');
	enumerate_linked_file_siblings($enums['siblings'], $uplink_type, $uplink_id);
	
	_main_::put2dom('enums', $enums);
	return $enums;
}

function fetch_uplink_for_linked_files ($uplink_type, $uplink_id)
{
	_main_::depend('linked//uplink');
	select_uplink_by_type_and_id($dat, $uplink_type, $uplink_id);

	$dat['@type'] = $uplink_type;
	$dat['@id'  ] = $uplink_id  ;
	_main_::put2dom('uplink', $dat);

	return array_shift($dat);
}

?>