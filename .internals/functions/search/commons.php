<?php

function fetch_search_config ($keys, &$config)
{
	$fields = array('trash_length', 'trash_words');
	$config = config_for_module($keys, $fields);
}

function fetch_search_enums (&$enums)
{
	$enum = array();

	//$m=&_main_::fetchModule('brands');
	//$m->select_for_select($enums['brands']);
	
	$enum['@for'] = 'search';
	_main_::put2dom('enums', $enums);
}

?>