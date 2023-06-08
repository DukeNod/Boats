<?php

function fetch_mailer_task_config ($keys, &$config)
{
	$fields = array();
	$config = config_for_module($keys, $fields);
}

function fetch_mailer_task_enums (&$enum)
{
	$enum = array();

	_main_::depend('subscribers//enums');
	enumerate_subscriber_groups($enum['subscriber_groups']);

	$enum['@for'] = 'mailer_tasks';
	_main_::put2dom('enum', $enum);
}

?>