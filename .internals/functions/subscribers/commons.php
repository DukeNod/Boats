<?php

function fetch_subscriber_config ($keys, &$config)
{
	$fields = array('pager_size');
	$config = config_for_module($keys, $fields);
}

function fetch_subscriber_enums (&$enum)
{
	$enum = array();

	_main_::depend('subscribers//enums');
	enumerate_subscriber_groups($enum['subscriber_groups']);

	$enum['@for'] = 'subscribers';
	_main_::put2dom('enum', $enum);
}

?>