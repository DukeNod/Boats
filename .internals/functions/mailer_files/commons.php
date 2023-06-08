<?php

function fetch_mailer_file_config ($keys, &$config)
{
	$fields = array('attach_limit_size');
	$config = config_for_module($keys, $fields);
}

function fetch_mailer_file_enums (&$enum, $mailer_task)
{
	$enum = array();

	_main_::depend('mailer_files//enums');
	enumerate_mailer_file_siblings($enum['siblings'], $mailer_task);

	$enum['@for'] = 'mailer_files';
	_main_::put2dom('enum', $enum);
}

function fetch_mailer_file_uplink ($id, &$data = null)
{
	_main_::depend('mailer_tasks//reads');
	select_mailer_task_by_id($dat, $id);//NB: no exception, not required!

	$data = reset($dat);
	if ($data === false) $data = null;
	
	$dat['@id'] = $id;
	_main_::put2dom('uplink', $dat);
}

?>